CREATE PROCEDURE FI_SP_ListarBeneficiariosPorCliente
    @IDCLIENTE BIGINT
AS
BEGIN
    SELECT ID, NOME, CPF, IDCLIENTE
    FROM BENEFICIARIOS
    WHERE IDCLIENTE = @IDCLIENTE
END
