SELECT 

p.nome AS prod_nome,

--	Quantidade ano anterior
COALESCE((SELECT SUM(quantidade) FROM lancto
	WHERE 
		produto = p.grid
		AND data = ('2023-03-12 08:41:05'::date - interval '1 year')::date
		AND operacao = 'V'
		AND empresa = l.empresa
	GROUP BY produto
), 0) as quantidade_a1,

--	Quantidade mes anterior
COALESCE((SELECT SUM(quantidade) FROM lancto
	WHERE 
		produto = p.grid
		AND data = ('2023-03-12 08:41:05'::date - interval '1 month')::date
		AND operacao = 'V'
		AND empresa = l.empresa
	GROUP BY produto
), 0) as quantidade_m1,

--	Quantidade dia
COALESCE((SELECT SUM(quantidade) FROM lancto
	WHERE 
		produto = p.grid
		AND data = '2023-03-12'::date
		AND operacao = 'V'
		AND empresa = l.empresa
	GROUP BY produto
), 0) as quantidade_dia, 

--	Acumulado ano anterior
COALESCE((SELECT SUM(quantidade) FROM lancto
	WHERE 
		produto = p.grid
		AND operacao = 'V'
		AND empresa = l.empresa
		AND data BETWEEN
			(DATE_TRUNC('month', '2023-03-12 08:41:05'::date)::date - interval '1 year')::date
			AND
			((DATE_TRUNC('month', '2023-03-12 08:41:05'::date - interval '1 year')::date + interval '1 month') - interval '1 day')::date
	GROUP BY produto
), 0) as acumulado_a1,

--	Acumulado mes anterior
COALESCE((SELECT SUM(quantidade) FROM lancto
	WHERE 
		produto = p.grid
		AND operacao = 'V'
		AND empresa = l.empresa
		AND data BETWEEN
			(DATE_TRUNC('month', '2023-03-12 08:41:05'::date)::date - interval '1 month')::date
			AND
			((DATE_TRUNC('month', '2023-03-12 08:41:05'::date - interval '1 month')::date + interval '1 month') - interval '1 day')::date
	GROUP BY produto
), 0) as acumulado_m1,

--	Acumulado dia
COALESCE((SELECT SUM(quantidade) FROM lancto
	WHERE 
		produto = p.grid
		AND operacao = 'V'
		AND empresa = l.empresa
		AND data BETWEEN
			(DATE_TRUNC('month', '2023-03-12 08:41:05'::date))::date
			AND
			((DATE_TRUNC('month', '2023-03-12 08:41:05'::date)::date + interval '1 month') - interval '1 day')::date
	GROUP BY produto
), 0) as acumulado_dia


FROM lancto l

JOIN produto p ON (l.produto = p.grid)
JOIN empresa e ON (l.empresa = e.grid)

WHERE 
	l.empresa = 1	
	AND e.grupo = 107
	AND operacao = 'V'
	AND p.grupo = 192
	AND l.data BETWEEN 
		(DATE_TRUNC('month', '2023-03-12 08:41:05'::date)::date - interval '1 year')::date 
		AND 
		((DATE_TRUNC('month', '2023-03-12 08:41:05'::date)::date + interval '1 month') - interval '1 day')::date

GROUP BY l.produto, l.empresa, p.grid;

/*
	COLOCAR PARA MANUAL COMO
	e.grupo,
	l.empresa & $empresa
	Todas a datas, colocar para $data_ini
*/

---------------

SELECT 

p.nome AS prod_nome,

--	Quantidade ano anterior
COALESCE((SELECT SUM(quantidade) FROM lancto
	WHERE 
		produto = p.grid
		AND data = ($data_ini::date - interval '1 year')::date
		AND operacao = 'V'
		AND empresa = l.empresa
	GROUP BY produto
), 0) as quantidade_a1,

--	Quantidade mes anterior
COALESCE((SELECT SUM(quantidade) FROM lancto
	WHERE 
		produto = p.grid
		AND data = ($data_ini::date - interval '1 month')::date
		AND operacao = 'V'
		AND empresa = l.empresa
	GROUP BY produto
), 0) as quantidade_m1,

--	Quantidade dia
COALESCE((SELECT SUM(quantidade) FROM lancto
	WHERE 
		produto = p.grid
		AND data = $data_ini::date
		AND operacao = 'V'
		AND empresa = l.empresa
	GROUP BY produto
), 0) as quantidade_dia, 

--	Acumulado ano anterior
COALESCE((SELECT SUM(quantidade) FROM lancto
	WHERE 
		produto = p.grid
		AND operacao = 'V'
		AND empresa = l.empresa
		AND data BETWEEN
			(DATE_TRUNC('month', $data_ini::date)::date - interval '1 year')::date
			AND
			((DATE_TRUNC('month', $data_ini::date - interval '1 year')::date + interval '1 month') - interval '1 day')::date
	GROUP BY produto
), 0) as acumulado_a1,

--	Acumulado mes anterior
COALESCE((SELECT SUM(quantidade) FROM lancto
	WHERE 
		produto = p.grid
		AND operacao = 'V'
		AND empresa = l.empresa
		AND data BETWEEN
			(DATE_TRUNC('month', $data_ini::date)::date - interval '1 month')::date
			AND
			((DATE_TRUNC('month', $data_ini::date - interval '1 month')::date + interval '1 month') - interval '1 day')::date
	GROUP BY produto
), 0) as acumulado_m1,

--	Acumulado dia
COALESCE((SELECT SUM(quantidade) FROM lancto
	WHERE 
		produto = p.grid
		AND operacao = 'V'
		AND empresa = l.empresa
		AND data BETWEEN
			(DATE_TRUNC('month', $data_ini::date))::date
			AND
			((DATE_TRUNC('month', $data_ini::date)::date + interval '1 month') - interval '1 day')::date
	GROUP BY produto
), 0) as acumulado_dia


FROM lancto l

JOIN produto p ON (l.produto = p.grid)
JOIN empresa e ON (l.empresa = e.grid)

WHERE 
	l.empresa = $empresa	
	AND operacao = 'V'
	AND p.grupo = 192
	AND l.data BETWEEN 
		(DATE_TRUNC('month', $data_ini::date)::date - interval '1 year')::date 
		AND 
		((DATE_TRUNC('month', $data_ini::date)::date + interval '1 month') - interval '1 day')::date

GROUP BY l.produto, l.empresa, p.grid;