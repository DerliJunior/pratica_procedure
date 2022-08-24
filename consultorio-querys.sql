/*
USE MASTER
GO
DROP DATABASE consultorio;
GO

CREATE DATABASE consultorio;
GO
USE consultorio;
GO
*/


DROP TABLE IF EXISTS dbo.PACIENTE
 CREATE TABLE PACIENTE (
                         ID_PACIENTE INT IDENTITY PRIMARY KEY
                        ,NM_PACIENTE VARCHAR(60)                            NOT NULL
                        ,CD_CPF CHAR(11)                                    NOT NULL
                        ,DT_NASCIMENTO DATE                                 NOT NULL
                       );
GO

DROP TABLE IF EXISTS dbo.ESPECIALIDADE
  CREATE TABLE ESPECIALIDADE (
                               ID_ESPECIALIDADE INT IDENTITY PRIMARY KEY    NOT NULL
                              ,NM_ESPECIALIDADE VARCHAR(60)                 NOT NULL
                             );
GO

DROP TABLE IF EXISTS dbo.MEDICO
  CREATE TABLE MEDICO (
                        ID_MEDICO INT IDENTITY PRIMARY KEY
                       ,NM_MEDICO VARCHAR(60)                               NOT NULL
                       ,FK_ESPECIALIDADE INT                                NOT NULL
                       ,CRM VARCHAR(20)                                     NOT NULL
                       ,FOREIGN KEY (FK_ESPECIALIDADE) REFERENCES dbo.ESPECIALIDADE(ID_ESPECIALIDADE)
                      );
GO


DROP TABLE IF EXISTS dbo.DIA_SEMANA
  CREATE TABLE DIA_SEMANA (
                            ID_DIA_SEMANA SMALLINT IDENTITY PRIMARY KEY     NOT NULL
                           ,NM_DIA_SEMANA VARCHAR(20)                       NOT NULL
                          );
GO

DROP TABLE IF EXISTS dbo.EXPEDIENTE
  CREATE TABLE EXPEDIENTE (
                            ID_EXPEDIENTE INT IDENTITY PRIMARY KEY          NOT NULL
                           ,FK_MEDICO_EXPEDIENTE INT                        NOT NULL
                           ,FK_DIA_SEMANA SMALLINT                          NOT NULL
                           ,HR_INICIO_EXPEDIENTE TIME                       NOT NULL
                           ,HR_FIM_EXPEDIENTE TIME                          NOT NULL
                           ,FOREIGN KEY (FK_MEDICO_EXPEDIENTE) REFERENCES dbo.MEDICO(ID_MEDICO)
                           ,FOREIGN KEY (FK_DIA_SEMANA) REFERENCES dbo.DIA_SEMANA(ID_DIA_SEMANA)
                          );
GO


DROP TABLE IF EXISTS dbo.CONSULTA
  CREATE TABLE CONSULTA (
                          ID_CONSULTA INT IDENTITY PRIMARY KEY              NOT NULL
                         ,FK_PACIENTE INT                                   NOT NULL
                         ,FK_MEDICO_CONSULTA INT                            NOT NULL
                         ,DT_ENTRADA_CONSULTA DATETIME                      NOT NULL
                         ,DT_SAIDA_CONSULTA DATETIME                        NOT NULL
                         ,DESCRICAO VARCHAR(200)                                NULL
                         ,FOREIGN KEY (FK_PACIENTE) REFERENCES dbo.PACIENTE(ID_PACIENTE)
                         ,FOREIGN KEY (FK_MEDICO_CONSULTA) REFERENCES dbo.medico(ID_MEDICO)
                        );
GO

ALTER TABLE CONSULTA ADD DESCRICAO VARCHAR(200) NOT NULL;

-- Populando tabelas
SELECT DATENAME(WEEKDAY, GETDATE() +5);
SELECT DATEPART(WEEKDAY, GETDATE() +6);

