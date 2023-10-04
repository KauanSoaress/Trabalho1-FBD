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

-- Crie um gatilho que atualize o id_comandante na tabela embarcacao quando um tripulante com a função "comando" for adicionado
CREATE OR REPLACE FUNCTION atualizar_id_comandante()
RETURNS TRIGGER AS $$
BEGIN
    -- Verifique se o tripulante recém-inserido possui a função "comando"
    IF NEW.funcao = 'comando' THEN
        -- Atualize o id_comandante na tabela embarcacao com o id_tripulante do tripulante recém-inserido
        UPDATE embarcacao
        SET id_comandante = NEW.id_tripulante
        WHERE id_embarcacao = NEW.id_embarcacao;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER atualizar_id_comandante_trigger
AFTER INSERT ON tripulante
FOR EACH ROW
EXECUTE FUNCTION atualizar_id_comandante();

CREATE TABLE embarcacao (
	id_embarcacao SERIAL PRIMARY KEY,
	id_empresa CHAR(50) NOT NULL, -- não conheço as especificações do ID de empresa
	id_comandante INTEGER NOT NULL,
	id_companhia CHAR(50), -- não conheço as especificações do ID de companhia
	num_IMO CHAR(11) UNIQUE NOT NULL, -- o número imo é descrito nas embarcações da seguinte maneira "IMO numero_de_sete_digitos"
	info_carga tipo_carga_enum,
	nome VARCHAR(255) NOT NULL,
	tipo tipo_embarcacao_enum NOT NULL,
	estado_embarcacao estado_embaRcacao_enum NOT NULL,
	bandeira VARCHAR(50) NOT NULL,
	localização VARCHAR(25) NOT NULL
)

CREATE TABLE empregado (
	id_empregado SERIAL PRIMARY KEY,
	nome VARCHAR(255) NOT NULL,
	nacionalidade VARCHAR(50) NOT NULL,
	telefone INTEGER UNIQUE NOT NULL,
	genero genero_enum NOT NULL,
	email VARCHAR(30) UNIQUE NOT NULL,
	data_nasc DATE NOT NULL,
	CPF CHAR(11) UNIQUE NOT NULL,
	funcao funcao_empregado_enum NOT NULL
)

CREATE TABLE tripulante (
	id_tripulante SERIAL PRIMARY KEY,
	nome VARCHAR(255) NOT NULL,
	nacionalidade VARCHAR(50) NOT NULL,
	genero genero_enum NOT NULL,
	idade INTEGER NOT NULL,
	CPF CHAR(11) UNIQUE NOT NULL,
	funcao funcao_tripulante_enum NOT NULL
	FOREIGN KEY (id_embarcacao) REFERENCES embarcacao (id_embarcacao)
	ON DELETE CASCADE
)

CREATE TABLE recursos_portuarios (
	id_recursos SERIAL PRIMARY KEY,
	nome VARCHAR(255) NOT NULL,
	tipo tipo_recursos_portuarios_enum NOT NULL,
	estado estado_recursos_enum NOT NULL,
	id_movimentacao INTEGER NOT NULL,
	FOREIGN KEY (id_movimentacao) REFERENCES movimentacao (id_movimentacao)
)

CREATE TABLE movimentacao (
	id_movimentacao SERIAL PRIMARY KEY,
	cod_equipe INTEGER NOT NULL,
	tipo tipo_movimentacao_enum NOT NULL,
	data_movimentacao DATE NOT NULL
)

CREATE TABLE alocado_movimentacao_empregado (
	id_movimentacao INTEGER,
	id_empregado INTEGER,
	PRIMARY KEY (id_movimentacao, id_empregado),
	FOREIGN KEY (id_movimentacao) REFERENCES movimentacao (id_movimentacao),
	FOREIGN KEY (id_empregado) REFERENCES empregado (id_empregado)
)

CREATE TABLE berco_de_atracacao (
	id_berco CHAR(2) PRIMARY KEY,
	estado_berco estado_berco_enum NOT NULL
)

CREATE TABLE bill_of_landing (
	id_bill SERIAL PRIMARY KEY,
	emb_liberada VARCHAR(50) NOT NULL,
	quando TIMESTAMP NOT NULL,
	berco_id CHAR(2) NOT NULL,
	FOREIGN KEY (berco_id) REFERENCES berco_de_atracacao(id_berco)
	ON DELETE CASCADE
)

