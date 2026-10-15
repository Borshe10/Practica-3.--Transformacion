CREATE TABLE dim_sismos (
    id_sismo INTEGER PRIMARY KEY,
    magnitud NUMERIC(4,2),
    latitud NUMERIC(10,6),
    longitud NUMERIC(10,6),
    profundidad NUMERIC(10,2),
    referencia_de_localizacion TEXT,
    estado VARCHAR(100),
    nombre_estado VARCHAR(100)
);

CREATE TABLE dim_tiempo (
    id_tiempo INTEGER PRIMARY KEY,
    hora_utc TIME,
    fecha DATE,
    anio INTEGER,
    mes INTEGER,
    dia INTEGER,
    trimestre INTEGER
);

CREATE TABLE dim_zonas (
    id_zonas INTEGER PRIMARY KEY,
    entidad VARCHAR(150),
    nom_ent VARCHAR(150),
    pobtot BIGINT,
    pobfem BIGINT,
    pobmas BIGINT
);

CREATE TABLE dim_economia (
    id_economia INTEGER PRIMARY KEY,
    nombre_entidad VARCHAR(150),
    entidad VARCHAR(150),
    produccion_bruta_total NUMERIC(18,2),
    insumos_utilizados NUMERIC(18,2),
    consumo_intermedio NUMERIC(18,2),
    valor_agregado NUMERIC(18,2),
    formacion_capital NUMERIC(18,2),
    activos_fijos_adquiridos NUMERIC(18,2)
);

CREATE TABLE fact_impacto_sismos_imputed (
    id_sismo INTEGER NOT NULL,
    id_zonas INTEGER NOT NULL,
    id_economia INTEGER NOT NULL,
    id_tiempo INTEGER NOT NULL,

    FOREIGN KEY (id_sismo)
        REFERENCES dim_sismos(id_sismo),

    FOREIGN KEY (id_zonas)
        REFERENCES dim_zonas(id_zonas),

    FOREIGN KEY (id_economia)
        REFERENCES dim_economia(id_economia),

    FOREIGN KEY (id_tiempo)
        REFERENCES dim_tiempo(id_tiempo)
);

CREATE TABLE validacion (
    id_validacion INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_sismo INTEGER NOT NULL,
    fecha_revision TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tipo_problema VARCHAR(100) NOT NULL,
    descripcion TEXT,
    estado VARCHAR(30) NOT NULL DEFAULT 'Pendiente',
    valor_anterior TEXT,
    valor_corregido TEXT,

    FOREIGN KEY (id_sismo)
        REFERENCES dim_sismos(id_sismo)
);
CREATE TABLE alerta_sismica (
    id_sismo INTEGER PRIMARY KEY,
    fecha_emision TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    magnitud_detectada NUMERIC(4,2),
    nivel_alerta VARCHAR(30) NOT NULL,
    mensaje TEXT,
    estado_alerta VARCHAR(30) NOT NULL DEFAULT 'Emitida',
    fuente_alerta VARCHAR(150),
    fecha_recepcion TIMESTAMP,

    CONSTRAINT fk_alerta_sismo
        FOREIGN KEY (id_sismo)
        REFERENCES dim_sismos(id_sismo),

    CONSTRAINT chk_nivel_alerta
        CHECK (nivel_alerta IN (
            'Preventiva',
            'Informativa',
            'Alerta',
            'Alarma'
        )),

    CONSTRAINT chk_estado_alerta
        CHECK (estado_alerta IN (
            'Emitida',
            'Recibida',
            'Cancelada',
            'Finalizada'
        ))
);
