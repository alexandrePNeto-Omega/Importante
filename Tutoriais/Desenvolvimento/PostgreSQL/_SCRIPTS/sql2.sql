SELECT
gp.grid,
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

GROUP BY e.grid, gp.grid						
ORDER BY e.grid, gp.nome;

------------

SELECT

gp.nome AS grupo_nome,

--	Faturamento do dia
COALESCE(
	(SELECT SUM(valor) FROM lancto l 
	JOIN produto p ON p.grid=l.produto	
	JOIN grupo_produto gpl ON gpl.grid=p.grupo AND gpl.nome = gp.nome
	WHERE l.empresa = e.grid AND l.produto = p.grid AND l.data='2023-03-12 08:41:05'::date
), 0) AS faturamento_dia,

--	Faturamendo no mesmo dia, porém no mês anterior
COALESCE(
	(SELECT SUM(valor) FROM lancto l 
	JOIN produto p ON p.grid=l.produto	
	JOIN grupo_produto gpl ON gpl.grid=p.grupo AND gpl.nome = gp.nome
	WHERE l.empresa = e.grid AND l.produto = p.grid AND l.data=('2023-03-12 08:41:05'::date - interval '1 month')::date
), 0) AS faturamento_m_1,

--	Faturamendo no mesmo dia, porém no ano anterior
COALESCE((SELECT SUM(valor) FROM lancto l 
	JOIN produto p ON p.grid=l.produto	
	JOIN grupo_produto gpl ON gpl.grid=p.grupo AND gpl.nome = gp.nome
	WHERE l.empresa = e.grid AND l.produto = p.grid AND l.data=('2023-03-12 08:41:05'::date - interval '1 year')::date
), 0) AS faturamento_a_1,

--	Acumulado do mês selecionado
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
), 0) AS acumulado_dia,

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
), 0) AS acumulado_a_1

FROM empresa AS e

JOIN deposito d ON d.empresa=e.grid				
JOIN deposito_grupo_produto dgp ON dgp.deposito=d.grid	
JOIN grupo_produto gp ON dgp.grupo=gp.grid				

WHERE e.grid = 1										

GROUP BY e.grid, gp.nome
ORDER BY e.grid, gp.nome;

------------


SELECT

gp.nome AS grupo_nome,

--	Faturamento do dia
COALESCE(
	(SELECT SUM(valor) FROM lancto l 
	JOIN produto p ON p.grid=l.produto	
	JOIN grupo_produto gpl ON gpl.grid=p.grupo AND gpl.nome = gp.nome
	WHERE l.empresa = e.grid AND l.produto = p.grid AND l.data='2023-03-12 08:41:05'::date
), 0) AS faturamento_dia,

--	Faturamendo no mesmo dia, porém no mês anterior
COALESCE(
	(SELECT SUM(valor) FROM lancto l 
	JOIN produto p ON p.grid=l.produto	
	JOIN grupo_produto gpl ON gpl.grid=p.grupo AND gpl.nome = gp.nome
	WHERE l.empresa = e.grid AND l.produto = p.grid AND l.data=('2023-03-12 08:41:05'::date - interval '1 month')::date
), 0) AS faturamento_m_1,

--	Faturamendo no mesmo dia, porém no ano anterior
COALESCE((SELECT SUM(valor) FROM lancto l 
	JOIN produto p ON p.grid=l.produto	
	JOIN grupo_produto gpl ON gpl.grid=p.grupo AND gpl.nome = gp.nome
	WHERE l.empresa = e.grid AND l.produto = p.grid AND l.data=('2023-03-12 08:41:05'::date - interval '1 year')::date
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

WHERE e.grid = 1										

GROUP BY e.grid, gp.nome
ORDER BY e.grid, gp.nome;