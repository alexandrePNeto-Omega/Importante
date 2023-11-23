-- CREATE TYPE public.omega_setof_cmv_01 AS
-- (
	-- grid bigint,
	-- mlid bigint,
	-- deposito bigint,
	-- data date,
	-- turno integer,
	-- operacao text,
	-- documento text,
	-- quantidade double precision,
	-- preco_unit double precision,
	-- preco_unit_fiscal double precision

-- );


create or replace function get_cmv(bigint, bigint,date,date, bigint)
-- 1 emnpresa
-- 2 produto
-- 3 data ini
-- 4 data fim
-- 5 deposito
RETURNS double precision
    LANGUAGE 'plpgsql'

    COST 100000
    VOLATILE 
AS $BODY$

DECLARE

	estoque double precision := 0.0;
	custo double precision := 0.0;
	cmv double precision := 0.0;
	qtdeparc double precision := 0.0;
	preco_unit double precision := 0.0;
	estoque_ativo record;
	qtde_sem_custo double precision := 0.0;
	data_invalida record;
	req_estoque_emp record;
	preco_custo_empresa double precision := 0.0;
	operacao text;
	flag_cmv_considera_transf_venda boolean := false;
	
	estoque_atual double precision := 0.0;
	data_estoque date;
	
	rs_custo_medio record;
	rs record;
	
	reg omega_setof_cmv_01%ROWTYPE;
	
	movimenta_mais_deposito RECORD;
	
	where_text text := 'AND TRUE';
	sql_query text;
	
	ret_testa_entrada boolean := false;
	ret_testa_venda_estoque_cmv boolean := false;
	rec_testa_venda_estoque_cmv record;
	found_testa_entrada record;
	
	-- Acumula a quantidade vendida sem preço de custo. Ex: Vendas realizadas antes 
	-- de registrar a primeira entrada de notas do produto.


