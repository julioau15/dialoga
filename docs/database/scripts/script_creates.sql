DROP DATABASE IF EXISTS db_dialoga;
CREATE DATABASE IF NOT EXISTS db_dialoga;
USE db_dialoga;

-- CREATES --
# ------- USUARIO --------
-- cria tbl_usuario
CREATE TABLE tbl_usuario (
	id INT NOT NULL AUTO_INCREMENT UNIQUE,
    email VARCHAR(150) NOT NULL,
    senha_hash VARCHAR(255),
    nivel TINYINT NOT NULL,
    data_criacao DATETIME NOT NULL
);


# ------- ADMINISTRADOR --------
-- cria tbl_administrador
CREATE TABLE tbl_administrador (
	id INT NOT NULL AUTO_INCREMENT UNIQUE,
    nome_completo VARCHAR(150) NOT NULL,
    senha_provisoria TINYINT,
    celular VARCHAR(20),
    foto_avatar TEXT,
    id_usuario  INT NOT NULL,
    
    CONSTRAINT FK_USUARIO_ADMINISTRADOR
    FOREIGN KEY (id_usuario)
    REFERENCES tbl_usuario (id)
    ON DELETE CASCADE
);

# ------- PROFISSIONAL ---------
-- cria tbl_profissional
CREATE TABLE tbl_profissional (
	id INT NOT NULL AUTO_INCREMENT UNIQUE,
    nome_completo VARCHAR(150) NOT NULL,
    cpf VARCHAR(11) NOT NULL,
    crp VARCHAR(20) NOT NULL,
    celular VARCHAR(20),
    instituicao_clinica VARCHAR(150),
    foto_avatar TEXT,
    id_usuario  INT NOT NULL,
    
    CONSTRAINT FK_USUARIO_PROFISSIONAL
    FOREIGN KEY (id_usuario)
    REFERENCES tbl_usuario (id)
    ON DELETE CASCADE
);

-- cria tbl_especialidade
CREATE TABLE tbl_especialidade (
	id INT NOT NULL AUTO_INCREMENT UNIQUE,
	especialidade VARCHAR(100) NOT NULL
);

-- cria tbl_profissional_especialidade
CREATE TABLE tbl_profissional_especialidade (
	id INT NOT NULL AUTO_INCREMENT UNIQUE,
	id_profissional INT NOT NULL,
    id_especialidade INT NOT NULL,

    CONSTRAINT FK_PROFISSIONAL_PROFISSIONALESPECIALIDADE
    FOREIGN KEY (id_profissional)
    REFERENCES tbl_profissional (id)
    ON DELETE CASCADE,

    CONSTRAINT FK_ESPECIALIDADE_PROFISSIONALESPECIALIDADE
    FOREIGN KEY (id_especialidade)
    REFERENCES tbl_especialidade (id)
    ON DELETE CASCADE
);

-- cria tbl_administrador_profissional
CREATE TABLE tbl_administrador_profissional (
	id INT NOT NULL AUTO_INCREMENT UNIQUE,
    status_aprovacao VARCHAR(20) NOT NULL,
    data_decisao DATETIME,
    criado_em DATETIME NOT NULL,
	id_profissional INT NOT NULL,
    id_administrador INT,

    CONSTRAINT FK_PROFISSIONAL_ADMINISTRADORPROFISSIONAL
    FOREIGN KEY (id_profissional)
    REFERENCES tbl_profissional (id)
    ON DELETE CASCADE,

    CONSTRAINT FK_ADMINISTRADOR_ADMINISTRADORPROFISSIONAL
    FOREIGN KEY (id_administrador)
    REFERENCES tbl_administrador (id)
    ON DELETE SET NULL
);

# ------- PACIENTE --------
-- cria tbl_paciente
CREATE TABLE tbl_paciente (
	id INT NOT NULL AUTO_INCREMENT UNIQUE,
    nome_completo VARCHAR(150) NOT NULL,
    apelido VARCHAR(80),
    data_nascimento DATE,
    celular VARCHAR(20),
    foto_avatar VARCHAR(255),
    primeiro_acesso_concluido TINYINT NOT NULL,
    status_atividade VARCHAR(20) NOT NULL,
    id_usuario  INT NOT NULL,
    
    CONSTRAINT FK_USUARIO_PACIENTE
    FOREIGN KEY (id_usuario)
    REFERENCES tbl_usuario (id)
    ON DELETE CASCADE
);

