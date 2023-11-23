SELECT

gp.grid AS grid_gp,

gp.nome AS grupo_nome,

--	Faturamento do dia
COALESCE((SELECT SUM(valor) FROM lancto l 
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
), 0) AS faturamento_a_1,

--	Acumulado do mês selecionado
COALESCE((SELECT SUM(l.valor) FROM lancto l 
	JOIN produto p ON gp.grid=p.grupo	
	WHERE l.empresa = e.grid AND l.produto = p.grid 
		AND l.data BETWEEN
			(DATE_TRUNC('month', '2023-03-12 08:41:05'::date))::date
			AND
			((DATE_TRUNC('month', '2023-03-12 08:41:05'::date)::date + interval '1 month') - interval '1 day')::date
		AND l.operacao = 'V'
	group by l.empresa
), 0) AS acumulado_dia,

--	Acumulado do mês anterior
COALESCE((SELECT SUM(l.valor) FROM lancto l 
	JOIN produto p ON gp.grid=p.grupo	
	WHERE l.empresa = e.grid AND l.produto = p.grid 
		AND l.data BETWEEN
			(DATE_TRUNC('month', '2023-03-12 08:41:05'::date)::date - interval '1 month')::date
			AND
			((DATE_TRUNC('month', '2023-03-12 08:41:05'::date - interval '1 month')::date + interval '1 month') - interval '1 day')::date
		AND l.operacao = 'V'
	group by l.empresa
), 0) AS acumulado_m_1,

--	Acumulado do ano anterior
COALESCE((SELECT SUM(l.valor) FROM lancto l 
	JOIN produto p ON gp.grid=p.grupo	
	WHERE l.empresa = e.grid AND l.produto = p.grid 
		AND l.data BETWEEN
			(DATE_TRUNC('month', '2023-03-12 08:41:05'::date)::date - interval '1 year')::date
			AND
			((DATE_TRUNC('month', '2023-03-12 08:41:05'::date - interval '1 year')::date + interval '1 month') - interval '1 day')::date
		AND l.operacao = 'V'
	group by l.empresa
), 0) AS acumulado_a_1

FROM empresa AS e

JOIN deposito d ON d.empresa=e.grid				
JOIN deposito_grupo_produto dgp ON dgp.deposito=d.grid	
JOIN grupo_produto gp ON dgp.grupo=gp.grid				

WHERE e.grid = 1										

GROUP BY e.grid, gp.nome, gp.grid						
ORDER BY e.grid, gp.nome;

------------

SELECT

gp.nome AS grupo_nome,

--	Faturamento do dia
COALESCE((SELECT SUM(valor) FROM lancto l 
	JOIN produto p ON p.grid=l.produto	
	JOIN grupo_produto gpl ON gpl.grid=p.grupo AND gpl.nome = gp.nome
	WHERE l.empresa = e.grid AND l.produto = p.grid AND l.data='2023-03-12 08:41:05'::date
	AND l.operacao = 'V'
), 0) AS faturamento_dia,

--	Faturamendo no mesmo dia, porém no mês anterior
COALESCE((SELECT SUM(valor) FROM lancto l 
	JOIN produto p ON p.grid=l.produto	
	JOIN grupo_produto gpl ON gpl.grid=p.grupo AND gpl.nome = gp.nome
	WHERE l.empresa = e.grid AND l.produto = p.grid AND l.data=('2023-03-12 08:41:05'::date - interval '1 month')::date
	AND l.operacao = 'V'
), 0) AS faturamento_m_1,

--	Faturamendo no mesmo dia, porém no ano anterior
COALESCE((SELECT SUM(valor) FROM lancto l 
	JOIN produto p ON p.grid=l.produto	
	JOIN grupo_produto gpl ON gpl.grid=p.grupo AND gpl.nome = gp.nome
	WHERE l.empresa = e.grid AND l.produto = p.grid AND l.data=('2023-03-12 08:41:05'::date - interval '1 year')::date
	AND l.operacao = 'V'
), 0) AS faturamento_a_1,