BEGIN

	select ativo INTO estoque_ativo from estoque_controle order by data_ult_exec desc limit 1;

	IF estoque_ativo.ativo = 'true' THEN
	
		select data INTO data_invalida from estoque_invalida where empresa=$1 and produto=$2;
		
		IF data_invalida.data is not null AND data_invalida.data <= $3 THEN
			data_estoque := (data_invalida.data::date -1);
		ELSE
			data_estoque := ($3::date -1);
		END IF;
		
		-- Tentativa 1: Tabela estoque_valor, data igual
		--raise notice 'TENTATIVA, %', '1';
		select data, ult_custo_medio as custo_medio, coalesce(estoque_valor.estoque,0) as estoque_atual into rs_custo_medio from estoque_valor where empresa=$1 and produto=$2 and data<=$4 and data=data_estoque::date;
		
		-- Tentativa 2: Tabela estoque_valor, data anterior
		IF NOT FOUND THEN
			--raise notice 'TENTATIVA, %', '2';
			select data, ult_custo_medio as custo_medio, coalesce(estoque_valor.estoque,0) as estoque_atual into rs_custo_medio from estoque_valor where empresa=$1 and produto=$2 and data<=$4 and data=(data_estoque::date - '1 day'::interval);
		
			-- Tentativa 3: Tabela estoque_valor, data menor
			IF NOT FOUND THEN
				--raise notice 'TENTATIVA, %', '3';
				select data, ult_custo_medio as custo_medio, coalesce(estoque_valor.estoque,0) as estoque_atual into rs_custo_medio from estoque_valor where empresa=$1 and produto=$2 and data<=$4 and data<data_estoque order by data desc limit 1;
				
				--Tentativa 4: Tabela estoque_valor, período
				IF NOT FOUND THEN
					--raise notice 'TENTATIVA, %', '4';
					select data, ult_custo_medio as custo_medio, coalesce(estoque_valor.estoque,0) as estoque_atual into rs_custo_medio from estoque_valor where empresa=$1 and produto=$2 and data<=$4 and data >= data_estoque;
				
					--Tentativa 5: Tabela estoque_valor, data igual
					IF NOT FOUND THEN
						--raise notice 'TENTATIVA, %', '5';
						select data, custo_medio, quantidade, coalesce(estoque.quantidade,0) as estoque_atual into rs_custo_medio from estoque where not custo_medio is null and data < $3 and empresa=$1 and produto=$2 order by data desc limit 1;
					END IF;

				END IF;

			END IF;
				
		END IF;

		IF rs_custo_medio is not null THEN

			custo := round(rs_custo_medio.custo_medio::numeric, 8);
			estoque := rs_custo_medio.estoque_atual;
			where_text := 'and data>'''||rs_custo_medio.data||'''';

		ELSE
			-- Campo custo_medio nao encontrado na tabela estoque para o produto %r (grid)" % produto
			-- Otimização do calculo do custo medio não terá efeito
			rs_custo_medio := NULL;
		END IF;

	ELSE
		-- Tabela de estoque não está ativa.
		rs_custo_medio := NULL;
	END IF;

	IF $5 IS NULL THEN
		
		IF estoque_ativo.ativo = 'true' THEN
			select count(t.deposito) INTO movimenta_mais_deposito from (select deposito from estoque_deposito where empresa=$1 AND produto=$2 and data<=$4 group by deposito) t having count(*)>1;
		ELSE
			select count(t.deposito) INTO movimenta_mais_deposito from (select deposito from lancto where empresa=$1 AND produto=$2 and data<=$4 group by deposito) t having count(*)>1;
		END IF;
		
	END IF; -- LINHA 1620

	sql_query := format('select grid, mlid, deposito, data, turno, operacao, documento, quantidade, preco_unit, coalesce(preco_unit_fiscal, 0) as preco_unit_fiscal from lancto l where empresa=%s and produto=%s and data<=''%s'' %s order by data, turno, hora, grid', $1, $2, $4, where_text);

	EXECUTE 'CREATE TEMP TABLE omega_movimento_produto AS '||sql_query;

	FOR reg in select * from omega_movimento_produto
	
	LOOP
	
		--drop table omega_movimento_produto;

		-- Testa se o lançamento informado eh efetivamente uma entrada no estoque que ira interferir no custo medio das mercadorias vendidas
		if reg.quantidade is not null and reg.preco_unit is not null THEN

			ret_testa_entrada := false;

			if reg.operacao = 'E' THEN
				ret_testa_entrada := true;

			ELSIF reg.operacao = 'TE' THEN

				IF reg.mlid is null THEN
					ret_testa_entrada := true;
				ELSE

					select l.grid into found_testa_entrada from lancto l where l.empresa=$1 and l.mlid=reg.mlid and l.produto=$2 and l.operacao='TS';
					IF NOT FOUND THEN
						ret_testa_entrada := true;
					END IF;
				END IF;

			END IF;

		END IF;

		IF ret_testa_entrada = true THEN
			IF estoque <= 0 or custo = 0.0 THEN
				custo := round(reg.preco_unit::numeric,8);
			ELSE
				estoque_atual := estoque + reg.quantidade;
				preco_unit := reg.preco_unit;
				
				custo := ((estoque * custo) + (reg.quantidade * preco_unit)) / estoque_atual;
				custo := round(custo::numeric,8);

				-- aqui if para vendedor

				-- aqui if para cliente
			END IF;
			qtdeparc := 0.0;
		END IF;
		-- No primeiro custo que achar, caso haja quantidade sem custo, soma toda
		-- essa quantidade vezes o custo no CMV
		IF custo != 0 and qtde_sem_custo != 0 THEN

			IF $5 is null or reg.deposito = $5 THEN
				cmv := (cmv + round((qtde_sem_custo * custo)::numeric, 8));
				qtde_sem_custo := 0.0;
			END IF;

		END IF;

		-- Estoque no momento após o lançamento
		IF reg.operacao IN ('V', 'C', 'P', 'DF', 'TS', 'B', 'SD', 'SR', 'DG') THEN
			operacao := 'S';
		ELSIF reg.operacao IN ('E', 'S', 'TE', 'DC', 'O', 'ED', 'ER') THEN
			operacao := 'E';
		ELSIF reg.operacao = 'F' THEN
			operacao := 'F';
		ELSIF reg.operacao IN ('I','M') THEN
			operacao := 'I';
		ELSE
			operacao := 'N';
		END IF;

		IF reg.quantidade is null THEN
			estoque := estoque;
		ELSIF operacao = 'S' THEN
			estoque := estoque - reg.quantidade;
		ELSIF operacao = 'E' THEN
			estoque := estoque + reg.quantidade;
		ELSIF operacao = 'F' THEN
			estoque := 0;
		ELSIF operacao = 'I' THEN
			estoque := reg.quantidade;
		END IF;

		IF estoque_ativo.ativo = 'true' AND movimenta_mais_deposito is not null and reg.operacao in ('M','I') THEN
			select round(estoque_emp::numeric,2) into req_estoque_emp from estoque_lancto where empresa=$1 and produto=$2 and data=reg.data and lancto=reg.grid;
			IF req_estoque_emp.round is not null or req_estoque_emp.round > 0 THEN
				estoque := req_estoque_emp.round;
			END IF;
		END IF;

		IF reg.data >= $3 THEN
			
			if reg.quantidade > 0 and (reg.preco_unit > 0 and reg.preco_unit is not null) THEN
				-- Testa se o lançamento informado é efetivamente uma venda que pode ser contado lucro sobre a operacao realizada

				ret_testa_venda_estoque_cmv := false;

				IF reg.operacao = 'V' THEN 
					ret_testa_venda_estoque_cmv := true;
				ELSIF reg.operacao = 'TS' and flag_cmv_considera_transf_venda = true  THEN 
					
					-- Testar se a transferencia é entre depositos da mesma empresa
					select l.grid into rec_testa_venda_estoque_cmv from lancto l where l.empresa=$1 and l.mlid=reg.mlid and l.produto=$2 and l.operacao='TE';
					IF NOT FOUND THEN
						-- Se não encontrou é porque estamos falando de transferencia para outro posto
						ret_testa_venda_estoque_cmv := true;
					END IF;

				END IF;
			END IF;

			if ret_testa_venda_estoque_cmv = true then
				if $5 is null or reg.deposito = $5 THEN
					qtdeparc := (qtdeparc+reg.quantidade);

					if custo > 0 THEN
						cmv := (cmv + round((reg.quantidade * custo)::numeric, 8));
					ELSE
						qtde_sem_custo := (qtde_sem_custo + reg.quantidade);
					END IF;
				END IF;
			END IF;
		END IF;

	END LOOP;

	drop table omega_movimento_produto;

	-- Se nao retornou custo nenhum, pega o que está no cadastro
	IF custo = 0 or custo is null THEN
		select preco_custo_empresa_f INTO preco_custo_empresa from preco_custo_empresa_f($2::bigint, $1::bigint);

		IF FOUND THEN

			custo := preco_custo_empresa;

			IF (custo > 0 and custo is NOT null) and (qtde_sem_custo > 0 and qtde_sem_custo is NOT null) THEN 
				cmv := (cmv + round((custo * qtde_sem_custo)::numeric, 8));
			END IF;
		END IF;
	END IF;

	return cmv;
	
END;

$BODY$;

--311293 codigo do produto teste
--select * from get_cmv(1,69179,'2016-03-07','2016-03-07',NULL);
--select * from get_cmv(1,69179,'2016-03-01','2016-03-31',NULL);
--select data,sum(quantidade), get_cmv(empresa,produto,data,data,null) from lancto where data between '2016-03-01' and '2016-03-01' and produto=69179 and operacao='V'group by data,empresa,produto order by data ;