SELECT GETDATE();
/*
-- INSERINDO DADOS NA TABELA DIA_SEMANA, SENDO DE 1 À 7, ONDE 1 É REFERENTE AO DOMINGO
--
INSERT INTO dbo.DIA_SEMANA
              (NM_DIA_SEMANA)
       VALUES ('Domingo')
             ,('Segunda-feira')
             ,('Ter�a-feira')
             ,('Quarta-feira')
             ,('Quinta-Feira')
             ,('Sexta-feira')
             ,('S�bado');

-- INSERINDO DADOS NA TABELA PACIENTE, COM INFORMAÇÕES BÁSICAS DE PESSOAS
--
INSERT INTO dbo.PACIENTE 
              (NM_PACIENTE, CD_CPF, DT_NASCIMENTO)
       VALUES ('NOME PACIENTE 1', '12345678911', '1998-05-01')
             ,('NOME PACIENTE 2', '12345678911', '1998-01-30')
             ,('NOME PACIENTE 3', '12345678911', '1990-05-14');


-- INSERINDO DADOS NA TABELA ESPECIALIDADE, DADOS REFERENTE A ESPECIALIDADE DO MÉDICO
--
INSERT INTO dbo.ESPECIALIDADE
              (NM_ESPECIALIDADE)
       VALUES ('CLINICO GERAL')
             ,('OFTAMOLOGISTA')
             ,('ENDOCRINOLOGISTA');

-- INSERINDO DADOS NA TABELA MEDICO, COM INFORMAÇÕES DO MÉDICO
--
INSERT INTO dbo.MEDICO
              (NM_MEDICO,FK_ESPECIALIDADE,CRM)
       VALUES ('NOME MEDICO 1',1,'CRM/SP 123456')
             ,('NOME MEDICO 2',2,'CRM/RJ 123456')
             ,('NOME MEDICO 3',3,'CRM/SP 123456');


-- INSERINDO DADOS NA TABELA EXPEDIENTE, COM HORÁRIO E FOREIGN KEY REFERENTE AO DIA DA SEMANA
--
INSERT INTO dbo.EXPEDIENTE
              (FK_MEDICO_EXPEDIENTE,FK_DIA_SEMANA,HR_INICIO_EXPEDIENTE,HR_FIM_EXPEDIENTE) 
       VALUES (1,2,'08:00','20:00')
             ,(1,3,'08:00','21:35')
             ,(1,6,'10:00','22:00')
             ,(2,6,'05:00','17:00')
             ,(2,1,'04:30','17:00')
             ,(3,5,'11:00','23:00')
             ,(3,7,'11:00','23:00');


-- INSERINDO DADOS NA TABELA DE CONSULTA
--
INSERT INTO dbo.CONSULTA
             (FK_PACIENTE,FK_MEDICO_CONSULTA,DT_ENTRADA_CONSULTA,DT_SAIDA_CONSULTA,DESCRICAO)
      VALUES (2,1,'2022-09-10 11:30:00','2022-09-10 12:30:00','DESC 1')
            ,(3,1,'2022-09-10 13:30:00','2022-09-10 14:00:00','DESC 2')
            ,(1,1,'2022-09-10 15:00:00','2022-09-10 16:30:00','DESC 3')
*/

SELECT * FROM dbo.PACIENTE;
SELECT * FROM dbo.CONSULTA;
SELECT * FROM dbo.MEDICO;
SELECT * FROM dbo.EXPEDIENTE;
SELECT * FROM dbo.ESPECIALIDADE;
SELECT * FROM dbo.DIA_SEMANA;

SELECT * FROM dbo.DIA_SEMANA WHERE ID_DIA_SEMANA = DATEPART(WEEKDAY, GETDATE());




SELECT *
FROM dbo.CONSULTA
ORDER BY FK_MEDICO_CONSULTA





;WITH CTE
AS (  SELECT 
    *,RowNumber = ROW_NUMBER() OVER( ORDER BY C.DT_ENTRADA_CONSULTA ASC )
      FROM dbo.MEDICO M WITH(NOLOCK)
           INNER JOIN dbo.CONSULTA C WITH(NOLOCK)
           ON M.ID_MEDICO     = C.FK_MEDICO_CONSULTA

      WHERE FK_MEDICO_CONSULTA = 1
   )
SELECT Free_Time_Slots = a.DT_SAIDA_CONSULTA, b.DT_ENTRADA_CONSULTA
                      FROM CTE a
                        INNER JOIN CTE b
                            ON a.RowNumber = b.RowNumber - 1
                      WHERE a.DT_ENTRADA_CONSULTA >= CAST('2022-08-01 09:30:00' AS datetime) AND b.DT_SAIDA_CONSULTA >= CAST('2022-08-01 10:30:00' as datetime)
                      -- datediff( minute, a.DT_SAIDA_CONSULTA, b.DT_ENTRADA_CONSULTA) >= 10

SELECT * FROM dbo.CONSULTA;



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

SELECT  CASE
         WHEN prev.DT_SAIDA_CONSULTA IS NULL THEN CTF.DT_PRIMEIRA_CONSULTA
         ELSE prev.DT_SAIDA_CONSULTA
        END AS DT_CONSULTA_ANTERIOR,
        CTF.DT_ENTRADA_CONSULTA,
        CTF.DT_SAIDA_CONSULTA,
        CASE
          WHEN NEX.DT_ENTRADA_CONSULTA IS NULL THEN CTF.DT_ULTIMA_CONSULTA
          ELSE NEX.DT_ENTRADA_CONSULTA
        END AS DT_PROXIMA_CONSULTA
FROM CTF
    LEFT JOIN CTF prev ON prev.rownum = CTF.rownum - 1
    LEFT JOIN CTF nex ON nex.rownum = CTF.rownum + 1
WHERE CTF.FK_MEDICO_CONSULTA = 1                                                                                          
GO

SELECT * FROM dbo.CONSULTA


SELECT Teste = 'Teste'
WHERE CAST('2019-10-10' as DATETIME)
BETWEEN '20220911' AND '20221211'