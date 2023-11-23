select 
	t.empresa,
	t.grupo_nome,

	-- DIA
	sum(t.quantidade_dia) as quantidade_dia,
	sum(t.custo_dia) as valor_custo_dia,
	sum(t.valor_dia) as valor_venda_dia,
	sum(t.valor_dia) - sum(t.custo_dia) as lucro_dia--,
	-- (((sum(t.valor_dia) - sum(t.custo_dia)) / sum(t.valor_dia)) * 100) as margem_venda_dia,
	-- (((sum(t.valor_dia) - sum(t.custo_dia)) / sum(t.custo_dia)) * 100) as margem_custo_dia,
	-- -- MES
	-- sum(t.quantidade_mes) as quantidade_mes,
	-- sum(t.custo_mes) as valor_custo_mes,
	-- sum(t.valor_mes) as valor_venda_mes,
	-- sum(t.valor_mes) - sum(t.custo_mes) as lucro_mes,
	-- (((sum(t.valor_mes) - sum(t.custo_mes)) / sum(t.valor_mes)) * 100) as margem_venda_mes,
	-- (((sum(t.valor_mes) - sum(t.custo_mes)) / sum(t.custo_mes)) * 100) as margem_custo_mes,
	-- -- ANO
	-- sum(t.quantidade_ano) as quantidade_ano,
	-- sum(t.custo_ano) as valor_custo_ano,
	-- sum(t.valor_ano) as valor_venda_ano,
	-- sum(t.valor_ano) - sum(t.custo_ano) as lucro_ano,
	-- (((sum(t.valor_ano) - sum(t.custo_ano)) / sum(t.valor_ano)) * 100) as margem_venda_ano,
	-- (((sum(t.valor_ano) - sum(t.custo_ano)) / sum(t.custo_ano)) * 100) as margem_custo_ano
from (
SELECT --distinct
e.grid as empresa,
gp.nome as grupo_nome,
-- p.nome,

-- DIA
(
	SELECT
	sum(ls.quantidade)
	FROM lancto ls
	LEFT JOIN empresa es
		ON es.grid = ls.empresa
	LEFT JOIN produto ps
		ON ps.grid = ls.produto
	LEFT JOIN grupo_produto gps
		ON gps.grid = ps.grupo
	WHERE 
		ls.data = '2023-03-12' 
		AND ls.operacao = 'V'
		AND es.grid = 1 
		AND es.grupo = 107
		AND gps.nome = gp.nome
	GROUP BY es.grid, gps.nome
	ORDER BY gps.nome
)  as quantidade_dia,
(
	SELECT distinct
	sum(ls.valor)
	FROM lancto ls
	LEFT JOIN empresa es
		ON es.grid = ls.empresa
	LEFT JOIN produto ps
		ON ps.grid = ls.produto
	LEFT JOIN grupo_produto gps
		ON gps.grid = ps.grupo
	WHERE 
		ls.data = '2023-03-12' 
        AND ls.operacao = 'V'
		AND es.grid = e.grid 
		AND es.grupo = e.grupo
		AND gps.nome = gp.nome
	GROUP BY es.grid, gps.nome
	-- ORDER BY gps.nome
) as valor_dia,
get_cmv(e.grid, l.produto, '2023-03-12', '2023-03-12', null) as custo_dia,

-- MES
(
	SELECT
	sum(ls.quantidade)
	FROM lancto ls
	LEFT JOIN empresa es
		ON es.grid = ls.empresa
	LEFT JOIN produto ps
		ON ps.grid = ls.produto
	LEFT JOIN grupo_produto gps
		ON gps.grid = ps.grupo
	WHERE 
		ls.data = '2023-02-12' 
		AND ls.operacao = 'V'
		AND es.grid = 1 
		AND es.grupo = 107
		AND gps.nome = gp.nome
	GROUP BY es.grid, gps.nome, ls.data
	ORDER BY gps.nome
)  as quantidade_mes,
(
	SELECT
	sum(ls.valor)
	FROM lancto ls
	LEFT JOIN empresa es
		ON es.grid = ls.empresa
	LEFT JOIN produto ps
		ON ps.grid = ls.produto
	LEFT JOIN grupo_produto gps
		ON gps.grid = ps.grupo
	WHERE 
		ls.data = '2023-02-12' 
        AND ls.operacao = 'V'
		AND es.grid = e.grid 
		AND es.grupo = e.grupo
		AND gps.nome = gp.nome
	GROUP BY es.grid, gps.nome, ls.data
	ORDER BY gps.nome
) as valor_mes,
get_cmv(e.grid, l.produto, '2023-02-12', '2023-02-12', null) as custo_mes,

-- ANO
(
	SELECT
	sum(ls.quantidade)
	FROM lancto ls
	LEFT JOIN empresa es
		ON es.grid = ls.empresa
	LEFT JOIN produto ps
		ON ps.grid = ls.produto
	LEFT JOIN grupo_produto gps
		ON gps.grid = ps.grupo
	WHERE 
		ls.data = '2022-03-12' 
		AND ls.operacao = 'V'
		AND es.grid = 1 
		AND es.grupo = 107
		AND gps.nome = gp.nome
	GROUP BY es.grid, gps.nome, ls.data
	ORDER BY gps.nome
)  as quantidade_ano,
(
	SELECT
	sum(ls.valor)
	FROM lancto ls
	LEFT JOIN empresa es
		ON es.grid = ls.empresa
	LEFT JOIN produto ps
		ON ps.grid = ls.produto
	LEFT JOIN grupo_produto gps
		ON gps.grid = ps.grupo
	WHERE 
		ls.data = '2022-03-12' 
        AND ls.operacao = 'V'
		AND es.grid = e.grid 
		AND es.grupo = e.grupo
		AND gps.nome = gp.nome
	GROUP BY es.grid, gps.nome, ls.data
	ORDER BY gps.nome
) as valor_ano,
get_cmv(e.grid, l.produto, '2022-03-12', '2022-03-12', null) as custo_ano


FROM lancto l

LEFT JOIN empresa e
	ON e.grid = l.empresa
LEFT JOIN produto p
	ON p.grid = l.produto
LEFT JOIN grupo_produto gp
	ON gp.grid = p.grupo

WHERE 
	l.data BETWEEN '2023-03-12' AND '2023-03-12' 
	AND l.operacao = 'V'
	AND e.grid = 1 
	AND e.grupo = 107
	AND gp.grid = p.grupo
GROUP BY e.grid, e.grupo, gp.nome, l.produto
ORDER BY gp.nome
) as t
group by t.empresa, t.grupo_nome;

