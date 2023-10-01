CREATE TYPE genero_enum AS ENUM ('masculino', 'feminino', 'outro');
CREATE TYPE funcao_tripulante_enum AS ENUM ('comando', 'navegacao', 'maquinas', 'operacao de carga e descarga', 'seguranca', 'comunicacao', 'atendimento medico', 'cozinha', 'limpeza', 'administracao', 'protecao ambiental', 'outro');
CREATE TYPE tipo_embarcacao_enum AS ENUM ('cargueiro', 'petroleiro', 'navio de passageiros');
CREATE TYPE estado_berco_enum AS ENUM ('ocupado', 'manutencao', 'livre');
CREATE TYPE tipo_recursos_portuarios_enum AS ENUM ('conteiner comum', 'conteiner tanque', 'conteiner teto aberto', 'conteiner frigorifico', 'conteiner para automoveis', 'conteiner flat rack', 'conteiner flexivel', 'empilhadeira', 'trator', 'caminhao', 'guindaste', 'instalacao de abastecimento', 'instalacao de reparo', 'instalacao de limpeza', 'outro');
CREATE TYPE estado_recursos_enum AS ENUM ('em uso', 'em manutencao', 'nao disponivel', 'livre');
CREATE TYPE funcao_empregado_enum AS ENUM ('diretor', 'seguranca', 'operador de guindaste', 'operador de carga', 'estivador', 'conferente de carga', 'controlador de trafego', 'pratico', 'oficial de alfandega', 'agente de atendimento', 'RH', 'manutencao', 'outros');
CREATE TYPE tipo_movimentacao_enum AS ENUM ('carga', 'descarga', 'manutencao', 'estocagem', 'abastecimento de combustivel', 'transferencia de carga', 'outro');

CREATE OR REPLACE FUNCTION adicionar_berco_id()
RETURNS TRIGGER AS $$
BEGIN
    -- Verifique se o estado do berço é "ocupado"
    IF NEW.estado_berco = 'ocupado'::estado_berco_enum THEN
        -- Insira uma nova B/L com o estado "emb_liberada" definido como TRUE e data/hora atual
        INSERT INTO bill_of_landing (emb_liberada, quando, berco_id)
        VALUES (TRUE, CURRENT_TIMESTAMP, NEW.id_berco);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER adicionar_berco_trigger
AFTER INSERT ON berco_de_atracacao
FOR EACH ROW
EXECUTE FUNCTION adicionar_berco_id();

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
	estado estado_recursos_enum,
	id_movimentacao INTEGER,
	FOREIGN KEY (id_movimentacao) REFERENCES movimentacao
)

CREATE TABLE empresa (
	id_empresa SERIAL PRIMARY KEY,
	nome CHAR(255),
	cnpj CHAR(14),
	endereco CHAR(100)
)

CREATE TABLE movimentacao (
	id_movimentacao SERIAL PRIMARY KEY,
	cod_equipe INTEGER,
	tipo tipo_movimentacao_enum,
	data_movimentacao DATE
)

CREATE TABLE alocado_movimentacao_empregado (
	id_movimentacao INTEGER,
	id_empregado INTEGER,
	PRIMARY KEY (id_movimentacao, id_empregado),
	FOREIGN KEY (id_movimentacao) REFERENCES movimentacao,
	FOREIGN KEY (id_empregado) REFERENCES empregado
)

CREATE TABLE berco_de_atracacao (
	id_berco SERIAL PRIMARY KEY,
	estado_berco estado_berco_enum
)

CREATE TABLE bill_of_landing (
	id_bill SERIAL PRIMARY KEY,
	emb_liberada BOOL,
	quando TIMESTAMP,
	berco_id INTEGER,
	FOREIGN KEY (berco_id) REFERENCES berco_de_atracacao(id_berco)
)

DELETE
FROM berco_de_atracacao B
WHERE id_berco < 5

SELECT * FROM bill_of_landing


