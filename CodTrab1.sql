CREATE TYPE genero_enum AS ENUM ('masculino', 'feminino', 'outro');
CREATE TYPE funcao_tripulante_enum AS ENUM ('comando', 'navegacao', 'maquinas', 'operacao de carga e descarga', 'seguranca', 'comunicacao', 'atendimento medico', 'cozinha', 'limpeza', 'administracao', 'protecao ambiental', 'outro');
CREATE TYPE tipo_embarcacao_enum AS ENUM ('cargueiro', 'petroleiro', 'navio de passageiros');
CREATE TYPE estado_berco_enum AS ENUM ('ocupado', 'manutencao', 'livre');
CREATE TYPE tipo_recursos_portuarios_enum AS ENUM ('conteiner comum', 'conteiner tanque', 'conteiner teto aberto', 'conteiner frigorifico', 'conteiner para automoveis', 'conteiner flat rack', 'conteiner flexivel', 'empilhadeira', 'trator', 'caminhao', 'guindaste', 'instalacao de abastecimento', 'instalacao de reparo', 'instalacao de limpeza', 'outro');
CREATE TYPE estado_recursos_enum AS ENUM ('em uso', 'em manutencao', 'nao disponivel', 'livre');
CREATE TYPE funcao_empregado_enum AS ENUM ('diretor', 'seguranca', 'operador de guindaste', 'operador de carga', 'estivador', 'conferente de carga', 'controlador de trafego', 'pratico', 'oficial de alfandega', 'agente de atendimento', 'RH', 'manutencao', 'outros');
CREATE TYPE tipo_movimentacao_enum AS ENUM ('carga', 'descarga', 'manutencao', 'estocagem', 'abastecimento de combustivel', 'transferencia de carga', 'outro');

CREATE TABLE empregado (
	id_empregado SERIAL PRIMARY KEY,
	nome CHAR(255),
	nacionalidade CHAR(50),
	telefone INTEGER,
	genero genero_enum,
	email CHAR(100),
	data_nasc DATE,
	CPF CHAR(11),
	funcao funcao_empregado_enum
)

CREATE TABLE tripulante (
	id_tripulante SERIAL PRIMARY KEY,
	nome CHAR(255),
	nacionalidade CHAR(50),
	genero genero_enum,
	idade INTEGER,
	CPF CHAR(11),
	funcao funcao_tripulante_enum
)

CREATE TABLE recursos_portuarios (
	id_recursos SERIAL PRIMARY KEY,
	nome CHAR(255),
	tipo tipo_recursos_portuarios_enum,
	estado estado_recursos_enum
)

CREATE TABLE empresa (
	id_empresa SERIAL PRIMARY KEY,
	nome CHAR(255),
	cnpj CHAR(14),
	endereco CHAR(100)
)