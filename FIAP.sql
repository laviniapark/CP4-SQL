CREATE TABLE t_classes (
    classe_id INTEGER GENERATED BY DEFAULT AS IDENTITY,
    descricao VARCHAR(50) NOT NULL,
    CONSTRAINT t_classes_pk PRIMARY KEY (classe_id)
);

CREATE TABLE t_modelos (
    modelo_id INTEGER GENERATED BY DEFAULT AS IDENTITY,
    marca VARCHAR(30) NOT NULL,
    ano_fabricacao INTEGER NOT NULL,
    descricao VARCHAR(50) NOT NULL,
    litros_maximo_tanque SMALLINT NOT NULL,
    classe_id INTEGER NOT NULL,
    CONSTRAINT t_modelos_pk PRIMARY KEY (modelo_id),
    CONSTRAINT t_modelos_ck_ano_fabricacao CHECK (ano_fabricacao > 2015),
    CONSTRAINT t_modelos_ck_litros CHECK (litros_maximo_tanque > 9 AND
        litros_maximo_tanque < 100),
    CONSTRAINT t_modelos_fk_classe FOREIGN KEY (classe_id)
        REFERENCES t_classes(classe_id)
);

CREATE TABLE t_veiculos (
    veiculo_id INTEGER GENERATED BY DEFAULT AS IDENTITY,
    placa_veiculo CHAR(7) NOT NULL,
    data_cadastro TIMESTAMP DEFAULT current_timestamp NOT NULL,
    cadastrado_por VARCHAR(50) NOT NULL,
    data_alteracao DATE,
    alterado_por VARCHAR(50),
    data_exclusao DATE,
    excluido_por VARCHAR(50),
    quilometragem_aquisicao INTEGER NOT NULL,
    chave_nota_fiscal VARCHAR(40) NOT NULL,
    data_aquisicao DATE NOT NULL,
    cor VARCHAR(20) NOT NULL,
    modelo_id INTEGER NOT NULL,
    fornecedor_id INTEGER NOT NULL,
    CONSTRAINT t_veiculos_pk PRIMARY KEY (veiculo_id),
    CONSTRAINT t_veiculos_fk_modelo FOREIGN KEY (modelo_id)
        REFERENCES t_modelos(modelo_id),
    CONSTRAINT t_veiculos_fk_fornecedor FOREIGN KEY (fornecedor_id)
        REFERENCES t_fornecedores(fornecedor_id)
);

CREATE TABLE t_movimentacoes (
    movimentacao_id INTEGER GENERATED BY DEFAULT AS IDENTITY,
    datahora_saida TIMESTAMP DEFAULT current_timestamp NOT NULL,
    destino VARCHAR(100) NOT NULL,
    datahora_retorno DATE NOT NULL,
    quilometragem_retorno INTEGER NOT NULL,
    data_cadastro TIMESTAMP DEFAULT current_timestamp NOT NULL,
    cadastrado_por VARCHAR(50) NOT NULL,
    data_alteracao DATE,
    alterado_por VARCHAR(50),
    data_exclusao DATE,
    excluido_por VARCHAR(50),
    motorista_id INTEGER NOT NULL,
    veiculo_id INTEGER NOT NULL,
    CONSTRAINT t_movimentacao_pk PRIMARY KEY (movimentacao_id),
    CONSTRAINT t_movimentacao_fk_motorista FOREIGN KEY (motorista_id)
        REFERENCES t_motoristas(motorista_id),
    CONSTRAINT t_movimentacao_fk_veiculo FOREIGN KEY (veiculo_id)
        REFERENCES t_veiculos(veiculo_id)
);

CREATE TABLE t_motoristas (
    motorista_id INTEGER GENERATED BY DEFAULT AS IDENTITY,
    nome VARCHAR(50) NOT NULL,
    situacao VARCHAR(8) NOT NULL,
    apelido VARCHAR(15) NOT NULL,
    CONSTRAINT t_motoristas_pk PRIMARY KEY (motorista_id),
    CONSTRAINT t_motoristas_un UNIQUE (apelido)
);

CREATE TABLE t_motorista_telefones (
    numero INTEGER NOT NULL,
    prefixo INTEGER NOT NULL,
    motorista_id INTEGER NOT NULL,
    CONSTRAINT t_motorista_telefones_fk_motorista FOREIGN KEY (motorista_id)
        REFERENCES t_motoristas(motorista_id)
);

CREATE TABLE t_fornecedores (
    fornecedor_id INTEGER GENERATED BY DEFAULT AS IDENTITY,
    nome VARCHAR(50) NOT NULL,
    cep CHAR(8) NOT NULL,
    rua VARCHAR(40) NOT NULL,
    numero SMALLINT NOT NULL,
    complemento VARCHAR(20),
    bairro VARCHAR(40) NOT NULL,
    cidade VARCHAR(40) NOT NULL,
    estado CHAR(2) NOT NULL,
    CONSTRAINT t_fornecedores_pk PRIMARY KEY (fornecedor_id)
);