--	Acumulado do ano anterior
COALESCE((SELECT SUM(l.valor) FROM lancto l 
	JOIN produto p ON p.grid=l.produto	
	JOIN grupo_produto gpl ON gpl.grid=p.grupo AND gpl.nome = gp.nome
	WHERE l.empresa = e.grid AND l.produto = p.grid 
		AND l.data BETWEEN
			(DATE_TRUNC('month', '2023-03-12 08:41:05'::date)::date - interval '1 year')::date
			AND
			((DATE_TRUNC('month', '2023-03-12 08:41:05'::date - interval '1 year')::date + interval '1 month') - interval '1 day')::date
		AND l.operacao = 'V'
	group by l.empresa
), 0) AS acumulado_a_1,

--	Acumulado do mês anterior
COALESCE((SELECT SUM(l.valor) FROM lancto l 
	JOIN produto p ON p.grid=l.produto	
	JOIN grupo_produto gpl ON gpl.grid=p.grupo AND gpl.nome = gp.nome
	WHERE l.empresa = e.grid AND l.produto = p.grid 
		AND l.data BETWEEN
			(DATE_TRUNC('month', '2023-03-12 08:41:05'::date)::date - interval '1 month')::date
			AND
			((DATE_TRUNC('month', '2023-03-12 08:41:05'::date - interval '1 month')::date + interval '1 month') - interval '1 day')::date
		AND l.operacao = 'V'
	group by l.empresa
), 0) AS acumulado_m_1,

--	Acumulado do dia selecionado
COALESCE((SELECT SUM(l.valor) FROM lancto l 
	JOIN produto p ON p.grid=l.produto	
	JOIN grupo_produto gpl ON gpl.grid=p.grupo AND gpl.nome = gp.nome
	WHERE l.empresa = e.grid AND l.produto = p.grid 
		AND l.data BETWEEN
			(DATE_TRUNC('month', '2023-03-12 08:41:05'::date))::date
			AND
			((DATE_TRUNC('month', '2023-03-12 08:41:05'::date)::date + interval '1 month') - interval '1 day')::date
		AND l.operacao = 'V'
	group by l.empresa
), 0) AS acumulado_dia

FROM empresa AS e

JOIN deposito d ON d.empresa=e.grid	
JOIN deposito_grupo_produto dgp ON dgp.deposito=d.grid
JOIN grupo_produto gp ON dgp.grupo=gp.grid

WHERE e.grid = 1 AND e.grupo = 107

GROUP BY e.grid, gp.nome
ORDER BY e.grid, gp.nome;

/*
	COLOCAR PARA MANUAL COMO
	e.grupo,
	e.grupo &
	Todas a datas, colocar para $data_ini
*/


SELECT 

(
	SELECT gps.nome FROM lancto ls 
	JOIN produto ps ON ps.grid=ls.produto	
	JOIN grupo_produto gps ON gps.grid=p.grupo AND gps.nome = gp.nome
	WHERE gps.grid not in (192)
) AS grupos,

FROM lancto l 

JOIN produto p ON p.grid = l.produto
JOIN grupo gp ON gp.grid = p.grupo
JOIN empresa e ON e.grid = l.empresa

-------------

SELECT

gp.nome AS grupo_nome,

--	Faturamento do dia
COALESCE((SELECT SUM(valor) FROM lancto l 
	JOIN produto p ON p.grid=l.produto	
	JOIN grupo_produto gpl ON gpl.grid=p.grupo AND gpl.nome = gp.nome
	WHERE l.empresa = e.grid AND l.produto = p.grid AND l.data=$data_ini::date
	AND l.operacao = 'V'
), 0) AS faturamento_dia,

--	Faturamendo no mesmo dia, porém no mês anterior
COALESCE(
	(SELECT SUM(valor) FROM lancto l 
	JOIN produto p ON p.grid=l.produto	
	JOIN grupo_produto gpl ON gpl.grid=p.grupo AND gpl.nome = gp.nome
	WHERE l.empresa = e.grid AND l.produto = p.grid AND l.data=($data_ini::date - interval '1 month')::date
	AND l.operacao = 'V'
), 0) AS faturamento_m_1,

