CREATE PROCEDURE FI_SP_PesqBeneficiario
    @iniciarEm       INT,
    @quantidade      INT,
    @campoOrdenacao  VARCHAR(50),
    @crescente       BIT
AS
BEGIN
    DECLARE @ordem NVARCHAR(4)
    SET @ordem = CASE WHEN @crescente = 1 THEN 'ASC' ELSE 'DESC' END

    DECLARE @sql NVARCHAR(MAX)
    SET @sql = '
        SELECT ID, NOME, CPF, IDCLIENTE
        FROM (
            SELECT ROW_NUMBER() OVER (ORDER BY ' + QUOTENAME(@campoOrdenacao) + ' ' + @ordem + ') AS RowNum, *
            FROM BENEFICIARIOS
        ) AS Resultado
        WHERE RowNum BETWEEN ' + CAST(@iniciarEm AS VARCHAR) + ' + 1 AND ' + CAST(@iniciarEm + @quantidade AS VARCHAR) + ';

        SELECT COUNT(*) FROM BENEFICIARIOS;
    '

    EXEC sp_executesql @sql
END