-------------------------------

select 
	t.grupo_nome,
	t.quantidade_dia as quantidade_dia,
	t.valor_venda_dia as valor_venda_dia,
	sum(t.valor_custo_dia) as valor_custo_dia,
	(t.valor_venda_dia - sum(t.valor_custo_dia)) as lucro_dia,
	(((t.valor_venda_dia - sum(t.valor_custo_dia)) / sum(t.valor_custo_dia)) * 100) as margem_custo_dia,
	(((t.valor_venda_dia - sum(t.valor_custo_dia)) / t.valor_venda_dia) * 100) as margem_venda_dia
from (
select 
	gp.nome as grupo_nome,
	gp.grid as grupo_grid,
	(
		select sum(ls.quantidade) from lancto ls
		left join produto ps on ps.grid = ls.produto
		left join grupo_produto gps on gps.grid = ps.grupo
		WHERE 
			ls.data = '2023-03-12' 
			AND ls.operacao = 'V'
			AND ls.empresa = 1 
			AND gps.grid = gp.grid
		group by gps.nome
	) as quantidade_dia,
	(
		select sum(ls.valor) from lancto ls
		left join produto ps on ps.grid = ls.produto
		left join grupo_produto gps on gps.grid = ps.grupo
		WHERE 
			ls.data = '2023-03-12' 
			AND ls.operacao = 'V'
			AND ls.empresa = 1 
			AND gps.grid = gp.grid
		group by gps.nome
	) as valor_venda_dia,
	get_cmv(l.empresa,l.produto,'2023-03-12', '2023-03-12',null) as valor_custo_dia


from lancto l 

join produto p on l.produto=p.grid 
join grupo_produto gp on p.grupo=gp.grid
where l.operacao='V' 
and l.data = '2023-03-12'
and l.empresa = 1
group by  gp.grid, gp.nome, l.empresa, l.produto
order by gp.nome
) as t
group by t.grupo_nome, t.quantidade_dia, t.valor_venda_dia;

------------------------------------------------------------

