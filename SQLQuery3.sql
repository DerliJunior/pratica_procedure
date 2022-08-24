CREATE OR ALTER PROCEDURE st_teste
AS
BEGIN
DECLARE @IsValid char(1);
WITH CTF 
AS (SELECT  
          rownum = ROW_NUMBER() OVER (ORDER BY C.ID_CONSULTA ASC)
          ,*
          ,'2022-09-10 19:30:00.000' AS DT_ULTIMA_CONSULTA -- ALTERAR PARA A VARIAVEL COM O DIA VÁLIDO
          ,'2022-09-10 09:00:00.000' AS DT_PRIMEIRA_CONSULTA 
    FROM dbo.CONSULTA C            WITH(NOLOCK)
           INNER JOIN dbo.MEDICO M WITH(NOLOCK)
           ON M.ID_MEDICO = C.FK_MEDICO_CONSULTA
    WHERE m.ID_MEDICO = 1
   )

(SELECT  TOP 1
        @IsValid = 1
  FROM CTF
      LEFT JOIN CTF prev ON prev.rownum = CTF.rownum - 1
      LEFT JOIN CTF nex ON nex.rownum = CTF.rownum + 1
  WHERE (CAST('2022-09-10 12:31:00.000' AS datetime) BETWEEN CASE
                                                              WHEN prev.DT_SAIDA_CONSULTA   IS NULL THEN CTF.DT_PRIMEIRA_CONSULTA     
                                                              ELSE prev.DT_SAIDA_CONSULTA     
                                                            END
                                                              AND
                                                            CTF.DT_ENTRADA_CONSULTA
            AND
          CAST('2022-09-10 12:40:00.000' AS datetime) BETWEEN CASE
                                                              WHEN prev.DT_SAIDA_CONSULTA   IS NULL THEN CTF.DT_PRIMEIRA_CONSULTA     
                                                              ELSE prev.DT_SAIDA_CONSULTA     
                                                            END
                                                              AND
                                                            CTF.DT_ENTRADA_CONSULTA
        )                                   
            OR
        (CAST('2022-09-10 11:40:00.000' AS datetime) BETWEEN  CTF.DT_SAIDA_CONSULTA
                                                                AND
                                                              CASE
                                                                WHEN NEX.DT_ENTRADA_CONSULTA IS NULL THEN CTF.DT_ULTIMA_CONSULTA     
                                                                ELSE NEX.DT_ENTRADA_CONSULTA  
                                                              END  
              AND

          CAST('2022-09-10 12:31:00.000' AS datetime) BETWEEN  CTF.DT_SAIDA_CONSULTA
                                                                AND
                                                              CASE
                                                                WHEN NEX.DT_ENTRADA_CONSULTA IS NULL THEN CTF.DT_ULTIMA_CONSULTA     
                                                                ELSE NEX.DT_ENTRADA_CONSULTA  
                                                              END     
        )
);
    SELECT @IsValid
END

EXEC st_teste;

SELECT * FROM dbo.CONSULTA
  
;with   Hours(N) as
        (
        select  11 as ARROZ
        union all
        select  N + 1
        from    Hours
        where   N < 14
        )
select  *
from    Hours