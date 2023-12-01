 SELECT
 	distinct
	 get_cmv(e.grid, pr.grid, '2021-01-01','2021-12-31', null),
	 e.nome as empresa,
	 e.grid as grid_empresa,
	 pr.grid as grid_produto,
	 pr.nome AS produto,
	 sum(l.quantidade) AS quantidade,
	 sum(ROUND(l.valor::numeric, 4)) AS valor,
	 l.data,
	 d.nome as deposito,
	 l.bico,
	 case
		 when pr.tipo = 'M' then 'MERCADORIA'
		 when pr.tipo = 'K' then 'KIT'
		 when pr.tipo = 'P' then 'METERIA PRIMA'
		 when pr.tipo = 'C' then 'COMBUSTIVEL'
	 end as tipo_produto,
	 CASE
		WHEN gp.nome IS NULL THEN 'NAO IDENTIFICADO'
		ELSE gp.nome
	 END AS grupo_cliente,
	 pe.nome as cliente, 
	 gpr.nome as grupo_produto
 FROM lancto l
	 JOIN produto pr ON (pr.grid=l.produto)
	 JOIN grupo_produto gpr on (gpr.grid=pr.grupo)
	 JOIN empresa e on (e.grid=l.empresa)
	 JOIN deposito d on (d.grid=l.deposito)
	 --JOIN pessoa ve ON (ve.grid=l.vendedor)
	 LEFT JOIN pessoa pe on (pe.grid=l.pessoa)
	 LEFT JOIN grupo_pessoa gp on (gp.grid=pe.grupo)
 WHERE l.operacao = 'V'
	 and pr.tipo in ('C', 'M', 'S')
	 AND l.data BETWEEN '2021-01-01' and '2021-12-31'
	 --AND l.vendedor IS NOT NULL
	 
	 group by e.nome, e.grid, pr.grid, pr.nome, l.data, d.nome, l.bico, pr.tipo, gp.nome, pe.nome, gpr.nome
 ORDER BY l.data