select 
	t.grupo_nome,
	--	DIA
	t.quantidade_dia as quantidade_dia,
	t.valor_venda_dia as valor_venda_dia,
	sum(t.valor_custo_dia) as valor_custo_dia,
	(t.valor_venda_dia - sum(t.valor_custo_dia)) as lucro_dia,
	(((t.valor_venda_dia - sum(t.valor_custo_dia)) / sum(t.valor_custo_dia)) * 100) as margem_custo_dia,
	(((t.valor_venda_dia - sum(t.valor_custo_dia)) / t.valor_venda_dia) * 100) as margem_venda_dia,
	--	MES
	t.quantidade_mes as quantidade_mes,
	t.valor_venda_mes as valor_venda_mes,
	sum(t.valor_custo_mes) as valor_custo_mes,
	(t.valor_venda_mes - sum(t.valor_custo_mes)) as lucro_mes,
	(((t.valor_venda_mes - sum(t.valor_custo_mes)) / sum(t.valor_custo_mes)) * 100) as margem_custo_mes,
	(((t.valor_venda_mes - sum(t.valor_custo_mes)) / t.valor_venda_mes) * 100) as margem_venda_mes,
	--	ANO
	t.quantidade_ano as quantidade_ano,
	t.valor_venda_ano as valor_venda_ano,
	sum(t.valor_custo_ano) as valor_custo_ano,
	(t.valor_venda_ano - sum(t.valor_custo_ano)) as lucro_ano,
	(((t.valor_venda_ano - sum(t.valor_custo_ano)) / sum(t.valor_custo_ano)) * 100) as margem_custo_ano,
	(((t.valor_venda_ano - sum(t.valor_custo_ano)) / t.valor_venda_ano) * 100) as margem_venda_ano
from (
select 
	gp.nome as grupo_nome,
	gp.grid as grupo_grid,
	--	DIA
	(
		select sum(ls.quantidade) from lancto ls
		left join produto ps on ps.grid = ls.produto
		left join grupo_produto gps on gps.grid = ps.grupo
		WHERE 
			ls.data = '2023-03-12' 
			AND ls.operacao = 'V'
			AND ls.empresa = 1 
			AND gps.grid = gp.grid
		group by gps.nome
	) as quantidade_dia,
	(
		select sum(ls.valor) from lancto ls
		left join produto ps on ps.grid = ls.produto
		left join grupo_produto gps on gps.grid = ps.grupo
		WHERE 
			ls.data = '2023-03-12' 
			AND ls.operacao = 'V'
			AND ls.empresa = 1 
			AND gps.grid = gp.grid
		group by gps.nome
	) as valor_venda_dia,
	get_cmv(l.empresa, l.produto, '2023-03-12', '2023-03-12', null) as valor_custo_dia,
	--	MES
	(
		select sum(ls.quantidade) from lancto ls
		left join produto ps on ps.grid = ls.produto
		left join grupo_produto gps on gps.grid = ps.grupo
		WHERE 
			ls.data = ('2023-03-12'::date - interval '1 month')::date 
			AND ls.operacao = 'V'
			AND ls.empresa = 1 
			AND gps.grid = gp.grid
		group by gps.nome
	) as quantidade_mes,
	(
		select sum(ls.valor) from lancto ls
		left join produto ps on ps.grid = ls.produto
		left join grupo_produto gps on gps.grid = ps.grupo
		WHERE 
			ls.data = ('2023-03-12'::date - interval '1 month')::date 
			AND ls.operacao = 'V'
			AND ls.empresa = 1 
			AND gps.grid = gp.grid
		group by gps.nome
	) as valor_venda_mes,
	get_cmv(l.empresa, l.produto, ('2023-03-12'::date - interval '1 month')::date, ('2023-03-12'::date - interval '1 month')::date, null) as valor_custo_mes,
	-- ANO
	(
		select sum(ls.quantidade) from lancto ls
		left join produto ps on ps.grid = ls.produto
		left join grupo_produto gps on gps.grid = ps.grupo
		WHERE 
			ls.data = ('2023-03-12 08:41:05'::date - interval '1 year')::date
			AND ls.operacao = 'V'
			AND ls.empresa = 1 
			AND gps.grid = gp.grid
		group by gps.nome
	) as quantidade_ano,
	(
		select sum(ls.valor) from lancto ls
		left join produto ps on ps.grid = ls.produto
		left join grupo_produto gps on gps.grid = ps.grupo
		WHERE 
			ls.data = ('2023-03-12 08:41:05'::date - interval '1 year')::date
			AND ls.operacao = 'V'
			AND ls.empresa = 1 
			AND gps.grid = gp.grid
		group by gps.nome
	) as valor_venda_ano,
	get_cmv(l.empresa, l.produto, ('2023-03-12 08:41:05'::date - interval '1 year')::date, ('2023-03-12 08:41:05'::date - interval '1 year')::date, null) as valor_custo_ano
from lancto l 

join produto p on l.produto=p.grid 
join grupo_produto gp on p.grupo=gp.grid
where l.operacao='V' 
and l.data = '2023-03-12'
and l.empresa = 1
group by  gp.grid, gp.nome, l.empresa, l.produto
order by gp.nome
) as t
group by t.grupo_nome, t.quantidade_dia, t.valor_venda_dia, t.quantidade_mes, t.valor_venda_mes, t.quantidade_ano, t.valor_venda_ano;