--	Faturamendo no mesmo dia, porém no ano anterior
COALESCE((SELECT SUM(valor) FROM lancto l 
	JOIN produto p ON p.grid=l.produto	
	JOIN grupo_produto gpl ON gpl.grid=p.grupo AND gpl.nome = gp.nome
	WHERE l.empresa = e.grid AND l.produto = p.grid AND l.data=($data_ini::date - interval '1 year')::date
	AND l.operacao = 'V'
), 0) AS faturamento_a_1,

--	Acumulado do ano anterior
COALESCE((SELECT SUM(l.valor) FROM lancto l 
	JOIN produto p ON p.grid=l.produto	
	JOIN grupo_produto gpl ON gpl.grid=p.grupo AND gpl.nome = gp.nome
	WHERE l.empresa = e.grid AND l.produto = p.grid 
		AND l.data BETWEEN
			(DATE_TRUNC('month', $data_ini::date)::date - interval '1 year')::date
			AND
			((DATE_TRUNC('month', $data_ini::date - interval '1 year')::date + interval '1 month') - interval '1 day')::date
		AND l.operacao = 'V'
	group by l.empresa
), 0) AS acumulado_a_1,

--	Acumulado do mês anterior
COALESCE((SELECT SUM(l.valor) FROM lancto l 
	JOIN produto p ON p.grid=l.produto	
	JOIN grupo_produto gpl ON gpl.grid=p.grupo AND gpl.nome = gp.nome
	WHERE l.empresa = e.grid AND l.produto = p.grid 
		AND l.data BETWEEN
			(DATE_TRUNC('month', $data_ini::date)::date - interval '1 month')::date
			AND
			((DATE_TRUNC('month', $data_ini::date - interval '1 month')::date + interval '1 month') - interval '1 day')::date
		AND l.operacao = 'V'
	group by l.empresa
), 0) AS acumulado_m_1,

--	Acumulado do dia selecionado
COALESCE((SELECT SUM(l.valor) FROM lancto l 
	JOIN produto p ON p.grid=l.produto	
	JOIN grupo_produto gpl ON gpl.grid=p.grupo AND gpl.nome = gp.nome
	WHERE l.empresa = e.grid AND l.produto = p.grid 
		AND l.data BETWEEN
			(DATE_TRUNC('month', $data_ini::date))::date
			AND
			((DATE_TRUNC('month', $data_ini::date)::date + interval '1 month') - interval '1 day')::date
		AND l.operacao = 'V'
	group by l.empresa
), 0) AS acumulado_dia

FROM empresa AS e

JOIN deposito d ON d.empresa=e.grid	
JOIN deposito_grupo_produto dgp ON dgp.deposito=d.grid
JOIN grupo_produto gp ON dgp.grupo=gp.grid

WHERE e.grid = $empresa

GROUP BY e.grid, gp.nome
ORDER BY e.grid, gp.nome;


-------


SELECT

gp.nome AS grupo_nome,

--	Faturamento do dia
COALESCE((SELECT SUM(valor) FROM lancto l 
	JOIN produto p ON gp.grid=p.grupo	
	WHERE l.empresa = e.grid AND l.produto = p.grid AND l.data='2023-03-12 08:41:05'::date
), 0) AS faturamento_dia,

--	Faturamendo no mesmo dia, porém no mês anterior
COALESCE((SELECT SUM(valor) FROM lancto l 
	JOIN produto p ON gp.grid=p.grupo	
	WHERE l.empresa = e.grid AND l.produto = p.grid AND l.data=('2023-03-12 08:41:05'::date - interval '1 month')::date
), 0) AS faturamento_m_1,

--	Faturamendo no mesmo dia, porém no ano anterior
COALESCE((SELECT SUM(valor) FROM lancto l 
	JOIN produto p ON gp.grid=p.grupo	
	WHERE l.empresa = e.grid AND l.produto = p.grid AND l.data=('2023-03-12 08:41:05'::date - interval '1 year')::date
), 0) AS faturamento_a_1,

