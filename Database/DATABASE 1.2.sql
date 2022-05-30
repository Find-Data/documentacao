###################  BASE DE DADOS DO PROJETO FIND DATA  #################
####  ULTIMA MODIFICAÇÃO FEITA EM 06/04/2022 AS 15:40 POR MAXIMILES  #####
##########################################################################

USE find_data;

CREATE TABLE empresas 
(
	emp_id INT AUTO_INCREMENT,
    emp_nome VARCHAR(80),
    emp_cnpj VARCHAR(20),
	cid_id VARCHAR(20),
    cnae_id VARCHAR(20),
    emp_origem VARCHAR(40),
    PRIMARY KEY(emp_id)
 );

CREATE TABLE consumo
(
	cons_id LONG,
    cons_mes VARCHAR(40),
    cons_qtdconsumo LONG,
    emp_id LONG
);

CREATE TABLE cidade 
(
	cid_id LONG,
    cid_cidade VARCHAR(80),
    cid_estado CHAR(3),
    cid_regiaoibge VARCHAR(30)
);

CREATE TABLE cnae
(
	cnae_id LONG,
    cnae_codigo VARCHAR(10),
    cnae_descricao VARCHAR(255)
);

CREATE TABLE usuarios
(
	usu_id LONG,
    usu_nome VARCHAR(80),
    usu_email VARCHAR(80),
    usu_senha VARCHAR(255),
    usu_nivel VARCHAR(40)
);

############# FIM DA CRIAÇÃO DE TABELAS ################

SELECT * FROM empresas;