CREATE TABLE t_gastos (
    gasto_id INTEGER GENERATED BY DEFAULT AS IDENTITY,
    data_cadastro DATE NOT NULL,
    cadastrado_por VARCHAR(50) NOT NULL,
    valor_gasto DECIMAL (10,2) NOT NULL,
    descricao_gasto VARCHAR(50) NOT NULL,
    data_alteracao DATE,
    alterado_por VARCHAR(50),
    data_exclusao DATE,
    excluido_por VARCHAR(50),
    fornecedor_id INTEGER NOT NULL,
    CONSTRAINT t_gastos_pk PRIMARY KEY (gasto_id),
    CONSTRAINT t_gastos_fk_fornecedor FOREIGN KEY (fornecedor_id)
        REFERENCES t_fornecedores(fornecedor_id)
);

CREATE TABLE t_abastecimentos (
    placa_veiculo CHAR(7) NOT NULL,
    litros_abastecimento INTEGER NOT NULL,
    gasto_id INTEGER NOT NULL,
    CONSTRAINT t_abastecimentos_fk FOREIGN KEY (gasto_id)
        REFERENCES t_gastos(gasto_id),
    CONSTRAINT t_abastecimentos_pk PRIMARY KEY (gasto_id)
);

CREATE TABLE t_manutencoes (
    placa_veiculo CHAR(7) NOT NULL,
    usado_garantia VARCHAR(10),
    observacao VARCHAR(50) NOT NULL,
    numero_ordem_servico INTEGER NOT NULL,
    dias_garantia DATE,
    data_manutencao DATE,
    gasto_id INTEGER NOT NULL,
    tipo_manutencao_id INTEGER NOT NULL,
    CONSTRAINT t_manutencoes_fk_gasto FOREIGN KEY (gasto_id)
        REFERENCES t_gastos(gasto_id),
    CONSTRAINT t_manutencoes_pk PRIMARY KEY (gasto_id),
    CONSTRAINT t_manutencoes_fk_tp_manutencao FOREIGN KEY (tipo_manutencao_id)
        REFERENCES t_tipo_manutencoes(tipo_manutencao_id)
);

CREATE TABLE t_tipo_manutencoes (
    tipo_manutencao_id INTEGER GENERATED BY DEFAULT AS IDENTITY,
    descricao VARCHAR(50) NOT NULL,
    CONSTRAINT t_tipo_manutencoes_pk PRIMARY KEY (tipo_manutencao_id)
);

CREATE TABLE t_impostos (
    data_competencia DATE NOT NULL,
    placa_veiculo CHAR(7) NOT NULL,
    gasto_id INTEGER NOT NULL,
    tipo_imposto_id INTEGER NOT NULL,
    CONSTRAINT t_impostos_fk_gasto FOREIGN KEY (gasto_id)
        REFERENCES t_gastos(gasto_id),
    CONSTRAINT t_impostos_pk PRIMARY KEY (gasto_id),
    CONSTRAINT t_impostos_fk_tp_imposto FOREIGN KEY (tipo_imposto_id)
        REFERENCES t_tipo_impostos(tipo_imposto_id)
);

CREATE TABLE t_tipo_impostos (
    tipo_imposto_id INTEGER GENERATED BY DEFAULT AS IDENTITY,
    descricao VARCHAR(50) NOT NULL,
    CONSTRAINT t_tp_impostos_pk PRIMARY KEY (tipo_imposto_id)
);

CREATE TABLE t_perfil_usuarios (
    perfil_id INTEGER GENERATED BY DEFAULT AS IDENTITY,
    descricao VARCHAR(50) NOT NULL,
    CONSTRAINT t_perfil_usuarios_pk PRIMARY KEY (perfil_id)
);

CREATE TABLE t_usuarios (
    usuario_id INTEGER GENERATED BY DEFAULT AS IDENTITY,
    nome VARCHAR(50) NOT NULL,
    ativo CHAR(3) NOT NULL,
    supervisor_id INTEGER,
    perfil_id INTEGER NOT NULL,
    CONSTRAINT t_usuarios_pk PRIMARY KEY (usuario_id),
    CONSTRAINT t_usuarios_fk_supervisor FOREIGN KEY (supervisor_id)
        REFERENCES t_usuarios(usuario_id),
    CONSTRAINT t_usuarios_fk_perfil FOREIGN KEY (perfil_id)
        REFERENCES t_perfil_usuarios(perfil_id)
);