--	Acumulado do mês selecionado
COALESCE((SELECT SUM(l.valor) FROM lancto l 
	JOIN produto p ON gp.grid=p.grupo	
	WHERE l.empresa = e.grid AND l.produto = p.grid 
		AND l.data BETWEEN
			(DATE_TRUNC('month', '2023-03-12 08:41:05'::date))::date
			AND
			((DATE_TRUNC('month', '2023-03-12 08:41:05'::date)::date + interval '1 month') - interval '1 day')::date
		AND l.operacao = 'V'
	group by l.empresa
), 0) AS acumulado_dia,

--	Acumulado do mês anterior
COALESCE((SELECT SUM(l.valor) FROM lancto l 
	JOIN produto p ON gp.grid=p.grupo	
	WHERE l.empresa = e.grid AND l.produto = p.grid 
		AND l.data BETWEEN
			(DATE_TRUNC('month', '2023-03-12 08:41:05'::date)::date - interval '1 month')::date
			AND
			((DATE_TRUNC('month', '2023-03-12 08:41:05'::date - interval '1 month')::date + interval '1 month') - interval '1 day')::date
		AND l.operacao = 'V'
	group by l.empresa
), 0) AS acumulado_m_1,

--	Acumulado do ano anterior
COALESCE((SELECT SUM(l.valor) FROM lancto l 
	JOIN produto p ON gp.grid=p.grupo	
	WHERE l.empresa = e.grid AND l.produto = p.grid 
		AND l.data BETWEEN
			(DATE_TRUNC('month', '2023-03-12 08:41:05'::date)::date - interval '1 year')::date
			AND
			((DATE_TRUNC('month', '2023-03-12 08:41:05'::date - interval '1 year')::date + interval '1 month') - interval '1 day')::date
		AND l.operacao = 'V'
	group by l.empresa
), 0) AS acumulado_a_1

FROM empresa AS e

JOIN deposito d ON d.empresa=e.grid				
JOIN deposito_grupo_produto dgp ON dgp.deposito=d.grid	
JOIN grupo_produto gp ON dgp.grupo=gp.grid				

WHERE e.grid = 1 and dgp.grupo not in (192)									

GROUP BY e.grid, gp.nome, gp.grid						
ORDER BY e.grid, gp.nome;

-----------------------------------------------

UNION ALL

SELECT 
pp.nome as grupo_nome,

--	Faturamento do dia
COALESCE((SELECT SUM(valor) FROM lancto l 
			WHERE l.empresa = lp.empresa 
			AND l.produto = lp.produto 
			AND l.data='2023-03-12 08:41:05'::date
			AND l.operacao = 'V'
), 0) AS faturamento_dia,

--	Faturamendo no mesmo dia, porém no mês anterior
COALESCE((SELECT SUM(valor) FROM lancto l 
			WHERE l.empresa = lp.empresa 
			AND l.produto = lp.produto 
			AND l.data=('2023-03-12 08:41:05'::date - interval '1 month')::date
			AND l.operacao = 'V'
), 0) AS faturamento_m_1,

--	Faturamendo no mesmo dia, porém no ano anterior
COALESCE((SELECT SUM(valor) FROM lancto l 
			WHERE l.empresa = lp.empresa 
			AND l.produto = lp.produto 
			AND l.data=('2023-03-12 08:41:05'::date - interval '1 year')::date
			AND l.operacao = 'V'
), 0) AS faturamento_a_1,

--	Acumulado do mês selecionado
COALESCE((SELECT SUM(l.valor) FROM lancto l 
		WHERE l.empresa = lp.empresa 
		AND l.produto = lp.produto 
		AND l.data BETWEEN
			(DATE_TRUNC('month', '2023-03-12 08:41:05'::date))::date
			AND
			((DATE_TRUNC('month', '2023-03-12 08:41:05'::date)::date + interval '1 month') - interval '1 day')::date
		AND l.operacao = 'V'
), 0) AS acumulado_dia,