-----------------------------------------------

select 
	t.grupo_nome,
	--	DIA
	t.quantidade_dia as quantidade_dia,
	t.valor_venda_dia as valor_venda_dia,
	sum(t.valor_custo_dia) as valor_custo_dia,
	(t.valor_venda_dia - sum(t.valor_custo_dia)) as lucro_dia,
	(((t.valor_venda_dia - sum(t.valor_custo_dia)) / sum(t.valor_custo_dia)) * 100) as margem_custo_dia,
	(((t.valor_venda_dia - sum(t.valor_custo_dia)) / t.valor_venda_dia) * 100) as margem_venda_dia,
	--	MES
	t.quantidade_mes as quantidade_mes,
	t.valor_venda_mes as valor_venda_mes,
	sum(t.valor_custo_mes) as valor_custo_mes,
	(t.valor_venda_mes - sum(t.valor_custo_mes)) as lucro_mes,
	(((t.valor_venda_mes - sum(t.valor_custo_mes)) / sum(t.valor_custo_mes)) * 100) as margem_custo_mes,
	(((t.valor_venda_mes - sum(t.valor_custo_mes)) / t.valor_venda_mes) * 100) as margem_venda_mes,
	--	ANO
	t.quantidade_ano as quantidade_ano,
	t.valor_venda_ano as valor_venda_ano,
	sum(t.valor_custo_ano) as valor_custo_ano,
	(t.valor_venda_ano - sum(t.valor_custo_ano)) as lucro_ano,
	(((t.valor_venda_ano - sum(t.valor_custo_ano)) / sum(t.valor_custo_ano)) * 100) as margem_custo_ano,
	(((t.valor_venda_ano - sum(t.valor_custo_ano)) / t.valor_venda_ano) * 100) as margem_venda_ano,
	--	ACUMULADO
	t.acumulado_dia as acumulado_dia,
	t.acumulado_mes as acumulado_mes,
	t.acumulado_ano as acumulado_ano
