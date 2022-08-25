CREATE PROCEDURE dbo.st_AgendamentoConsulta @ID_MEDICO                 INT
                                           ,@FK_PACIENTE               INT
                                           ,@DT_ENTRADA_CONSULTA       DATETIME
                                           ,@DT_SAIDA_CONSULTA         DATETIME 
                                           ,@DESCRICAO                 VARCHAR = ''
                                           ,@ErrMsg                    VARCHAR = '' OUTPUT
                                           ,@Return_Code               INTEGER = 0  OUTPUT
AS 
BEGIN
  BEGIN TRY
    DECLARE @IsValid int;
    DECLARE @DATA_AGENDAMENTO AS DATETIME;

    SET @DATA_AGENDAMENTO = CAST(@DT_ENTRADA_CONSULTA AS date);
    -- VERIFICA SE OS PARAMETROS DE ENTRADA SÃO NULOS
    IF(@ID_MEDICO             IS NULL) SET @ErrMsg += @ErrMsg + CHAR(13) + 'ID_MEDICO';        
    IF(@FK_PACIENTE           IS NULL) SET @ErrMsg += @ErrMsg + CHAR(13) + 'FK_PACIENTE';   
    IF(@DT_ENTRADA_CONSULTA   IS NULL) SET @ErrMsg += @ErrMsg + CHAR(13) + 'DT_ENTRADA_CONSULTA';   
    IF(@DT_SAIDA_CONSULTA     IS NULL) SET @ErrMsg += @ErrMsg + CHAR(13) + 'DT_SAIDA_CONSULTA';

    IF(@ErrMsg  <> '')
    BEGIN
      SET @ErrMsg = 'ST_AgendamentoConsulta: ' + CHAR(13) + @ErrMsg + ' campo(s) nulos';
      RAISERROR(@ErrMsg,18,11)
    END

    --
    -- VERIFICA SE O HORARIO DO INICIO DA CONSULTA É POSTERIOR AO HORARIO DE SAIDA DA CONSULTA
    IF(@DT_ENTRADA_CONSULTA > @DT_SAIDA_CONSULTA)
    BEGIN
      SET @ErrMsg = 'ST_AgendamentoConsulta: ' + CHAR(13) + 'Horario de saída previsto não deve ser maior que o horário de entrada';
      RAISERROR(@ErrMsg,18,11)
    END
    

    SELECT  TOP 1 @IsValid = 1
    FROM dbo.MEDICO
            INNER JOIN dbo.EXPEDIENTE
            ON EXPEDIENTE.FK_MEDICO_EXPEDIENTE = MEDICO.ID_MEDICO
            INNER JOIN dbo.DIA_SEMANA
            ON DIA_SEMANA.ID_DIA_SEMANA = EXPEDIENTE.FK_DIA_SEMANA
    WHERE MEDICO.ID_MEDICO = @ID_MEDICO 
      AND DIA_SEMANA.ID_DIA_SEMANA = DATEPART(WEEKDAY, @DT_ENTRADA_CONSULTA)
      AND DIA_SEMANA.ID_DIA_SEMANA = DATEPART(WEEKDAY, @DT_SAIDA_CONSULTA  )

    IF(@IsValid               IS NULL) SET @ErrMsg = @ErrMsg + CHAR(13) + 'O médico não trabalha nesse dia da semana.'
    BEGIN
      SET @ErrMsg = 'ST_AgendamentoConsulta: ' + CHAR(13) + @ErrMsg;
      RAISERROR(@ErrMsg,18,11)
    END

    SET @DATA_AGENDAMENTO = CAST(@DT_ENTRADA_CONSULTA AS date);
    WITH CTF 
    AS (SELECT  
              rownum = ROW_NUMBER() OVER (ORDER BY C.DT_ENTRADA_CONSULTA ASC)
              ,*
              ,DATEADD(DAY,DATEDIFF(DAY,0,@DATA_AGENDAMENTO),E.HR_FIM_EXPEDIENTE)    AS DT_ULTIMA_CONSULTA 
              ,DATEADD(DAY,DATEDIFF(DAY,0,@DATA_AGENDAMENTO),E.HR_INICIO_EXPEDIENTE) AS DT_PRIMEIRA_CONSULTA 
        FROM dbo.CONSULTA C                 WITH(NOLOCK)
                INNER JOIN dbo.MEDICO M     WITH(NOLOCK)
                ON M.ID_MEDICO = C.FK_MEDICO_CONSULTA
                INNER JOIN dbo.EXPEDIENTE E WITH(NOLOCK)
                ON E.FK_MEDICO_EXPEDIENTE = M.ID_MEDICO
        WHERE M.ID_MEDICO = @ID_MEDICO
                AND

        )

    (SELECT  TOP 1
            @IsValid = 1
     FROM CTF
         LEFT JOIN CTF prev ON prev.rownum = CTF.rownum - 1
         LEFT JOIN CTF nex  ON nex.rownum  = CTF.rownum + 1
     WHERE (@DT_ENTRADA_CONSULTA BETWEEN CASE
                                           WHEN prev.DT_SAIDA_CONSULTA   IS NULL THEN CTF.DT_PRIMEIRA_CONSULTA     
                                           ELSE prev.DT_SAIDA_CONSULTA     
                                         END
                                           AND
                                         CTF.DT_ENTRADA_CONSULTA
               AND
           @DT_SAIDA_CONSULTA    BETWEEN CASE
                                           WHEN prev.DT_SAIDA_CONSULTA   IS NULL THEN CTF.DT_PRIMEIRA_CONSULTA     
                                           ELSE prev.DT_SAIDA_CONSULTA     
                                         END
                                           AND
                                         CTF.DT_ENTRADA_CONSULTA
               )                                   
               OR
           @DT_ENTRADA_CONSULTA  BETWEEN CTF.DT_SAIDA_CONSULTA
                                           AND
                                         CASE
                                           WHEN NEX.DT_ENTRADA_CONSULTA IS NULL THEN CTF.DT_ULTIMA_CONSULTA     
                                           ELSE NEX.DT_ENTRADA_CONSULTA  
                                         END  
                 AND

           @DT_SAIDA_CONSULTA   BETWEEN  CTF.DT_SAIDA_CONSULTA
                                           AND
                                         CASE
                                           WHEN NEX.DT_ENTRADA_CONSULTA IS NULL THEN CTF.DT_ULTIMA_CONSULTA     
                                           ELSE NEX.DT_ENTRADA_CONSULTA  
                                         END     
    );
    IF(@IsValid IS NULL) SET @ErrMsg = @ErrMsg + CHAR(13) + 'Horario'


    IF(@ErrMsg  <> '')
    BEGIN
      SET @ErrMsg = 'ST_AgendamentoConsulta: ' + CHAR(13) + @ErrMsg;
      RAISERROR(@ErrMsg,18,11)
    END

  END TRY
  BEGIN CATCH
    SELECT @Return_Code = CASE
                            WHEN @Return_Code = 0 THEN 1 ELSE @Return_Code
                          END
  END CATCH
  RETURN;
END