# ------- VÍNCULO PACIENTE-PROFISSIONAL --------
-- cria tbl_vinculo
CREATE TABLE tbl_vinculo (
	id INT NOT NULL AUTO_INCREMENT UNIQUE,
    status VARCHAR(20) NOT NULL,
    origem_cadastro VARCHAR(20) NOT NULL,
    data_solicitacao DATETIME,
    data_aceite DATETIME,
    data_inicio_acompanhamento DATETIME,
    data_fim DATETIME,
    id_profissional INT NOT NULL,
    id_paciente INT NOT NULL,

    CONSTRAINT FK_PROFISSIONAL_VINCULO
    FOREIGN KEY (id_profissional)
    REFERENCES tbl_profissional (id)
    ON DELETE NO ACTION,

    CONSTRAINT FK_PACIENTE_VINCULO
    FOREIGN KEY (id_paciente)
    REFERENCES tbl_paciente (id)
    ON DELETE NO ACTION
);

# ------- AGENDA: CONSULTA E DISPONIBILIDADE --------
-- cria tbl_consulta
CREATE TABLE tbl_consulta (
	id INT NOT NULL AUTO_INCREMENT UNIQUE,
    criado_por VARCHAR(20) NOT NULL,
    nome_da_conculta VARCHAR(150) NOT NULL,
    especialidade VARCHAR(100),
    data DATE NOT NULL,
    hora TIME NOT NULL,
    status VARCHAR(20) NOT NULL,
    id_vinculo INT NOT NULL,

    CONSTRAINT FK_VINCULO_CONSULTA
    FOREIGN KEY (id_vinculo)
    REFERENCES tbl_vinculo (id)
    ON DELETE NO ACTION
);

-- cria tbl_disponibilidade
CREATE TABLE tbl_disponibilidade (
	id INT NOT NULL AUTO_INCREMENT UNIQUE,
    dias_da_semana VARCHAR(50) NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fim TIME NOT NULL,
    tipo_repeticao VARCHAR(20) NOT NULL,
    data_inicial DATE,
    data_final DATE,
    id_profissional INT NOT NULL,

    CONSTRAINT FK_PROFISSIONAL_DISPONIBILIDADE
    FOREIGN KEY (id_profissional)
    REFERENCES tbl_profissional (id)
    ON DELETE NO ACTION
);

# ------- ANOTAÇÃO --------
-- cria tbl_anotacao
CREATE TABLE tbl_anotacao (
	id INT NOT NULL AUTO_INCREMENT UNIQUE,
    titulo VARCHAR(200) NOT NULL,
    conteudo VARCHAR(1000) NOT NULL,
    data_criacao DATETIME NOT NULL,
    data_edicao DATETIME,
    id_profissional INT NOT NULL,
    id_paciente INT NOT NULL,

    CONSTRAINT FK_PROFISSIONAL_ANOTACAO
    FOREIGN KEY (id_profissional)
    REFERENCES tbl_profissional (id)
    ON DELETE NO ACTION,

    CONSTRAINT FK_PACIENTE_ANOTACAO
    FOREIGN KEY (id_paciente)
    REFERENCES tbl_paciente (id)
    ON DELETE NO ACTION
);

# ------- SOLICITAÇÃO DE ACESSO A INDICADORES --------
-- cria tbl_solicitacao_acesso
CREATE TABLE tbl_solicitacao_acesso (
	id INT NOT NULL AUTO_INCREMENT UNIQUE,
    status VARCHAR(20) NOT NULL,
    data_solicitacao DATETIME NOT NULL,
    data_resposta DATETIME,
    id_profissional INT NOT NULL,
    id_paciente INT NOT NULL,

    CONSTRAINT FK_PROFISSIONAL_SOLICITACAOACESSO
    FOREIGN KEY (id_profissional)
    REFERENCES tbl_profissional (id)
    ON DELETE NO ACTION,

    CONSTRAINT FK_PACIENTE_SOLICITACAOACESSO
    FOREIGN KEY (id_paciente)
    REFERENCES tbl_paciente (id)
    ON DELETE NO ACTION
);

-- cria tbl_categoria_compartilhada
CREATE TABLE tbl_categoria_compartilhada (
	id INT NOT NULL AUTO_INCREMENT UNIQUE,
    categoria VARCHAR(30) NOT NULL,
    autorizado TINYINT NOT NULL,
    id_solicitacao_acesso INT NOT NULL,

    CONSTRAINT FK_SOLICITACAOACESSO_CATEGORIACOMPARTILHADA
    FOREIGN KEY (id_solicitacao_acesso)
    REFERENCES tbl_solicitacao_acesso (id)
    ON DELETE CASCADE
);

