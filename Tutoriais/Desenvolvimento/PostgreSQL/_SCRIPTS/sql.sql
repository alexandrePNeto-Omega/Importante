--	ARLA
--	cod = 21, grid= 2962340

select * from produto;



p.nome as "Nome do produto",
l.valor as "Valor lancto",
l.data as "Data"


round(sum(l.valor)) as "Valor total" 

------------ certo
select

gp.nome as "Nome do grupo",
round(sum(l.valor)) as "Valor total"

from lancto as l


left join produto as p on l.produto=p.grid
left join grupo_produto as gp on p.grupo=gp.grid

where p.grupo = gp.grid and l.data = '2016-01-06' and empresa = 1 and l.operacao = 'V'

group by gp.nome;
-----------------------
select

gp.nome as "Nome do grupo",
round(sum(l.valor)) as "Valor total"

from lancto as l


left join produto as p on l.produto=p.grid
left join grupo_produto as gp on p.grupo=gp.grid

where p.grupo = 30012 and l.data = '2022-03-12' and empresa = 1 and l.operacao = 'V'

group by gp.nome;

----------
select

gp.nome as "Nome do grupo",
round(sum(l.valor)) as "Valor total"

from lancto as l

left join empresa as e on l.empresa=e.empresa
left join produto as p on l.produto=p.grid
left join grupo_produto as gp on p.grupo=gp.grid

where p.grupo = gp.grid and l.data = '2023-03-12' and l.empresa = 1 and l.operacao = 'V'

group by gp.nome;

---------
select

e.nome_reduzido as "Empresa",
gp.nome as grupo_nome,
round(sum(l_dia.valor)) as "Valor total dia selecionado"
--round(sum(l_m1.valor)) as "Valor total mês anterior"
--round(sum(l_a1.valor)) as "Valor total ano anterior"
--round(sum(l_m.valor)) as "Valor total"

from empresa as e

join deposito d on d.empresa=e.grid						-- vínculo do deposito e a empresa
join deposito_grupo_produto dgp on dgp.deposito=d.grid	-- vínculo do deposito vinculado a empresa no grupo do deposito
join grupo_produto gp on dgp.grupo=gp.grid				-- grupo do produto dentro do grupo do deposito
join produto p on gp.grid=p.grupo						--	produto dentro do grupo de produto
left join lancto l on l.empresa=e.grid

left join lancto l_dia on l_dia.empresa=e.grid and l_dia.operacao='V' and l_dia.data='2023-03-12 08:41:05'::date and l_dia.produto=p.grid		--	Dia atual
where l_dia.empresa = 1
--left join lancto l_m1  on l_m1.empresa=e.grid  and l_m1.operacao='V' and l_m1.data=('2023-03-12 08:41:05'::date - interval '1 month')::date and l_m1.produto=p.grid	-- -1 mês
--where l_m1.empresa = 1
--left join lancto l_a1 on l_a1.empresa=e.grid and l_a1.operacao='V'and l_a1.data=('2023-03-12 08:41:05'::date - interval '1 year')::date and l_a1.produto=p.grid	--	-1 ano

group by e.nome_reduzido, gp.nome;
-------

select

e.nome_reduzido as "Empresa",
gp.nome as grupo_nome,

round(sum(l_dia.valor)) as "Valor total do dia"
-- sum(l_mes.valor) as "Valor total do mês"

from empresa as e

join deposito d on d.empresa=e.grid-- vínculo do deposito e a empresa
join deposito_grupo_produto dgp on dgp.deposito=d.grid-- vínculo do deposito vinculado a empresa no grupo do deposito
join grupo_produto gp on dgp.grupo=gp.grid-- grupo do produto dentro do grupo do deposito
join produto p on gp.grid=p.grupo--produto dentro do grupo de produto

