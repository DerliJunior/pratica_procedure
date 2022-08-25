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
SELECT DATENAME(WEEKDAY, CAST('2022-08-21' AS DATE));
SELECT DATEPART(WEEKDAY, CAST('2022-08-22' AS DATE));

SELECT * FROM DIA_SEMANA
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

INSERT INTO dbo.CONSULTA
             (FK_PACIENTE,FK_MEDICO_CONSULTA,DT_ENTRADA_CONSULTA,DT_SAIDA_CONSULTA,DESCRICAO)
      VALUES (1,1,'2022-09-10 09:30:00','2022-09-10 10:30:00','DESC 1')


SELECT * FROM dbo.PACIENTE;
SELECT * FROM dbo.CONSULTA;
SELECT * FROM dbo.MEDICO;
SELECT * FROM dbo.EXPEDIENTE;
SELECT * FROM dbo.ESPECIALIDADE;
SELECT * FROM dbo.DIA_SEMANA;

SELECT * FROM dbo.DIA_SEMANA WHERE ID_DIA_SEMANA = DATEPART(WEEKDAY, GETDATE());

SELECT * FROM dbo.CONSULTA ORDER BY DT_ENTRADA_CONSULTA


SELECT Teste = 'Teste'
WHERE CAST('2019-10-10' as DATETIME)
BETWEEN '20220911' AND '20221211'

declare @dattim as datetime;

select @dattim = dateadd(day,datediff(day,0,'2022-08-30'),'09:30:00') 

if(@dattim  > GETDATE())
  select ' a datatim é maior'
else 
  select 'datatim é menor'

  SELECT DATEPART(DA)