# ------- NOTIFICAÇÃO --------
-- cria tbl_categoria
CREATE TABLE tbl_categoria (
	id INT NOT NULL AUTO_INCREMENT UNIQUE,
    categoria VARCHAR(20) NOT NULL,
    tipo_especifico VARCHAR(50)
);

-- cria tbl_notificacao
CREATE TABLE tbl_notificacao (
	id INT NOT NULL AUTO_INCREMENT UNIQUE,
    titulo_mensagem VARCHAR(255) NOT NULL,
    lida TINYINT NOT NULL,
    data_criacao DATETIME NOT NULL,
    referencia_evento VARCHAR(255),
    id_categoria INT NOT NULL,
    id_profissional INT,
    id_paciente INT,

    CONSTRAINT FK_CATEGORIA_NOTIFICACAO
    FOREIGN KEY (id_categoria)
    REFERENCES tbl_categoria (id)
    ON DELETE NO ACTION,

    CONSTRAINT FK_PROFISSIONAL_NOTIFICACAO
    FOREIGN KEY (id_profissional)
    REFERENCES tbl_profissional (id)
    ON DELETE CASCADE,

    CONSTRAINT FK_PACIENTE_NOTIFICACAO
    FOREIGN KEY (id_paciente)
    REFERENCES tbl_paciente (id)
    ON DELETE CASCADE
);

-- cria tbl_preferencia_notificacao
CREATE TABLE tbl_preferencia_notificacao (
	id INT NOT NULL AUTO_INCREMENT UNIQUE,
    categoria VARCHAR(30) NOT NULL,
    tipo_especifico VARCHAR(50),
    ativo TINYINT NOT NULL,
    id_profissional INT,
    id_paciente INT,

    CONSTRAINT FK_PROFISSIONAL_PREFERENCIANOTIFICACAO
    FOREIGN KEY (id_profissional)
    REFERENCES tbl_profissional (id)
    ON DELETE CASCADE,

    CONSTRAINT FK_PACIENTE_PREFERENCIANOTIFICACAO
    FOREIGN KEY (id_paciente)
    REFERENCES tbl_paciente (id)
    ON DELETE CASCADE
);

# ------- TAREFA (FORMULÁRIOS / QUESTIONÁRIOS) --------
-- cria tbl_tarefa
CREATE TABLE tbl_tarefa (
	id INT NOT NULL AUTO_INCREMENT UNIQUE,
    titulo VARCHAR(200) NOT NULL,
    tipo VARCHAR(20) NOT NULL,
    instrucoes TEXT,
    anexo_arquivo VARCHAR(255),
    is_rascunho TINYINT NOT NULL,
    data_criacao DATETIME NOT NULL,
    data_envio DATETIME,
    id_profissional_criador INT,
    id_paciente_criador INT,

    CONSTRAINT FK_PROFISSIONAL_TAREFA
    FOREIGN KEY (id_profissional_criador)
    REFERENCES tbl_profissional (id)
    ON DELETE CASCADE,

    CONSTRAINT FK_PACIENTE_TAREFA
    FOREIGN KEY (id_paciente_criador)
    REFERENCES tbl_paciente (id)
    ON DELETE CASCADE
);

-- cria tbl_pergunta
CREATE TABLE tbl_pergunta (
	id INT NOT NULL AUTO_INCREMENT UNIQUE,
    tipo VARCHAR(30) NOT NULL,
    texto TEXT NOT NULL,
    imagem VARCHAR(255),
    obrigatoria TINYINT NOT NULL,
    ordem INT NOT NULL,
    id_tarefa INT NOT NULL,

    CONSTRAINT FK_TAREFA_PERGUNTA
    FOREIGN KEY (id_tarefa)
    REFERENCES tbl_tarefa (id)
    ON DELETE CASCADE
);

-- cria tbl_opcao_pergunta
CREATE TABLE tbl_opcao_pergunta (
	id INT NOT NULL AUTO_INCREMENT UNIQUE,
    texto VARCHAR(200) NOT NULL,
    ordem INT NOT NULL,
    id_pergunta INT NOT NULL,

    CONSTRAINT FK_PERGUNTA_OPCAOPERGUNTA
    FOREIGN KEY (id_pergunta)
    REFERENCES tbl_pergunta (id)
    ON DELETE CASCADE
);

