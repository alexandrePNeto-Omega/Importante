# --- Título --- #

POSTOSAS3-15646: Assinatura Digital

# --- Descrição --- #

Descrição: Efetuado ajustes em rotinas da assintura digital.

# --- Documentação de teste --- #

**Rotina**
 - Geração de faturas com assinatura digital: Financeiro > Contas a Receber > Geração de Faturas.
 - Envio de assinatura: Financeiro > Envio de Assinaturas > Filtrar > Opções: Enviar E-mail, Exportar Assinaturas.
 - Regras do cliente: Cadastros > Cliente > Politica Comercial > Conta.

**Rotina impactada**
 - Geração de faturas.
 - Envio de assinaturas.
 - Venda.

**Problema**
 - Erro na geração de fatura com assinatura digital, quando existe uma assinatura em .pdf.
 - Erro no envio de email e exportação da assinatura digital.
 - Tela de solicitação de assinatura, abrindo múltiplas vezes no PDV, quando um cliente está com mais de uma regra de conta configura para mais de uma empresa.

**Correção**
 - Ajuste na validação do arquivo, onde agora valida se o mesmo é .pdf, realizando os procedimentos necessários para o mesmo.
 - Ajuste no envio de e-mail, e salvando o arquivo da forma correta, onde antes caso o arquivo era .pdf, ele era salvo como .png, sendo assim impossível abrir o arquivo.
 - Ajuste na exportação da assinatura digital, onde a mesma estava salvando a assinatura como .png, mesmo sendo .pdf, sendo agora salvo corretamente.
 - Ajuste na validação da politica comercial do cliente, onde não era validada caso existisse mais de uma conta de vencimento configurada para mais de uma empresa, onde agora é validado até o grupo.

**Procedimentos**
 - Geração de faturas, Envio de assinturas:
    - Realizar vendas da assinatura digital em uma versão inferior as 3.3.1.120, gerando assinaturas de .pdf, em seguida realizar vendas em uma versão recente(Acima da 3.3.1.130) para que sejam geradas assinaturas em .png.
 - Regras do cliente:
    - Realizar mais de um cadastro de regra de vencimento com a assinatura digital configurada para mais de uma empresa no cliente pela Matriz, em seguida sincronizar as informações e realizar uma venda na filial com o movito de movimentação ao qual foi configurado o vencimento com a assinatura no cliente.

**ISSUES, relacionadas a essa PR**
 - https://jira.linx.com.br/browse/POSTOSAS3-15914 : Melhoria na tela do envio e expotação de assinaturas
 - https://jira.linx.com.br/browse/POSTOSAS3-15915 : Regras do Cliente