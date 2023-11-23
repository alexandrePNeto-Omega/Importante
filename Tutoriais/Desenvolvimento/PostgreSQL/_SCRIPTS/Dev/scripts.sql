SELECT * FROM comercial.cliente c 
INNER JOIN comercial.voucher v ON v.idcliente = c.idcliente
ORDER BY c.idcliente;
---------------------------------------------------------------------------------------------
SELECT vc.idvoucherconfig,vc.descricao,
CASE WHEN v.idvoucher is not null THEN true else false end as gerado
FROM comercial.voucherconfig vc
LEFT JOIN comercial.voucher v ON (v.idvoucherconfig=vc.idvoucherconfig and v.idcliente=1);


SELECT * FROM comercial.voucher;


--------------------


SELECT * FROM comercial.voucher v
INNER JOIN comercial.voucherconfig vc ON vc.idvoucherconfig = v.idvoucherconfig
WHERE codigovoucher='1OXI730DEI';

-------------------------
UPDATE comercial.voucher SET data_uso = :data_uso 
WHERE idvoucher = :ididvoucher 
AND codigovoucher = :codigovoucher
AND idvoucherconfig = :idvoucherconfig;

------------------
UPDATE comercial.voucher SET data_uso = null
WHERE idvoucher = 6
AND codigovoucher = '1OXI730DEI'
AND idvoucherconfig = 2;

------------------------------ VOUCHER POR CLIENTE
SELECT 
CASE WHEN (v.data_uso IS NOT null) 
	THEN 'SIM'
	ELSE 'NÃO'
END as ativo,
c.cnpj,
c.nomereduzido,
vc.descricao,
v.codigovoucher
FROM comercial.voucherconfig vc 
LEFT JOIN
	comercial.voucher v 
		ON vc.idvoucherconfig = v.idvoucherconfig
LEFT JOIN 
	comercial.cliente c
		ON v.idcliente = c.idcliente
ORDER BY v.data_uso, c.idcliente, vc.descricao desc;