-- cria tbl_tarefa_destinatario
CREATE TABLE tbl_tarefa_destinatario (
	id INT NOT NULL AUTO_INCREMENT UNIQUE,
    prazo DATETIME,
    status VARCHAR(20) NOT NULL,
    data_conclusao DATETIME,
    id_tarefa INT NOT NULL,
    id_paciente INT NOT NULL,

    CONSTRAINT FK_TAREFA_TAREFADESTINATARIO
    FOREIGN KEY (id_tarefa)
    REFERENCES tbl_tarefa (id)
    ON DELETE CASCADE,

    CONSTRAINT FK_PACIENTE_TAREFADESTINATARIO
    FOREIGN KEY (id_paciente)
    REFERENCES tbl_paciente (id)
    ON DELETE CASCADE
);

-- cria tbl_resposta
CREATE TABLE tbl_resposta (
	id INT NOT NULL AUTO_INCREMENT UNIQUE,
    valor TEXT,
    data_envio DATETIME NOT NULL,
    id_pergunta INT NOT NULL,
    id_opcao_pergunta INT,
    id_tarefa_destinatario INT NOT NULL,

    CONSTRAINT FK_PERGUNTA_RESPOSTA
    FOREIGN KEY (id_pergunta)
    REFERENCES tbl_pergunta (id)
    ON DELETE CASCADE,

    CONSTRAINT FK_OPCAOPERGUNTA_RESPOSTA
    FOREIGN KEY (id_opcao_pergunta)
    REFERENCES tbl_opcao_pergunta (id)
    ON DELETE CASCADE,

    CONSTRAINT FK_TAREFADESTINATARIO_RESPOSTA
    FOREIGN KEY (id_tarefa_destinatario)
    REFERENCES tbl_tarefa_destinatario (id)
    ON DELETE CASCADE
);

# ------- REGISTRO DE HUMOR --------
-- cria tbl_registro_humor
CREATE TABLE tbl_registro_humor (
	id INT NOT NULL AUTO_INCREMENT UNIQUE,
    data DATE NOT NULL,
    sentimento VARCHAR(30) NOT NULL,
    energia VARCHAR(20) NOT NULL,
    humor VARCHAR(20) NOT NULL,
    padrao_pensamentos VARCHAR(500) NOT NULL,
    horas_sono DECIMAL(4,2) NOT NULL,
    relato TEXT,
    data_criacao DATETIME NOT NULL,
    id_paciente INT NOT NULL,

    CONSTRAINT FK_PACIENTE_REGISTROHUMOR
    FOREIGN KEY (id_paciente)
    REFERENCES tbl_paciente (id)
    ON DELETE NO ACTION
);

# ------- TRATAMENTO / MEDICAÇÃO --------
-- cria tbl_tratamento
CREATE TABLE tbl_tratamento (
	id INT NOT NULL AUTO_INCREMENT UNIQUE,
    nome_medicamento VARCHAR(150) NOT NULL,
    dosagem VARCHAR(150) NOT NULL,
    frequencia VARCHAR(100),
    lembrete_ativo TINYINT,
    id_paciente INT NOT NULL,

    CONSTRAINT FK_PACIENTE_TRATAMENTO
    FOREIGN KEY (id_paciente)
    REFERENCES tbl_paciente (id)
    ON DELETE NO ACTION
);

-- cria tbl_horario_tratamento
CREATE TABLE tbl_horario_tratamento (
	id INT NOT NULL AUTO_INCREMENT UNIQUE,
    horario TIME NOT NULL,
    id_tratamento INT NOT NULL,

    CONSTRAINT FK_TRATAMENTO_HORARIOTRATAMENTO
    FOREIGN KEY (id_tratamento)
    REFERENCES tbl_tratamento (id)
    ON DELETE CASCADE
);

-- cria tbl_registro_dose
CREATE TABLE tbl_registro_dose (
	id INT NOT NULL AUTO_INCREMENT UNIQUE,
    data_hora_prevista DATETIME NOT NULL,
    status VARCHAR(25) NOT NULL,
    data_hora_confirmacao DATETIME,
    id_horario_tratamento INT NOT NULL,

    CONSTRAINT FK_HORARIOTRATAMENTO_REGISTRODOSE
    FOREIGN KEY (id_horario_tratamento)
    REFERENCES tbl_horario_tratamento (id)
    ON DELETE CASCADE
);