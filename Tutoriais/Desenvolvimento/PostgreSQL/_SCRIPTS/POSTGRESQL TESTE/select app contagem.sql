SELECT cpf AS "CNPJ", 
nome AS "Razão Social",
CASE WHEN codigo::integer < 10 then '0' else '' END ||
codigo 	||
' - '	||
trim(replace((replace(replace(replace(UPPER(nome_reduzido), 'POSTO', ''), 'AUTO', ''), '-', '')), 'LTDA', '')) as "Nome reduzido para o gestao",
estado AS "UF",
codigo AS "Codigo",
grid AS "Grid"
from empresa order by codigo;