from (
select 
	gp.nome as grupo_nome,
	gp.grid as grupo_grid,
	--	DIA
	(
		select sum(ls.quantidade) from lancto ls
		left join produto ps on ps.grid = ls.produto
		left join grupo_produto gps on gps.grid = ps.grupo
		WHERE 
			ls.data = '2023-03-12' 
			AND ls.operacao = 'V'
			AND ls.empresa = 1 
			AND gps.grid = gp.grid
		group by gps.nome
	) as quantidade_dia,
	(
		select sum(ls.valor) from lancto ls
		left join produto ps on ps.grid = ls.produto
		left join grupo_produto gps on gps.grid = ps.grupo
		WHERE 
			ls.data = '2023-03-12' 
			AND ls.operacao = 'V'
			AND ls.empresa = 1 
			AND gps.grid = gp.grid
		group by gps.nome
	) as valor_venda_dia,
	get_cmv(l.empresa, l.produto, '2023-03-12', '2023-03-12', null) as valor_custo_dia,
	(
		select sum(ls.valor) from lancto ls
		left join produto ps on ps.grid = ls.produto
		left join grupo_produto gps on gps.grid = ps.grupo
		WHERE 
			ls.data BETWEEN
				(DATE_TRUNC('month', '2023-03-12'::date))::date
				AND
				((DATE_TRUNC('month', '2023-03-12'::date)::date + interval '1 month') - interval '1 day')::date
			AND gps.grid = gp.grid
			AND ls.operacao = 'V'
			AND ls.empresa = l.empresa
	) as acumulado_dia,
	--	MES
	(
		select sum(ls.quantidade) from lancto ls
		left join produto ps on ps.grid = ls.produto
		left join grupo_produto gps on gps.grid = ps.grupo
		WHERE 
			ls.data = ('2023-03-12'::date - interval '1 month')::date 
			AND ls.operacao = 'V'
			AND ls.empresa = 1 
			AND gps.grid = gp.grid
		group by gps.nome
	) as quantidade_mes,
	(
		select sum(ls.valor) from lancto ls
		left join produto ps on ps.grid = ls.produto
		left join grupo_produto gps on gps.grid = ps.grupo
		WHERE 
			ls.data = ('2023-03-12'::date - interval '1 month')::date 
			AND ls.operacao = 'V'
			AND ls.empresa = 1 
			AND gps.grid = gp.grid
		group by gps.nome
	) as valor_venda_mes,
	get_cmv(l.empresa, l.produto, ('2023-03-12'::date - interval '1 month')::date, ('2023-03-12'::date - interval '1 month')::date, null) as valor_custo_mes,
	(
		select sum(ls.valor) from lancto ls
		left join produto ps on ps.grid = ls.produto
		left join grupo_produto gps on gps.grid = ps.grupo
		WHERE 
			ls.data BETWEEN
				(DATE_TRUNC('month', '2023-03-12'::date)::date - interval '1 month')::date
				AND
				((DATE_TRUNC('month', '2023-03-12'::date - interval '1 month')::date + interval '1 month') - interval '1 day')::date
			AND gps.grid = gp.grid
			AND ls.operacao = 'V'
			AND ls.empresa = l.empresa
	) as acumulado_mes,
	-- ANO
	(
		select sum(ls.quantidade) from lancto ls
		left join produto ps on ps.grid = ls.produto
		left join grupo_produto gps on gps.grid = ps.grupo
		WHERE 
			ls.data = ('2023-03-12 08:41:05'::date - interval '1 year')::date
			AND ls.operacao = 'V'
			AND ls.empresa = 1 
			AND gps.grid = gp.grid
		group by gps.nome
	) as quantidade_ano,
	(
		select sum(ls.valor) from lancto ls
		left join produto ps on ps.grid = ls.produto
		left join grupo_produto gps on gps.grid = ps.grupo
		WHERE 
			ls.data = ('2023-03-12 08:41:05'::date - interval '1 year')::date
			AND ls.operacao = 'V'
			AND ls.empresa = 1 
			AND gps.grid = gp.grid
		group by gps.nome
	) as valor_venda_ano,
	get_cmv(l.empresa, l.produto, ('2023-03-12 08:41:05'::date - interval '1 year')::date, ('2023-03-12 08:41:05'::date - interval '1 year')::date, null) as valor_custo_ano,
	(
		select sum(ls.valor) from lancto ls
		left join produto ps on ps.grid = ls.produto
		left join grupo_produto gps on gps.grid = ps.grupo
		WHERE 
			ls.data BETWEEN
				(DATE_TRUNC('month', '2023-03-12'::date)::date - interval '1 year')::date
				AND
				((DATE_TRUNC('month', '2023-03-12'::date - interval '1 year')::date + interval '1 month') - interval '1 day')::date
			AND gps.grid = gp.grid
			AND ls.operacao = 'V'
			AND ls.empresa = l.empresa
	) as acumulado_ano
from lancto l 

join produto p on l.produto=p.grid 
join grupo_produto gp on p.grupo=gp.grid
where l.operacao='V' 
and l.data BETWEEN 
		(DATE_TRUNC('month', '2023-03-12'::date)::date - interval '1 year')::date 
		AND 
		((DATE_TRUNC('month', '2023-03-12'::date)::date + interval '1 month') - interval '1 day')::date
and l.empresa = 1
group by  gp.grid, gp.nome, l.empresa, l.produto
order by gp.nome
) as t
group by t.grupo_nome, t.quantidade_dia, t.valor_venda_dia, t.quantidade_mes, t.valor_venda_mes, t.quantidade_ano, t.valor_venda_ano, t.acumulado_dia, t.acumulado_mes, t.acumulado_ano;
-------------------------------------------------------------------------------------------------------------------------------------------

