select e.nome_reduzido, 
gp.nome as grupo_nome,

sum(l_a1.quantidade) as quantidade_a_1, -- qtq ano anterior
sum(l_m1.quantidade) as quantidade_m_1,	-- qtd mes anterior
sum(l_dia.quantidade) as quantidade_dia -- qtd dia atual

from empresa e

join deposito d on e.grid=d.empresa 					-- vínculo do deposito e a empresa
join deposito_grupo_produto dgp on dgp.deposito=d.grid	-- vínculo do deposito vinculado a empresa no grupo do deposito
join grupo_produto gp on dgp.grupo=gp.grid				-- grupo do produto dentro do grupo do deposito
join produto p on gp.grid=p.grupo						--	produto dentro do grupo de produto

left join lancto l_dia on l_dia.empresa=e.grid and l_dia.operacao='V' and l_dia.data=$data_ini and l_dia.produto=p.grid
left join lancto l_m1  on l_m1.empresa=e.grid  and l_m1.operacao='V' and l_m1.data=to_char($data_ini::date, 'YYYY-03-dd')::date and l_m1.produto=p.grid
left join lancto l_a1 on l_a1.empresa=e.grid and l_a1.operacao='V'and l_a1.data=to_char($data_ini::date, '2022-mm-dd')::date and l_a1.produto=p.grid

group by e.nome_reduzido, gp.nome;


-- SELECT DATE_PART('DAY', CURRENT_TIMESTAMP) AS dia;


--	SELECT date_trunc('day', TIMESTAMP '2014-06-03 08:41:05');
-- 	SELECT date_trunc('day', TIMESTAMP '2014-06-03 08:41:05' + interval '1440 minutes');


select * from lancto where hora between date_trunc('day', TIMESTAMP '2014-06-03 08:41:05') and date_trunc('day', TIMESTAMP '2014-06-03 08:41:05' + interval '1440 minutes') order by hora limit 1;
select * from lancto where hora between date_trunc('day', TIMESTAMP '2014-06-03 08:41:05') and date_trunc('day', TIMESTAMP '2014-06-03 08:41:05' + interval '1440 minutes') order by hora desc limit 1;



select * from lancto where hora between '2014-06-03 00:00:00' and '2014-06-04 00:00:00' order by hora desc limit 1;



select sum(quantidade)
from lancto 
where hora between date_trunc('day', TIMESTAMP '2014-06-03 08:41:05') and date_trunc('day', TIMESTAMP '2014-06-03 08:41:05' + interval '1440 minutes')
AND empresa = 33674
AND operacao = 'V'
limit 1;

------
select 
e.nome_reduzido, 
gp.nome as grupo_nome,

sum(l_a1.quantidade) as quantidade_a_1 -- qtq ano anterior

from empresa e

join deposito d on e.grid=d.empresa 					-- vínculo do deposito e a empresa
join deposito_grupo_produto dgp on dgp.deposito=d.grid	-- vínculo do deposito vinculado a empresa no grupo do deposito
join grupo_produto gp on dgp.grupo=gp.grid				-- grupo do produto dentro do grupo do deposito
join produto p on gp.grid=p.grupo						--	produto dentro do grupo de produto

left join lancto l_a1 on l_a1.empresa=e.grid 

and l_a1.operacao='V'

and l_a1.produto=p.grid

where hora between date_trunc('day', TIMESTAMP '2014-06-03 08:41:05') and date_trunc('day', TIMESTAMP '2014-06-03 08:41:05' + interval '1440 minutes')

group by e.nome_reduzido, gp.nome

limit 1;

select date_part('day', TIMESTAMP '2014-06-03 08:41:05'  + interval '1440 minutes') from lancto limit 1;


--------

select sum(quantidade)
from lancto 
where hora between date_trunc('day', TIMESTAMP '2014-06-03 08:41:05') and date_trunc('day', TIMESTAMP '2014-06-03 08:41:05' + interval '1440 minutes')
AND empresa = 33674
AND operacao = 'V'
limit 1;

------

select 
e.nome_reduzido, 
gp.nome as grupo_nome

-- sum(l_a1.quantidade) as quantidade_a_1 -- qtq ano anterior

from empresa e

