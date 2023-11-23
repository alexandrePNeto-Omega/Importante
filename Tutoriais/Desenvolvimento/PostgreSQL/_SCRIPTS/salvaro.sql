SELECT DISTINCT

e.nome_reduzido as empresa,
p.codigo as  codigo_produto,
gp.nome as nome_grupo,
p.nome as nome_produto,
p.flag as flag_produto,
COALESCE(
    pe.preco_custo,
    p.preco_custo,
    0.0) as preco_custo,
(SELECT 
    (CASE WHEN MAX(hora) IS NOT NULL
        THEN TO_CHAR(MAX(hora), 'DD/MM/YYYY HH:MI:SS')
        ELSE 'Sem movimentação'
    END)
FROM lancto 
    WHERE 
        produto = p.grid
         AND empresa = e.grid) as ultimo_movimento

FROM produto p

JOIN grupo_produto gp
    ON gp.grid = p.grupo
JOIN deposito_grupo_produto dgp
    ON dgp.grupo = gp.grid
JOIN deposito d
    ON d.grid = dgp.deposito
LEFT JOIN produto_empresa pe
    ON pe.produto = p.grid
LEFT JOIN empresa e
    ON e.grid = d.empresa

WHERE 
    e.grid = 9207998
    AND (CASE
            WHEN 0 = 1
                THEN p.flag IN ('I', 'E')
            WHEN 0 = 1
                THEN p.flag IN ('A', 'I', 'E')
            ELSE p.flag = 'A'
        END)
    AND COALESCE(
        pe.preco_custo,
        p.preco_custo) <= 0
    
GROUP BY e.grid, e.nome_reduzido, p.grid, pe.preco_custo, gp.nome
ORDER BY empresa, ultimo_movimento, nome_grupo, p.flag DESC;

/*  Colocar:
    $empresa,
    $inativo &
    $todos  */

-----------------------------------------------------------------------------------------------------------------------------

1 nome_grupo        tam=15	 
2 codigo_produto    tam=15         
3 nome_produto      tam=30      
4 flag_produto      tam=2      
5 preco_custo       tam=4  	fmt=float2
6 ultimo_movimento  tam=20        


<cab_pagina>                                                                                                   
+----------------+-----------------+-----------------+-------+--------+---------------------+
| Grupo          | Código          | Produto         | Custo | Status | Movimentação        |
+----------------+-----------------+-----------------+-------+--------+---------------------+
</cab_pagina>
<detalhe>
| #1             | #2              | #3              | #4    |     #5 | #6                  |
</detalhe>
<rod_relat>
+----------------+-----------------+-----------------+-------+--------+---------------------+
</rod_relat>
<rod_pagina>
+----------------+-----------------+-----------------+-------+--------+---------------------+
</rod_pagina>

SELECT DISTINCT

e.nome_reduzido as empresa,
p.codigo as  codigo_produto,
gp.nome as nome_grupo,
p.nome as nome_produto,
p.flag as flag_produto,
COALESCE(
    pe.preco_custo,
    p.preco_custo,
    0.0) as preco_custo,
(SELECT 
    (CASE WHEN MAX(hora) IS NOT NULL
        THEN TO_CHAR(MAX(hora), 'DD/MM/YYYY HH:MI:SS')
        ELSE 'Sem movimentação'
    END)
FROM lancto 
    WHERE 
        produto = p.grid
         AND empresa = e.grid) as ultimo_movimento

FROM produto p

JOIN grupo_produto gp
    ON gp.grid = p.grupo
JOIN deposito_grupo_produto dgp
    ON dgp.grupo = gp.grid
JOIN deposito d
    ON d.grid = dgp.deposito
LEFT JOIN produto_empresa pe
    ON pe.produto = p.grid
LEFT JOIN empresa e
    ON e.grid = d.empresa

WHERE 
    e.grid = $empresa
    AND (CASE
            WHEN $inativo = True
                THEN p.flag IN ('I', 'E')
            WHEN $todos = True
                THEN p.flag IN ('A', 'I', 'E')
            ELSE p.flag = 'A'
        END)
    AND COALESCE(
        pe.preco_custo,
        p.preco_custo) <= 0
    
GROUP BY e.grid, e.nome_reduzido, p.grid, pe.preco_custo, gp.nome
ORDER BY empresa, ultimo_movimento, nome_grupo, p.flag DESC;