select 
	t.grupo_nome,
	--	DIA
	t.quantidade_dia as quantidade_dia,
	t.valor_venda_dia as valor_venda_dia,
	sum(t.valor_custo_dia) as valor_custo_dia,
	(t.valor_venda_dia - sum(t.valor_custo_dia)) as lucro_dia,
	(((t.valor_venda_dia - sum(t.valor_custo_dia)) / sum(t.valor_custo_dia)) * 100) as margem_custo_dia,
	(((t.valor_venda_dia - sum(t.valor_custo_dia)) / t.valor_venda_dia) * 100) as margem_venda_dia,
	--	MES
	t.quantidade_mes as quantidade_mes,
	t.valor_venda_mes as valor_venda_mes,
	sum(t.valor_custo_mes) as valor_custo_mes,
	(t.valor_venda_mes - sum(t.valor_custo_mes)) as lucro_mes,
	(((t.valor_venda_mes - sum(t.valor_custo_mes)) / sum(t.valor_custo_mes)) * 100) as margem_custo_mes,
	(((t.valor_venda_mes - sum(t.valor_custo_mes)) / t.valor_venda_mes) * 100) as margem_venda_mes,
	--	ANO
	t.quantidade_ano as quantidade_ano,
	t.valor_venda_ano as valor_venda_ano,
	sum(t.valor_custo_ano) as valor_custo_ano,
	(t.valor_venda_ano - sum(t.valor_custo_ano)) as lucro_ano,
	(((t.valor_venda_ano - sum(t.valor_custo_ano)) / sum(t.valor_custo_ano)) * 100) as margem_custo_ano,
	(((t.valor_venda_ano - sum(t.valor_custo_ano)) / t.valor_venda_ano) * 100) as margem_venda_ano,
	--	ACUMULADO
	(t.acumulado_dia - sum(t.acumulado_valor_custo_dia)) as acumulado_lucro_dia
from (
select 
	gp.nome as grupo_nome,
	gp.grid as grupo_grid,
	--	DIA
	(
		select sum(ls.quantidade) from lancto ls
		left join produto ps on ps.grid = ls.produto
		left join grupo_produto gps on gps.grid = ps.grupo
		WHERE 
			ls.data = '2023-03-12' 
			AND ls.operacao = 'V'
			AND ls.empresa = 1 
			AND gps.grid = gp.grid
		group by gps.nome
	) as quantidade_dia,
	(
		select sum(ls.valor) from lancto ls
		left join produto ps on ps.grid = ls.produto
		left join grupo_produto gps on gps.grid = ps.grupo
		WHERE 
			ls.data = '2023-03-12' 
			AND ls.operacao = 'V'
			AND ls.empresa = 1 
			AND gps.grid = gp.grid
		group by gps.nome
	) as valor_venda_dia,
	get_cmv(l.empresa, l.produto, '2023-03-12', '2023-03-12', null) as valor_custo_dia,
	(
		select sum(ls.valor) from lancto ls
		left join produto ps on ps.grid = ls.produto
		left join grupo_produto gps on gps.grid = ps.grupo
		WHERE 
			ls.data BETWEEN
				(DATE_TRUNC('month', '2023-03-12'::date))::date
				AND
				((DATE_TRUNC('month', '2023-03-12'::date)::date + interval '1 month') - interval '1 day')::date
			AND gps.grid = gp.grid
			AND ls.operacao = 'V'
			AND ls.empresa = l.empresa
	) as acumulado_dia,
	get_cmv(l.empresa, l.produto, (DATE_TRUNC('month', '2023-03-12'::date))::date, ((DATE_TRUNC('month', '2023-03-12'::date)::date + interval '1 month') - interval '1 day')::date, null) as acumulado_valor_custo_dia,
	--	MES
	(
		select sum(ls.quantidade) from lancto ls
		left join produto ps on ps.grid = ls.produto
		left join grupo_produto gps on gps.grid = ps.grupo
		WHERE 
			ls.data = ('2023-03-12'::date - interval '1 month')::date 
			AND ls.operacao = 'V'
			AND ls.empresa = 1 
			AND gps.grid = gp.grid
		group by gps.nome
	) as quantidade_mes,
	(
		select sum(ls.valor) from lancto ls
		left join produto ps on ps.grid = ls.produto
		left join grupo_produto gps on gps.grid = ps.grupo
		WHERE 
			ls.data = ('2023-03-12'::date - interval '1 month')::date 
			AND ls.operacao = 'V'
			AND ls.empresa = 1 
			AND gps.grid = gp.grid
		group by gps.nome
	) as valor_venda_mes,
	get_cmv(l.empresa, l.produto, ('2023-03-12'::date - interval '1 month')::date, ('2023-03-12'::date - interval '1 month')::date, null) as valor_custo_mes,
	(
		select sum(ls.valor) from lancto ls
		left join produto ps on ps.grid = ls.produto
		left join grupo_produto gps on gps.grid = ps.grupo
		WHERE 
			ls.data BETWEEN
				(DATE_TRUNC('month', '2023-03-12'::date)::date - interval '1 month')::date
				AND
				((DATE_TRUNC('month', '2023-03-12'::date - interval '1 month')::date + interval '1 month') - interval '1 day')::date
			AND gps.grid = gp.grid
			AND ls.operacao = 'V'
			AND ls.empresa = l.empresa
	) as acumulado_mes,
	-- ANO
	(
		select sum(ls.quantidade) from lancto ls
		left join produto ps on ps.grid = ls.produto
		left join grupo_produto gps on gps.grid = ps.grupo
		WHERE 
			ls.data = ('2023-03-12 08:41:05'::date - interval '1 year')::date
			AND ls.operacao = 'V'
			AND ls.empresa = 1 
			AND gps.grid = gp.grid
		group by gps.nome
	) as quantidade_ano,
	(
		select sum(ls.valor) from lancto ls
		left join produto ps on ps.grid = ls.produto
		left join grupo_produto gps on gps.grid = ps.grupo
		WHERE 
			ls.data = ('2023-03-12 08:41:05'::date - interval '1 year')::date
			AND ls.operacao = 'V'
			AND ls.empresa = 1 
			AND gps.grid = gp.grid
		group by gps.nome
	) as valor_venda_ano,
	get_cmv(l.empresa, l.produto, ('2023-03-12 08:41:05'::date - interval '1 year')::date, ('2023-03-12 08:41:05'::date - interval '1 year')::date, null) as valor_custo_ano,
	(
		select sum(ls.valor) from lancto ls
		left join produto ps on ps.grid = ls.produto
		left join grupo_produto gps on gps.grid = ps.grupo
		WHERE 
			ls.data BETWEEN
				(DATE_TRUNC('month', '2023-03-12'::date)::date - interval '1 year')::date
				AND
				((DATE_TRUNC('month', '2023-03-12'::date - interval '1 year')::date + interval '1 month') - interval '1 day')::date
			AND gps.grid = gp.grid
			AND ls.operacao = 'V'
			AND ls.empresa = l.empresa
	) as acumulado_ano
from lancto l 

join produto p on l.produto=p.grid 
join grupo_produto gp on p.grupo=gp.grid
where l.operacao='V' 
and l.data BETWEEN 
		(DATE_TRUNC('month', '2023-03-12'::date)::date - interval '1 year')::date 
		AND 
		((DATE_TRUNC('month', '2023-03-12'::date)::date + interval '1 month') - interval '1 day')::date
and l.empresa = 1
group by  gp.grid, gp.nome, l.empresa, l.produto
order by gp.nome
) as t
group by t.grupo_nome, t.quantidade_dia, t.valor_venda_dia, t.quantidade_mes, t.valor_venda_mes, t.quantidade_ano, t.valor_venda_ano, t.acumulado_dia, t.acumulado_mes, t.acumulado_ano, t.acumulado_valor_custo_dia;