join deposito d on e.grid=33674 					    -- vínculo do deposito e a empresa
join deposito_grupo_produto dgp on dgp.deposito=d.grid	-- vínculo do deposito vinculado a empresa no grupo do deposito
join grupo_produto gp on dgp.grupo=gp.grid				-- grupo do produto dentro do grupo do deposito
join produto p on gp.grid=p.grupo						--	produto dentro do grupo de produto

left join lancto l_a1 on l_a1.empresa=e.grid and l_a1.operacao='V' and l_a1.produto=31745
group by e.nome_reduzido, gp.nome;

-------

select 

e.nome_reduzido, 
gp.nome as grupo_nome

from empresa e

--------------------- MENOS 1 ANO

('2022-06-03 08:41:05'::date - interval '1 year')::date

select
e.nome_reduzido,
gp.nome as grupo_nome,

CASE WHEN 
	sum(l_a1.quantidade) > 0::integer then
		sum(l_a1.quantidade) -- qtq ano anterior
	ELSE
		0.00
end as "quantidade_a_1"
from empresa e

join deposito d on e.grid=33473 -- vínculo do deposito e a empresa
join deposito_grupo_produto dgp on dgp.deposito=d.grid-- vínculo do deposito vinculado a empresa no grupo do deposito
join grupo_produto gp on dgp.grupo=gp.grid-- grupo do produto dentro do grupo do deposito
join produto p on gp.grid=p.grupo--produto dentro do grupo de produto

left join lancto l_a1 on l_a1.empresa=e.grid and l_a1.operacao='V'and l_a1.data=('2022-06-03 08:41:05'::date - interval '1 year')::date and l_a1.produto=p.grid

group by e.nome_reduzido, gp.nome;


--------------------- MENOS 1 MÊS

('2022-06-03 08:41:05'::date - interval '1 month')::date

select
e.nome_reduzido,
gp.nome as grupo_nome,

CASE WHEN 
	sum(l_a1.quantidade) > 0::integer then
		sum(l_a1.quantidade) -- qtq ano anterior
	ELSE
		0.00
end as "quantidade_a_1"
from empresa e

join deposito d on e.grid=33473 -- vínculo do deposito e a empresa
join deposito_grupo_produto dgp on dgp.deposito=d.grid-- vínculo do deposito vinculado a empresa no grupo do deposito
join grupo_produto gp on dgp.grupo=gp.grid-- grupo do produto dentro do grupo do deposito
join produto p on gp.grid=p.grupo--produto dentro do grupo de produto

left join lancto l_a1 on l_a1.empresa=e.grid and l_a1.operacao='V'and l_a1.data=('2022-06-03 08:41:05'::date - interval '1 month')::date and l_a1.produto=p.grid

group by e.nome_reduzido, gp.nome;

--------------------- Dia atual

'2022-06-03 08:41:05'::date

select
e.nome_reduzido,
gp.nome as grupo_nome,

CASE WHEN 
	sum(l_a1.quantidade) > 0::integer then
		sum(l_a1.quantidade) -- qtq ano anterior
	ELSE
		0.00
end as "quantidade_a_1"
from empresa e

join deposito d on e.grid=33473 -- vínculo do deposito e a empresa
join deposito_grupo_produto dgp on dgp.deposito=d.grid-- vínculo do deposito vinculado a empresa no grupo do deposito
join grupo_produto gp on dgp.grupo=gp.grid-- grupo do produto dentro do grupo do deposito
join produto p on gp.grid=p.grupo--produto dentro do grupo de produto

left join lancto l_a1 on l_a1.empresa=e.grid and l_a1.operacao='V'and l_a1.data='2022-06-03 08:41:05'::date and l_a1.produto=p.grid

group by e.nome_reduzido, gp.nome;

--------------------- Final 1 quantidade

select e.nome_reduzido, 
gp.nome as grupo_nome,

sum(l_a1.quantidade) as quantidade_a_1, -- qtq ano anterior
sum(l_m1.quantidade) as quantidade_m_1,	-- qtd mes anterior
sum(l_dia.quantidade) as quantidade_dia -- qtd dia atual

from empresa e

