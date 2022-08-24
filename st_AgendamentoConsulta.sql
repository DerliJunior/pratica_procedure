CREATE PROCEDURE dbo.st_AgendamentoConsulta @ID_MEDICO                 INT
                                           ,@FK_PACIENTE               INT
                                           ,@DT_ENTRADA_CONSULTA       DATETIME = 
                                           ,@DT_SAIDA_CONSULTA         DATETIME 
                                           ,@DESCRICAO                 VARCHAR = ''
                                           ,@ErrorMsg                  VARCHAR = '' OUTPUT
                                           ,@Return_Code               INTEGER = 0  OUTPUT
AS 
BEGIN
  BEGIN TRY
    IF(@ID_MEDICO             IS NULL) SET @ErrorMsg = @ErrorMsg + CHAR(13) + 'ID_MEDICO';        
    IF(@FK_PACIENTE           IS NULL) SET @ErrorMsg = @ErrorMsg + CHAR(13) + 'FK_PACIENTE';   
    IF(@DT_ENTRADA_CONSULTA   IS NULL) SET @ErrorMsg = @ErrorMsg + CHAR(13) + 'DT_ENTRADA_CONSULTA';   
    IF(@DT_SAIDA_CONSULTA     IS NULL) SET @ErrorMsg = @ErrorMsg + CHAR(13) + 'DT_SAIDA_CONSULTA';

    DECLARE @isValido INT;

    IF(SELECT @isValido = )
    IF( @ErrorMsg  <> '')
    BEGIN
      SET @ErrorMsg = 'ST_AgendamentoConsulta' + CHAR(13) + @ErrorMsg;
      RAISERROR(@ErrorMsg,18,11)
    END

  END TRY
  BEGIN CATCH
    SELECT @Return_Code = CASE
                            WHEN @Return_Code = 0 THEN 1 ELSE @Return_Code
                          END
  END CATCH
  RETURN;
END