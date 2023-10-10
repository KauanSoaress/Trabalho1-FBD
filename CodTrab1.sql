CREATE TYPE genero_enum AS ENUM ('masculino', 'feminino', 'outro');
CREATE TYPE funcao_tripulante_enum AS ENUM ('comando', 'navegacao', 'maquinas', 'operacao de carga e descarga', 'seguranca', 'comunicacao', 'atendimento medico', 'cozinha', 'limpeza', 'administracao', 'protecao ambiental', 'outro');
CREATE TYPE tipo_embarcacao_enum AS ENUM ('cargueiro', 'petroleiro', 'navio de passageiros');
CREATE TYPE estado_berco_enum AS ENUM ('ocupado', 'manutencao', 'livre');
CREATE TYPE tipo_recursos_portuarios_enum AS ENUM ('conteiner comum', 'conteiner tanque', 'conteiner teto aberto', 'conteiner frigorifico', 'conteiner para automoveis', 'conteiner flat rack', 'conteiner flexivel', 'empilhadeira', 'trator', 'caminhao', 'guindaste', 'instalacao de abastecimento', 'instalacao de reparo', 'instalacao de limpeza', 'outro');
CREATE TYPE estado_recursos_enum AS ENUM ('em uso', 'em manutencao', 'nao disponivel', 'livre');
CREATE TYPE funcao_empregado_enum AS ENUM ('diretor', 'seguranca', 'operador de guindaste', 'operador de carga', 'estivador', 'conferente de carga', 'controlador de trafego', 'pratico', 'oficial de alfandega', 'agente de atendimento', 'RH', 'manutencao', 'outros');
CREATE TYPE tipo_movimentacao_enum AS ENUM ('carga', 'descarga', 'manutencao', 'estocagem', 'abastecimento de combustivel', 'transferencia de carga', 'outro');
CREATE TYPE tipo_carga_enum AS ENUM ('propria','terceiros')
CREATE TYPE estado_embarcacao_enum AS ENUM ('atracado', 'ancorado', 'em trânsito', 'na fila de espera', 'sob carga', 'sob descarga', 'em quarentena', 'em reparo ou manutenção')

CREATE TABLE embarcacao (
	id_embarcacao SERIAL PRIMARY KEY,
	id_empresa CHAR(50) NOT NULL, -- por não conhecer as especificações de id_empresa, declararemos com o tipo CHAR 
	id_comandante INTEGER NOT NULL,
	id_companhia CHAR(50), -- por não conhecer as especificações de id_companhia, declararemos com o tipo CHAR
	num_IMO CHAR(11) UNIQUE NOT NULL, -- o número imo é descrito nas embarcações da seguinte maneira "IMO numero_de_sete_digitos"
	info_carga tipo_carga_enum,
	nome VARCHAR(255) NOT NULL,
	tipo tipo_embarcacao_enum NOT NULL,
	estado_embarcacao estado_embarcacao_enum NOT NULL,
	bandeira VARCHAR(50) NOT NULL,
	localização VARCHAR(25) NOT NULL
)

CREATE TABLE tamanho_embarcacao (
	id_tamanho SERIAL PRIMARY KEY,
	id_embarcacao SERIAL UNIQUE NOT NULL,
	largura REAL NOT NULL,
	comprimento REAL NOT NULL,
	calado REAL NOT NULL,
	tonelagem REAL NOT NULL,
	FOREIGN KEY (id_embarcacao) REFERENCES embarcacao (id_embarcacao)
	ON DELETE CASCADE
)

CREATE TABLE tripulante (
	id_tripulante SERIAL PRIMARY KEY,
	id_embarcacao INTEGER NOT NULL,
	nome VARCHAR(255) NOT NULL,
	nacionalidade VARCHAR(50) NOT NULL,
	genero genero_enum NOT NULL,
	idade INTEGER NOT NULL,
	CPF CHAR(11) UNIQUE NOT NULL,
	funcao funcao_tripulante_enum NOT NULL,
	FOREIGN KEY (id_embarcacao) REFERENCES embarcacao (id_embarcacao)
	ON DELETE CASCADE
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

CREATE TABLE tripulante_comanda_embarcacao (
	id_embarcacao INTEGER UNIQUE NOT NULL,
	id_tripulante INTEGER UNIQUE NOT NULL, -- aqui a aplicação ficará encarregada de verificar se o tripulante possui como função "comando"
	PRIMARY KEY (id_embarcacao, id_tripulante),
	FOREIGN KEY (id_embarcacao) REFERENCES embarcacao (id_embarcacao),
	FOREIGN KEY (id_tripulante) REFERENCES embarcacao (id_tripulante)
)

CREATE TABLE embarcacao_atraca_berco (
	id_embarcacao INTEGER UNIQUE NOT NULL,
	id_berco CHAR(2) UNIQUE NOT NULL,
	PRIMARY KEY (id_embarcacao, id_berco),
	FOREIGN KEY (id_embarcacao) REFERENCES embarcacao (id_embarcacao),
	FOREIGN KEY (id_berco) REFERENCES berco_de_atracacao (id_berco)
)

CREATE TABLE movimentacao_envolve_embarcacao (
	id_embarcacao INTEGER UNIQUE NOT NULL,
	id_movimentacao INTEGER UNIQUE NOT NULL,
	PRIMARY KEY (id_embarcacao, id_movimentacao),
	FOREIGN KEY (id_embarcacao) REFERENCES embarcacao (id_embarcacao),
	FOREIGN KEY (id_movimentacao) REFERENCES movimentacao (id_movimentacao)
)

CREATE TABLE empregado_alocado_movimentacao (
	id_movimentacao INTEGER,
	id_empregado INTEGER,
	PRIMARY KEY (id_movimentacao, id_empregado),
	FOREIGN KEY (id_movimentacao) REFERENCES movimentacao (id_movimentacao),
	FOREIGN KEY (id_empregado) REFERENCES empregado (id_empregado)
)