-- left join lancto l_mes on l_mes.empresa=e.grid and l_mes.operacao='V' and l_mes.data=(DATE_TRUNC('month', '2023-03-12 08:41:05'::date) - INTERVAL '1 month')::date and l_mes.produto=p.grid --Dia atual
left join lancto l_dia on l_dia.empresa=e.grid and l_dia.operacao='V' and l_dia.data='2023-03-12 08:41:05'::date and l_dia.produto=p.grid --Dia atual

where e.grid = 1

group by e.nome_reduzido, gp.nome;

---------

select sum(valor) from lancto where data=(DATE_TRUNC('month', '2023-03-12 08:41:05'::date) - INTERVAL '1 month')::date and operacao='V';
select sum(valor) from lancto where data=('2023-03-12 08:41:05'::date - interval '1 month')::date and operacao='V';

---------
select

e.nome_reduzido as "Empresa",
gp.nome as grupo_nome,

COALESCE(sum(l_dia.valor), 0) as teste--,
-- sum(l_mes.valor) as "Valor total do mês"

from empresa as e

join deposito d on d.empresa=e.grid						-- vínculo do deposito e a empresa
join deposito_grupo_produto dgp on dgp.deposito=d.grid	-- vínculo do deposito vinculado a empresa no grupo do deposito
join grupo_produto gp on dgp.grupo=gp.grid				-- grupo do produto dentro do grupo do deposito
join produto p on gp.grid=p.grupo						--produto dentro do grupo de produto

-- left join lancto l_dia on l_dia.empresa=e.grid and l_dia.operacao='V' and l_dia.data='2023-03-12 08:41:05'::date and l_dia.produto=p.grid --Dia atual
left join lancto l_dia on l_dia.empresa=e.grid and l_dia.operacao='V' and l_dia.data='2023-03-12 08:41:05'::date and l_dia.produto=p.grid --Dia atual
-- left join lancto l_mes on l_mes.empresa=e.grid and l_mes.operacao='V' and l_mes.data=('2023-03-12 08:41:05'::date - interval '1 month')::date and l_mes.produto=p.grid -- mes

where e.grid = 1

group by e.nome_reduzido, gp.nome;

-----------

select

e.nome_reduzido as "Empresa",
gp.nome as grupo_nome,

sum(l_dia.valor) as teste--,
-- sum(l_mes.valor) as "Valor total do mês"

from empresa as e

join deposito d on d.empresa=e.grid						-- vínculo do deposito e a empresa
join deposito_grupo_produto dgp on dgp.deposito=d.grid	-- vínculo do deposito vinculado a empresa no grupo do deposito
join grupo_produto gp on dgp.grupo=gp.grid				-- grupo do produto dentro do grupo do deposito
join produto p on gp.grid=p.grupo						--produto dentro do grupo de produto

-- left join lancto l_dia on l_dia.empresa=e.grid and l_dia.operacao='V' and l_dia.data='2023-03-12 08:41:05'::date and l_dia.produto=p.grid --Dia atual
left join
	(select empresa, produto, sum(valor) 
	from lancto 
	where 
		data='2023-03-12 08:41:05'::date
	group by empresa, produto) as l_dia on l_dia.empresa=e.grid and l_dia.produto=p.grid

-- left join lancto l_mes on l_mes.empresa=e.grid and l_mes.operacao='V' and l_mes.data=('2023-03-12 08:41:05'::date - interval '1 month')::date and l_mes.produto=p.grid -- mes

where e.grid = 1

group by e.nome_reduzido, gp.nome;


-------
select

e.nome_reduzido as "Empresa",
gp.nome as grupo_nome,
sum(l_dia.valor) as "Valor total do dia",
sum(l_mes.valor) as "Valor total do mês",
sum(l_ano.valor) as "Valor total do ano"

from empresa as e

join deposito d on d.empresa=e.grid						-- vínculo do deposito e a empresa
join deposito_grupo_produto dgp on dgp.deposito=d.grid	-- vínculo do deposito vinculado a empresa no grupo do deposito
join grupo_produto gp on dgp.grupo=gp.grid				-- grupo do produto dentro do grupo do deposito
join produto p on gp.grid=p.grupo						--produto dentro do grupo de produto

