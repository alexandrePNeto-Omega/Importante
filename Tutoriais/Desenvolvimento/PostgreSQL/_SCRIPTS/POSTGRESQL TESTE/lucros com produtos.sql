select grid as empresa ,(CASE WHEN length(nome_reduzido) > 0 THEN nome_reduzido ELSE nome END) as empresa_nome , codigo as empresa_codigo from empresa where flag='A'  and grid = 11998
UNION ALL
		SELECT 	g.codigo AS grupo_codigo, 
		g.nome AS grupo_nome, 
		p.codigo AS produto_codigo,
		p.nome AS produto_nome,
		p.grupo,
		p.tipo,
		l.produto,
		SUM(l.quantidade) AS qtde,
		SUM(l.valor) AS venda,
		COALESCE(pe.perc_imposto, p.perc_imposto, g.perc_imposto, 0) AS perc_imposto,
		t.tributacao , p.tributacao AS tributacao_codigo,
		t.descricao AS tributacao_nome,
		CASE WHEN (SELECT count(*) FROM produto_composicao WHERE produto = l.produto) = 0 THEN preco_custo_empresa_f(l.produto, l.empresa) ELSE (SELECT SUM(l1.preco_unit) / SUM(l1.quantidade) FROM lancto l1 WHERE l1.produto = l.produto AND l1.operacao = 'ER' AND l1.empresa = l.empresa AND l1.data BETWEEN '2023-04-01' AND '2023-07-31') END AS produto_preco_custo , (SELECT SUM(l1.valor) FROM lancto l1 WHERE operacao IN ('TE', 'I', 'E', 'C') AND l1.produto = l.produto AND l1.data between '2023-04-01' AND '2023-07-31' AND l1.empresa = l.empresa) AS valor_compra , (SELECT SUM(l2.quantidade) FROM lancto l2 WHERE l2.operacao IN ('TE', 'I', 'E', 'C') AND l2.produto = l.produto AND l2.data BETWEEN '2023-04-01' AND '2023-07-31' AND l2.empresa = l.empresa) AS qtd_compra , COALESCE(pe.custo_medio, 0) AS custo_medio , (SELECT coalesce(SUM(l3.quantidade),0) FROM lancto l3 WHERE l3.operacao = 'O' AND l3.produto = l.produto AND l3.data BETWEEN '2023-04-01' AND '2023-07-31' AND l3.empresa = l.empresa) AS qtd_bonificada 
		
		FROM lancto l JOIN produto p ON (l.produto=p.grid) LEFT JOIN grupo_produto g ON (p.grupo=g.grid) 
		
		LEFT JOIN produto_empresa pe ON (pe.produto=p.grid and pe.empresa=l.empresa) 
		
		LEFT JOIN tributacao t ON (p.tributacao=t.codigo)   WHERE l.empresa='11998' and l.data BETWEEN '2023-04-01' AND '2023-07-31' and l.operacao IN ('V') and p.tipo!='S' and (CASE WHEN p.tipo = 'C' THEN length(l.bico) > 0 ELSE True END) 
		
		GROUP BY g.codigo, g.nome, p.codigo, p.nome, p.grupo, p.tipo, l.produto, t.tributacao, p.tributacao, t.codigo, t.descricao, l.empresa, 10, pe.custo_medio, grupo_nome    
				
		ORDER BY g.nome, p.grupo , p.nome, p.tributacao;
		
