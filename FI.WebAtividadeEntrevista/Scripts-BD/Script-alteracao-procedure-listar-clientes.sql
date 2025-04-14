ALTER PROCEDURE FI_SP_PesqCliente
    @iniciarEm INT,
    @quantidade INT,
    @campoOrdenacao NVARCHAR(50),
    @crescente BIT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ordem NVARCHAR(100)

    SET @ordem = 
        CASE 
            WHEN @crescente = 1 THEN @campoOrdenacao + ' ASC'
            ELSE @campoOrdenacao + ' DESC'
        END

    -- Consulta paginada com aliases nos nomes
    DECLARE @SQL NVARCHAR(MAX)

    SET @SQL = '
    SELECT 
        ID AS Id,
        NOME AS Nome,
        SOBRENOME AS Sobrenome,
        NACIONALIDADE AS Nacionalidade,
        CEP AS CEP,
        ESTADO AS Estado,
        CIDADE AS Cidade,
        LOGRADOURO AS Logradouro,
        EMAIL AS Email,
        TELEFONE AS Telefone,
        CPF AS CPF
    FROM CLIENTES
    ORDER BY ' + @ordem + '
    OFFSET ' + CAST(@iniciarEm AS NVARCHAR) + ' ROWS
    FETCH NEXT ' + CAST(@quantidade AS NVARCHAR) + ' ROWS ONLY;

    SELECT COUNT(*) FROM CLIENTES;
    '

    EXEC sp_executesql @SQL
END