join deposito d on e.grid=33473 					-- vínculo do deposito e a empresa
join deposito_grupo_produto dgp on dgp.deposito=d.grid	-- vínculo do deposito vinculado a empresa no grupo do deposito
join grupo_produto gp on dgp.grupo=gp.grid				-- grupo do produto dentro do grupo do deposito
join produto p on gp.grid=p.grupo						--	produto dentro do grupo de produto

left join lancto l_dia on l_dia.empresa=e.grid and l_dia.operacao='V' and l_dia.data='2022-06-03 08:41:05'::date and l_dia.produto=p.grid		--	Dia atual
left join lancto l_m1  on l_m1.empresa=e.grid  and l_m1.operacao='V' and l_m1.data=('2022-06-03 08:41:05'::date - interval '1 month')::date and l_m1.produto=p.grid	-- -1 mês
left join lancto l_a1 on l_a1.empresa=e.grid and l_a1.operacao='V'and l_a1.data=('2022-06-03 08:41:05'::date - interval '1 year')::date and l_a1.produto=p.grid	--	-1 ano

group by e.nome_reduzido, gp.nome;

----
select e.nome_reduzido, 
gp.nome as grupo_nome,

-- round(sum(l_a1.valor)) as quantidade_a_1--, -- qtq ano anterior
-- sum(l_m1.valor) as quantidade_m_1,	-- qtd mes anterior
sum(l_dia.valor) as quantidade_dia -- qtd dia atual

from empresa e

join deposito d on e.grid=d.empresa					-- vínculo do deposito e a empresa
join deposito_grupo_produto dgp on dgp.deposito=d.grid	-- vínculo do deposito vinculado a empresa no grupo do deposito
join grupo_produto gp on dgp.grupo=gp.grid				-- grupo do produto dentro do grupo do deposito
join produto p on gp.grid=p.grupo						--	produto dentro do grupo de produto

right join lancto l on l.empresa=e.grid
left join lancto l_dia on l_dia.empresa=e.grid and l_dia.operacao='V' and l_dia.data='2023-03-12 08:41:05'::date and l_dia.produto=p.grid		--	Dia atual
-- left join lancto l_m1  on l_m1.empresa=e.grid  and l_m1.operacao='V' and l_m1.data=('2023-03-12 08:41:05'::date - interval '1 month')::date and l_m1.produto=p.grid	-- -1 mês
-- left join lancto l_a1 on l_a1.empresa=l.empresa and l_a1.operacao='V'and l_a1.data=('2023-03-12 08:41:05'::date - interval '1 year')::date and l_a1.produto=p.grid	--	-1 ano

where l.empresa = 1

group by e.nome_reduzido, gp.nome;



CREATE OR REPLACE FUNCTION rel_sum_dma(qData date, qEmpresa int, qTime int, qStringTime int)
RETURNS double precision AS $$
BEGIN
		-- qData: O dia para a base de busca
		-- qEmpresa: A empresa para base de busca
		-- qTime: Quantidade de tempo que ele vai voltar de acordo com a qStringTime
		--	qStringTime: 0 = dia, 1 = mes, != dos outro = ano
		
		IF qStringTime = 0 THEN
			select e.nome_reduzido, 
			gp.nome as grupo_nome,

			sum(l_dia.valor) as quantidade_dia -- qtd dia atual

			from empresa e

			join deposito d on e.grid=d.empresa						-- vínculo do deposito e a empresa
			join deposito_grupo_produto dgp on dgp.deposito=d.grid	-- vínculo do deposito vinculado a empresa no grupo do deposito
			join grupo_produto gp on dgp.grupo=gp.grid				-- grupo do produto dentro do grupo do deposito
			join produto p on gp.grid=p.grupo						--	produto dentro do grupo de produto

			left join lancto l_dia on l_dia.empresa=e.grid and l_dia.operacao='V' and l_dia.data='2023-03-12 08:41:05'::date and l_dia.produto=p.grid		--	Dia atual

			where e.grid = 1

			group by e.nome_reduzido, gp.nome;
			RETURN;
			
		ELSIF qStringTime = 1 THEN
			RETURN;
			
		ELSE
			RETURN;
END;
$$ LANGUAGE plpgsql


CREATE OR REPLACE FUNCTION rel_sum_dma(qEmpresa int, qTime int)
RETURNS double precision AS $$
BEGIN
	RETURN qEmpresa + qTime
END;
$$ LANGUAGE plpgsql;