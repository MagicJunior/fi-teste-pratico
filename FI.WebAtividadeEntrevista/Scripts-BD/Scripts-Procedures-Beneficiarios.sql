-- ============================================
-- DROP PROCEDURES (garantir recriação limpa)
-- ============================================
IF OBJECT_ID('FI_SP_IncBeneficiario', 'P') IS NOT NULL
    DROP PROCEDURE FI_SP_IncBeneficiario;

IF OBJECT_ID('FI_SP_ConsBeneficiario', 'P') IS NOT NULL
    DROP PROCEDURE FI_SP_ConsBeneficiario;

IF OBJECT_ID('FI_SP_VerificaBeneficiario', 'P') IS NOT NULL
    DROP PROCEDURE FI_SP_VerificaBeneficiario;

IF OBJECT_ID('FI_SP_PesqBeneficiario', 'P') IS NOT NULL
    DROP PROCEDURE FI_SP_PesqBeneficiario;

IF OBJECT_ID('FI_SP_DelBeneficiario', 'P') IS NOT NULL
    DROP PROCEDURE FI_SP_DelBeneficiario;

IF OBJECT_ID('FI_SP_ListarBeneficiariosPorCliente', 'P') IS NOT NULL
    DROP PROCEDURE FI_SP_ListarBeneficiariosPorCliente;

IF OBJECT_ID('FI_SP_AltBeneficiario', 'P') IS NOT NULL
    DROP PROCEDURE FI_SP_AltBeneficiario;

-- ============================================
-- CREATE PROCEDURES
-- ============================================

-- Incluir Beneficiário
CREATE PROCEDURE FI_SP_IncBeneficiario
    @NOME       VARCHAR(50),
    @CPF        VARCHAR(11),
    @IDCLIENTE  BIGINT
AS
BEGIN
    INSERT INTO BENEFICIARIOS (NOME, CPF, IDCLIENTE)
    VALUES (@NOME, @CPF, @IDCLIENTE)

    SELECT SCOPE_IDENTITY()
END
GO

-- Consultar Beneficiário (por ID ou todos se Id = 0)
CREATE PROCEDURE FI_SP_ConsBeneficiario
    @ID BIGINT
AS
BEGIN
    IF @ID = 0
        SELECT * FROM BENEFICIARIOS
    ELSE
        SELECT * FROM BENEFICIARIOS WHERE ID = @ID
END
GO

-- Verificar se Beneficiário existe por CPF e Cliente
CREATE PROCEDURE FI_SP_VerificaBeneficiario
    @CPF       VARCHAR(11),
    @IDCLIENTE BIGINT
AS
BEGIN
    SELECT 1 FROM BENEFICIARIOS 
    WHERE CPF = @CPF AND IDCLIENTE = @IDCLIENTE
END
GO

-- Pesquisar Beneficiários com paginação
CREATE PROCEDURE FI_SP_PesqBeneficiario
    @iniciarEm       INT,
    @quantidade      INT,
    @campoOrdenacao  VARCHAR(50),
    @crescente       BIT
AS
BEGIN
    DECLARE @SQL NVARCHAR(MAX)
    SET @SQL = '
        SELECT ID, CPF, NOME, IDCLIENTE
        FROM BENEFICIARIOS
        ORDER BY ' + QUOTENAME(@campoOrdenacao) + CASE WHEN @crescente = 1 THEN ' ASC' ELSE ' DESC' END + '
        OFFSET ' + CAST(@iniciarEm AS VARCHAR) + ' ROWS
        FETCH NEXT ' + CAST(@quantidade AS VARCHAR) + ' ROWS ONLY;

        SELECT COUNT(*) FROM BENEFICIARIOS;
    '

    EXEC sp_executesql @SQL
END
GO

-- Excluir Beneficiário
CREATE PROCEDURE FI_SP_DelBeneficiario
    @ID BIGINT
AS
BEGIN
    DELETE FROM BENEFICIARIOS WHERE ID = @ID
END
GO

-- Listar Beneficiários por Cliente
CREATE PROCEDURE FI_SP_ListarBeneficiariosPorCliente
    @IDCLIENTE BIGINT
AS
BEGIN
    SELECT * FROM BENEFICIARIOS WHERE IDCLIENTE = @IDCLIENTE
END
GO

-- Alterar Beneficiário
CREATE PROCEDURE FI_SP_AltBeneficiario
    @NOME       VARCHAR(50),
    @CPF        VARCHAR(11),
    @IDCLIENTE  BIGINT,
    @ID         BIGINT
AS
BEGIN
    UPDATE BENEFICIARIOS
    SET
        NOME = @NOME,
        CPF = @CPF,
        IDCLIENTE = @IDCLIENTE
    WHERE ID = @ID
END
GO