--	Acumulado do mês anterior
COALESCE((SELECT SUM(l.valor) FROM lancto l 
		WHERE 
		l.empresa = lp.empresa 
		AND l.produto = lp.produto 
		AND l.data BETWEEN
			(DATE_TRUNC('month', '2023-03-12 08:41:05'::date)::date - interval '1 month')::date
			AND
			((DATE_TRUNC('month', '2023-03-12 08:41:05'::date - interval '1 month')::date + interval '1 month') - interval '1 day')::date
		AND l.operacao = 'V'
	group by l.empresa
), 0) AS acumulado_m_1,

--	Acumulado do ano anterior
COALESCE((SELECT SUM(l.valor) FROM lancto l 
		WHERE 
		l.empresa = lp.empresa 
		AND l.produto = lp.produto 
		AND l.data BETWEEN
			(DATE_TRUNC('month', '2023-03-12 08:41:05'::date)::date - interval '1 year')::date
			AND
			((DATE_TRUNC('month', '2023-03-12 08:41:05'::date - interval '1 year')::date + interval '1 month') - interval '1 day')::date
		AND l.operacao = 'V'
	group by l.empresa
), 0) AS acumulado_a_1

from lancto lp
LEFT JOIN produto pp 
	ON pp.grid = lp.produto
WHERE 
	pp.grupo IN (192)
	AND lp.data = '2023-03-12 08:41:05'::date
	AND lp.empresa = 1
GROUP BY pp.grid, lp.empresa, lp.produto;

---------------------------------------------

SELECT

gp.nome AS grupo_nome,

--	Faturamento do dia
COALESCE((SELECT SUM(valor) FROM lancto l 
	JOIN produto p ON gp.grid=p.grupo	
	WHERE l.empresa = e.grid AND l.produto = p.grid AND l.data='2023-03-12 08:41:05'::date
), 0) AS faturamento_dia,

--	Faturamendo no mesmo dia, porém no mês anterior
COALESCE((SELECT SUM(valor) FROM lancto l 
	JOIN produto p ON gp.grid=p.grupo	
	WHERE l.empresa = e.grid AND l.produto = p.grid AND l.data=('2023-03-12 08:41:05'::date - interval '1 month')::date
), 0) AS faturamento_m_1,

--	Faturamendo no mesmo dia, porém no ano anterior
COALESCE((SELECT SUM(valor) FROM lancto l 
	JOIN produto p ON gp.grid=p.grupo	
	WHERE l.empresa = e.grid AND l.produto = p.grid AND l.data=('2023-03-12 08:41:05'::date - interval '1 year')::date
), 0) AS faturamento_a_1,

--	Acumulado do mês selecionado
COALESCE((SELECT SUM(l.valor) FROM lancto l 
	JOIN produto p ON gp.grid=p.grupo	
	WHERE l.empresa = e.grid AND l.produto = p.grid 
		AND l.data BETWEEN
			(DATE_TRUNC('month', '2023-03-12 08:41:05'::date))::date
			AND
			((DATE_TRUNC('month', '2023-03-12 08:41:05'::date)::date + interval '1 month') - interval '1 day')::date
		AND l.operacao = 'V'
	group by l.empresa
), 0) AS acumulado_dia,

--	Acumulado do mês anterior
COALESCE((SELECT SUM(l.valor) FROM lancto l 
	JOIN produto p ON gp.grid=p.grupo	
	WHERE l.empresa = e.grid AND l.produto = p.grid 
		AND l.data BETWEEN
			(DATE_TRUNC('month', '2023-03-12 08:41:05'::date)::date - interval '1 month')::date
			AND
			((DATE_TRUNC('month', '2023-03-12 08:41:05'::date - interval '1 month')::date + interval '1 month') - interval '1 day')::date
		AND l.operacao = 'V'
	group by l.empresa
), 0) AS acumulado_m_1,