-------------------------------

explain select 
	t.grupo_nome,
	--	DIA
	COALESCE(((t.valor_venda_dia - sum(t.valor_custo_dia))), 0) as lucro_dia,
	COALESCE((((t.valor_venda_dia - sum(t.valor_custo_dia)) / t.valor_venda_dia) * 100), 0) as margem_venda_dia,
	--	MES
	COALESCE((t.valor_venda_mes - sum(t.valor_custo_mes)), 0) as lucro_mes,
	COALESCE((((t.valor_venda_mes - sum(t.valor_custo_mes)) / t.valor_venda_mes) * 100), 0) as margem_venda_mes,
	--	ANO
	COALESCE((t.valor_venda_ano - sum(t.valor_custo_ano)), 0) as lucro_ano,
	COALESCE((((t.valor_venda_ano - sum(t.valor_custo_ano)) / t.valor_venda_ano) * 100), 0) as margem_venda_ano,
	--	ACUMULADO
	t.acumulado_dia as acumulado_dia,
	t.acumulado_mes as acumulado_mes,
	sum(t.custo_acumulado_ano),
	t.acumulado_ano as acumulado_ano,
	COALESCE((t.acumulado_ano - (sum(t.custo_acumulado_ano))), 0)  as teste
from (
select 
	gp.nome as grupo_nome,
	gp.grid as grupo_grid,
	--	DIA
	(
		select sum(ls.valor) from lancto ls
		left join produto ps on ps.grid = ls.produto
		left join grupo_produto gps on gps.grid = ps.grupo
		WHERE 
			ls.data = '2023-03-12'::date
			AND ls.operacao = 'V'
			AND ls.empresa = l.empresa 
			AND gps.grid = gp.grid
		group by gps.nome
	) as valor_venda_dia,
	get_cmv(l.empresa, l.produto, '2023-03-12'::date, '2023-03-12'::date, null) as valor_custo_dia,
	(
		select sum(ls.valor) from lancto ls
		left join produto ps on ps.grid = ls.produto
		left join grupo_produto gps on gps.grid = ps.grupo
		WHERE 
			ls.data BETWEEN
				(DATE_TRUNC('month', '2023-03-12'::date))::date
				AND
				((DATE_TRUNC('month', '2023-03-12'::date)::date + interval '1 month') - interval '1 day')::date
			AND gps.grid = gp.grid
			AND ls.operacao = 'V'
			AND ls.empresa = l.empresa
	) as acumulado_dia,
	--	MES
	(
		select sum(ls.valor) from lancto ls
		left join produto ps on ps.grid = ls.produto
		left join grupo_produto gps on gps.grid = ps.grupo
		WHERE 
			ls.data = ('2023-03-12'::date - interval '1 month')::date 
			AND ls.operacao = 'V'
			AND ls.empresa = l.empresa 
			AND gps.grid = gp.grid
		group by gps.nome
	) as valor_venda_mes,
	get_cmv(l.empresa, l.produto, ('2023-03-12'::date - interval '1 month')::date, ('2023-03-12'::date - interval '1 month')::date, null) as valor_custo_mes,
	(
		select sum(ls.valor) from lancto ls
		left join produto ps on ps.grid = ls.produto
		left join grupo_produto gps on gps.grid = ps.grupo
		WHERE 
			ls.data BETWEEN
				(DATE_TRUNC('month', '2023-03-12'::date)::date - interval '1 month')::date
				AND
				((DATE_TRUNC('month', '2023-03-12'::date - interval '1 month')::date + interval '1 month') - interval '1 day')::date
			AND gps.grid = gp.grid
			AND ls.operacao = 'V'
			AND ls.empresa = l.empresa
	) as acumulado_mes,
	-- ANO
	(
		select sum(ls.valor) from lancto ls
		left join produto ps on ps.grid = ls.produto
		left join grupo_produto gps on gps.grid = ps.grupo
		WHERE 
			ls.data = ('2023-03-12'::date - interval '1 year')::date
			AND ls.operacao = 'V'
			AND ls.empresa = l.empresa 
			AND gps.grid = gp.grid
		group by gps.nome
	) as valor_venda_ano,
	get_cmv(l.empresa, l.produto, ('2023-03-12'::date - interval '1 year')::date, ('2023-03-12'::date - interval '1 year')::date, null) as valor_custo_ano,
	(
		select sum(ls.valor) from lancto ls
		left join produto ps on ps.grid = ls.produto
		left join grupo_produto gps on gps.grid = ps.grupo
		WHERE 
			ls.data BETWEEN
				(DATE_TRUNC('month', '2023-02-12'::date)::date - interval '1 year')::date 
				AND 
				((DATE_TRUNC('month', '2023-03-12'::date)::date - interval '1 year') - interval '1 day')::date
			AND gps.grid = gp.grid
			AND ls.operacao = 'V'
			AND ls.empresa = l.empresa
	) as acumulado_ano,
	get_cmv(l.empresa, l.produto, (DATE_TRUNC('month', '2023-02-12'::date)::date - interval '1 year')::date, ((DATE_TRUNC('month', '2023-03-12'::date)::date - interval '1 year') - interval '1 day')::date, null) as custo_acumulado_ano
from lancto l 

join produto p on l.produto=p.grid 
join grupo_produto gp on p.grupo=gp.grid
where l.operacao='V' 
and l.data BETWEEN 
		(DATE_TRUNC('month', '2023-02-12'::date)::date - interval '1 year')::date 
		AND 
		((DATE_TRUNC('month', '2023-03-12'::date)::date - interval '1 year') - interval '1 day')::date
and l.empresa = 1
group by  gp.grid, gp.nome, l.empresa, l.produto
order by gp.nome
) as t
group by 
t.grupo_nome, 
t.valor_venda_dia, 
t.valor_venda_mes,  
t.valor_venda_ano, 
t.acumulado_dia, 
t.acumulado_mes, 
t.acumulado_ano;