left join lancto l_dia on l_dia.empresa=e.grid and l_dia.operacao='V' and l_dia.data='2023-03-12 08:41:05'::date and l_dia.produto=p.grid -- dia
left join lancto l_mes on l_mes.empresa=e.grid and l_mes.operacao='V' and l_mes.data=('2023-03-12 08:41:05'::date - interval '1 month')::date and l_mes.produto=p.grid -- mes
left join lancto l_ano on l_ano.empresa=e.grid and l_ano.operacao='V' and l_ano.data=('2023-03-12 08:41:05'::date - interval '1 year')::date and l_ano.produto=p.grid -- ano

where e.grid = 1

group by e.nome_reduzido, gp.nome
order by gp.nome;

---------------------
select
gp.nome as grupo_nome,

-- ROUND(COALESCE(
		-- sum(l_ano.valor)
	-- , 0)) as faturamento_a_1,

-- ROUND(COALESCE(
		-- sum(l_mes.valor)
	-- , 0)) as faturamento_m_1,

ROUND(COALESCE(
		sum(l_dia.valor)
	, 0)) as faturamento_dia


from empresa as e

join deposito d on d.empresa=e.grid						-- vínculo do deposito e a empresa
join deposito_grupo_produto dgp on dgp.deposito=d.grid	-- vínculo do deposito vinculado a empresa no grupo do deposito
join grupo_produto gp on dgp.grupo=gp.grid				-- grupo do produto dentro do grupo do deposito
join produto p on gp.grid=p.grupo						--produto dentro do grupo de produto

left join lancto l_dia on l_dia.empresa=e.grid and l_dia.operacao='V' and l_dia.data='2023-03-12 08:41:05'::date and l_dia.produto=p.grid 								-- dia
-- left join lancto l_mes on l_mes.empresa=e.grid and l_mes.operacao='V' and l_mes.data=('2023-03-12 08:41:05'::date - interval '1 month')::date and l_mes.produto=p.grid 		-- mes
-- left join lancto l_ano on l_ano.empresa=e.grid and l_ano.operacao='V' and l_ano.data=('2023-03-12 08:41:05'::date - interval '1 year')::date and l_ano.produto=p.grid 	-- ano

where e.grid = 1
group by e.grid, gp.nome
order by e.grid, gp.nome;

---------------------------

SELECT

gp.grid AS grid_gp,

gp.nome AS grupo_nome,

--	Faturamento do dia
COALESCE(
	(SELECT SUM(valor) FROM lancto l 
	JOIN produto p ON gp.grid=p.grupo	
	WHERE l.empresa = e.grid AND l.produto = p.grid AND l.data='2023-03-12 08:41:05'::date
), 0) AS faturamento_dia,

--	Faturamendo no mesmo dia, porém no mês anterior
COALESCE(
	(SELECT SUM(valor) FROM lancto l 
	JOIN produto p ON gp.grid=p.grupo	
	WHERE l.empresa = e.grid AND l.produto = p.grid AND l.data=('2023-03-12 08:41:05'::date - interval '1 month')::date
), 0) AS faturamento_m_1,

--	Faturamendo no mesmo dia, porém no ano anterior
COALESCE((SELECT SUM(valor) FROM lancto l 
	JOIN produto p ON gp.grid=p.grupo	
	WHERE l.empresa = e.grid AND l.produto = p.grid AND l.data=('2023-03-12 08:41:05'::date - interval '1 year')::date
), 0) AS faturamento_a_1

FROM empresa AS e

-- Vínculo do deposito e a empresa
JOIN deposito d ON d.empresa=e.grid		
-- Vínculo do deposito vinculado a empresa no grupo do deposito				
JOIN deposito_grupo_produto dgp ON dgp.deposito=d.grid	
-- Vínculo grupo do produto dentro do grupo do deposito
JOIN grupo_produto gp ON dgp.grupo=gp.grid				

WHERE e.grid = 1										

GROUP BY e.grid, gp.nome, gp.grid						
ORDER BY e.grid, gp.nome;