--	Acumulado do ano anterior
COALESCE((SELECT SUM(l.valor) FROM lancto l 
	JOIN produto p ON gp.grid=p.grupo	
	WHERE l.empresa = e.grid AND l.produto = p.grid 
		AND l.data BETWEEN
			(DATE_TRUNC('month', '2023-03-12 08:41:05'::date)::date - interval '1 year')::date
			AND
			((DATE_TRUNC('month', '2023-03-12 08:41:05'::date - interval '1 year')::date + interval '1 month') - interval '1 day')::date
		AND l.operacao = 'V'
	group by l.empresa
), 0) AS acumulado_a_1

FROM empresa AS e

JOIN deposito d ON d.empresa=e.grid				
JOIN deposito_grupo_produto dgp ON dgp.deposito=d.grid	
JOIN grupo_produto gp ON dgp.grupo=gp.grid				

WHERE e.grid = 1 and dgp.grupo not in (192)									

UNION

SELECT 
pp.nome as grupo_nome,

--	Faturamento do dia
COALESCE((SELECT SUM(l.valor) FROM lancto l 
			WHERE l.empresa = lp.empresa 
			AND l.produto = lp.produto 
			AND l.data='2023-03-12 08:41:05'::date
			AND l.operacao = 'V'
), 0) AS faturamento_dia,

--	Faturamendo no mesmo dia, porém no mês anterior
COALESCE((SELECT SUM(l.valor) FROM lancto l 
			WHERE l.empresa = lp.empresa 
			AND l.produto = lp.produto 
			AND l.data=('2023-03-12 08:41:05'::date - interval '1 month')::date
			AND l.operacao = 'V'
), 0) AS faturamento_m_1,

--	Faturamendo no mesmo dia, porém no ano anterior
COALESCE((SELECT SUM(l.valor) FROM lancto l 
			WHERE l.empresa = lp.empresa 
			AND l.produto = lp.produto 
			AND l.data=('2023-03-12 08:41:05'::date - interval '1 year')::date
			AND l.operacao = 'V'
), 0) AS faturamento_a_1,

--	Acumulado do mês selecionado
COALESCE((SELECT SUM(l.valor) FROM lancto l 
		WHERE l.empresa = lp.empresa 
		AND l.produto = lp.produto 
		AND l.data BETWEEN
			(DATE_TRUNC('month', '2023-03-12 08:41:05'::date))::date
			AND
			((DATE_TRUNC('month', '2023-03-12 08:41:05'::date)::date + interval '1 month') - interval '1 day')::date
		AND l.operacao = 'V'
), 0) AS acumulado_dia,

--	Acumulado do mês anterior
COALESCE((SELECT SUM(l.valor) FROM lancto l 
		WHERE 
		l.empresa = lp.empresa 
		AND l.produto = lp.produto 
		AND l.data BETWEEN
			(DATE_TRUNC('month', '2023-03-12 08:41:05'::date)::date - interval '1 month')::date
			AND
			((DATE_TRUNC('month', '2023-03-12 08:41:05'::date - interval '1 month')::date + interval '1 month') - interval '1 day')::date
		AND l.operacao = 'V'
	group by l.empresa
), 0) AS acumulado_m_1,

--	Acumulado do ano anterior
COALESCE((SELECT SUM(l.valor) FROM lancto l 
		WHERE 
		l.empresa = lp.empresa 
		AND l.produto = lp.produto 
		AND l.data BETWEEN
			(DATE_TRUNC('month', '2023-03-12 08:41:05'::date)::date - interval '1 year')::date
			AND
			((DATE_TRUNC('month', '2023-03-12 08:41:05'::date - interval '1 year')::date + interval '1 month') - interval '1 day')::date
		AND l.operacao = 'V'
	group by l.empresa
), 0) AS acumulado_a_1

from lancto lp
LEFT JOIN produto pp 
	ON pp.grid = lp.produto
WHERE 
	pp.grupo IN (192)
	AND lp.data BETWEEN
		(DATE_TRUNC('month', '2023-03-12 08:41:05'::date)::date - interval '1 year')::date 
		AND 
		((DATE_TRUNC('month', '2023-03-12 08:41:05'::date)::date + interval '1 month') - interval '1 day')::date
	AND lp.empresa = 1
GROUP BY pp.grid, lp.empresa, lp.produto
ORDER BY grupo_nome;