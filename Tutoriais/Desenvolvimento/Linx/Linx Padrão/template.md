# --- T�tulo --- #

POSTOSAS3-15646: Assinatura Digital - Venda e exporta��o dos dados

# --- Descri��o --- # Sempre coloque o impacto final

Efetuado ajustes e melhorias nas rotinas da assintura digital como gera��o de faturas, envio de assinaturas por e-mail, e finaliza��o da venda.

# --- Documenta��o de teste --- #

**Rotina**
 - Envio de assinatura: Financeiro > Envio de Assinaturas > Filtrar > Op��es: Enviar E-mail, Exportar Assinaturas.
 - Gera��o de faturas com assinatura digital: Financeiro > Contas a Receber > Gera��o de Faturas.
 - Regras do cliente: Cadastros > Cliente > Politica Comercial > Conta.

**Rotina impactada**
 - Gera��o de faturas com assinatura digital.
 - Tela de envio de assinatura.
 - Venda para cliente identificado.

**Problema**
 - Erro na gera��o de fatura com assinatura digital, quando existe uma assinatura em .pdf no banco de dados. Impacto PR: XXXXX
 - Erro no envio de email e exporta��o da assinatura digital. Impacto PR: XXXXX
 - Tela de solicita��o de assinatura, abrindo m�ltiplas vezes no PDV, quando um cliente est� com mais de uma regra de conta configura na politica comercial para mais de uma empresa.

**Corre��o**
 - Ajuste na valida��o do arquivo, onde agora valida se o mesmo � .pdf, realizando os procedimentos necess�rios para o mesmo.
 - Ajuste no envio de e-mail, e salvando o arquivo da forma correta, onde antes caso o arquivo era .pdf, ele era salvo como .png, sendo assim imposs�vel abrir o arquivo.
 - Ajuste na exporta��o da assinatura digital, onde a mesma estava salvando a assinatura como .png, mesmo sendo .pdf, sendo agora salvo corretamente.
 - Ajuste na valida��o da politica comercial do cliente, onde n�o era validada caso existisse mais de uma conta de vencimento configurada para mais de uma empresa, onde agora � validado at� o grupo.

**Procedimentos**
 - Gera��o de faturas, Envio de assinturas:
    - Realizar vendas da assinatura digital em uma vers�o inferior as 3.3.1.120, gerando assinaturas de .pdf, em seguida realizar vendas em uma vers�o recente(Acima da 3.3.1.130) para que sejam geradas assinaturas em .png. Realizar faturamento desses registros e envio por e-mail.
 - Regras do cliente:
    - Realizar mais de um cadastro de regra de vencimento com a assinatura digital configurada para mais de uma empresa no cliente pela Matriz, em seguida sincronizar as informa��es e realizar uma venda na filial com o movito de movimenta��o ao qual foi configurado o vencimento com a assinatura no cliente.

**ISSUES, relacionadas a essa PR**
 - https://jira.linx.com.br/browse/POSTOSAS3-15914 : Melhoria na tela do envio e expota��o de assinaturas
 - https://jira.linx.com.br/browse/POSTOSAS3-15915 : Regras do Cliente


No devazure, pode criar uma PR e colocar as coisas l�
No JIRA, vincular o link e colocar o nome como PR