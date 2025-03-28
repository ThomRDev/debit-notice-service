CREATE TABLE Cliente (
    id SERIAL PRIMARY KEY,
    ruc VARCHAR(20) NOT NULL,
    nombre VARCHAR(200) NOT NULL,
    direccion VARCHAR(500),
    contacto VARCHAR(200)
);

CREATE TABLE Usuario (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(200) UNIQUE NOT NULL
);

CREATE TABLE SolicitudAnticipo (
    id SERIAL PRIMARY KEY,
    id_cliente INTEGER,
    numero_solicitud VARCHAR(50) UNIQUE NOT NULL,
    fecha_solicitud DATE NOT NULL,
    solicitante VARCHAR(100),
    importe NUMERIC(15,2) NOT NULL,
    moneda VARCHAR(10),
    motivo TEXT,
    estado VARCHAR(50),
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id)
);

CREATE TABLE AvisoDebito (
    id SERIAL PRIMARY KEY,
    id_cliente INTEGER,
    moneda VARCHAR(10),
    tipo_cambio_moneda NUMERIC(10,4),
    numero_aviso VARCHAR(50) UNIQUE,
    fecha_emision DATE,
    importe_total NUMERIC(15,2),
    estado VARCHAR(20) CHECK (estado IN ('BORRADOR', 'PENDIENTE', 'ANULADO', 'APROBADO', 'MIGRADO')),
    numero_sap VARCHAR(50),
    condicion_pago VARCHAR(100),
    id_usuario_creador INTEGER,
    id_usuario_modificador INTEGER,
    fecha_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_modificacion TIMESTAMP,
    observaciones TEXT,
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id),
    FOREIGN KEY (id_usuario_creador) REFERENCES Usuario(id),
    FOREIGN KEY (id_usuario_modificador) REFERENCES Usuario(id)
);

CREATE TABLE DetalleAvisoDebito (
    id SERIAL PRIMARY KEY,
    id_aviso_debito INTEGER,
    numero_linea INTEGER,
    tipo_concepto VARCHAR(50),
    codigo_concepto VARCHAR(50),
    descripcion_concepto TEXT,
    cantidad NUMERIC(10,2),
    unidad_medida VARCHAR(50),
    precio_unitario NUMERIC(15,2),
    importe NUMERIC(15,2),
    centro_costo VARCHAR(100),
    numero_solicitud_anticipo INTEGER,
    fecha_servicio_desde DATE,
    fecha_servicio_hasta DATE,
    observaciones TEXT,
    FOREIGN KEY (id_aviso_debito) REFERENCES AvisoDebito(id),
    FOREIGN KEY (numero_solicitud_anticipo) REFERENCES SolicitudAnticipo(id)
);

CREATE TABLE LogAvisoDebito (
    id SERIAL PRIMARY KEY,
    id_aviso INTEGER,
    fecha_gestion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_gestion INTEGER,
    estado VARCHAR(50),
    FOREIGN KEY (id_aviso) REFERENCES AvisoDebito(id),
    FOREIGN KEY (usuario_gestion) REFERENCES Usuario(id)
);


INSERT INTO Cliente (ruc, nombre, direccion, contacto) VALUES 
('20123456781', 'INDUSTRIAS METAL PERU SAC', 'Av. Industrial 345, Callao', 'Ricardo Mendoza'),
('20789012345', 'AGROINDUSTRIAS DEL SUR', 'Calle Agricultura 678, Ica', 'Sofía Carranza'),
('20456789012', 'TEXTILES ANDINOS EIRL', 'Jr. Garcilaso 910, Cusco', 'Pedro Valdivia'),
('20234567890', 'COMERCIALIZADORA NORTE', 'Av. Universitaria 1112, Trujillo', 'Elena Ramirez'),
('20567890123', 'CONSULTORA ESTRATEGICA SAC', 'Calle Las Flores 567, San Isidro', 'Miguel Ángel Torres');

INSERT INTO Usuario (nombre, email) VALUES 
('Ricardo Mendoza', 'ricardo.mendoza@industriasmetal.com'),
('Sofía Carranza', 'sofia.carranza@agroindustrias.pe'),
('Pedro Valdivia', 'pedro.valdivia@textilesandinos.com'),
('Elena Ramirez', 'elena.ramirez@comercializadoranorte.com'),
('Miguel Ángel Torres', 'miguel.torres@consultorastrategica.pe');

INSERT INTO SolicitudAnticipo (
    id_cliente, 
    numero_solicitud, 
    fecha_solicitud, 
    solicitante, 
    importe, 
    moneda, 
    motivo, 
    estado
) VALUES 
(1, 'ANT-2025-001', '2025-03-05', 'Juan Pérez', 850.00, 'PEN', 'Viáticos Departamento Comercial', 'APROBADO'),
(1, 'ANT-2025-002', '2025-03-09', 'María López', 500.00, 'PEN', 'Combustible Logística', 'PENDIENTE'),
(1, 'ANT-2025-003', '2025-03-15', 'Carlos Rodríguez', 750.00, 'PEN', 'Gastos de Representación', 'APROBADO'),
(1, 'ANT-2025-004', '2025-03-20', 'Ana Martínez', 1200.00, 'PEN', 'Viaje de Negocios', 'PENDIENTE'),
(2, 'ANT-2025-005', '2025-03-25', 'Diego Sánchez', 600.00, 'PEN', 'Materiales de Oficina', 'APROBADO'),
(2, 'ANT-2025-006', '2025-04-02', 'Laura Torres', 450.00, 'PEN', 'Capacitación', 'PENDIENTE'),
(2, 'ANT-2025-007', '2025-04-10', 'Roberto García', 950.00, 'PEN', 'Evento Comercial', 'APROBADO'),
(2, 'ANT-2025-008', '2025-04-15', 'Sofía Ramírez', 350.00, 'PEN', 'Mantenimiento Equipos', 'PENDIENTE'),
(3, 'ANT-2025-009', '2025-04-22', 'Miguel Hernández', 1100.00, 'PEN', 'Desarrollo de Proyecto', 'APROBADO'),
(3, 'ANT-2025-010', '2025-05-01', 'Elena Castillo', 680.00, 'PEN', 'Reunión con Clientes', 'PENDIENTE'),
(3, 'ANT-2025-011', '2025-05-08', 'Pedro Vargas', 520.00, 'PEN', 'Suministros', 'APROBADO'),
(4, 'ANT-2025-012', '2025-05-16', 'Carmen Mendoza', 780.00, 'PEN', 'Consultoría', 'PENDIENTE'),
(4, 'ANT-2025-013', '2025-05-24', 'Javier Ríos', 900.00, 'PEN', 'Evento Internacional', 'APROBADO'),
(5, 'ANT-2025-014', '2025-06-02', 'Lucía Mendez', 400.00, 'PEN', 'Papelería', 'PENDIENTE');

CREATE OR REPLACE FUNCTION search_aviso_debito(
    p_numero_aviso TEXT DEFAULT NULL,
    p_estado TEXT DEFAULT NULL,
    p_numero_sap TEXT DEFAULT NULL,
    p_usuario_creador TEXT DEFAULT NULL,
    p_email_usuario_creador TEXT DEFAULT NULL,
    p_fecha_desde DATE DEFAULT NULL,
    p_fecha_hasta DATE DEFAULT NULL,
    p_nombre_cliente TEXT DEFAULT NULL,
    p_ruc_cliente TEXT DEFAULT NULL,
    p_moneda TEXT DEFAULT NULL,
    p_importe_min NUMERIC DEFAULT NULL,
    p_importe_max NUMERIC DEFAULT NULL
) RETURNS JSONB AS $$
DECLARE
    result JSONB;
BEGIN
    SELECT jsonb_agg(row_to_json(t)) INTO result
    FROM (
        SELECT 
            a.numero_aviso, 
            a.estado, 
            a.numero_sap, 
            u.nombre AS usuario_creador,
            u.email AS email_usuario_creador,
            c.nombre AS cliente,
            c.ruc AS ruc_cliente,
            a.moneda,
            a.importe_total,
            a.fecha_emision
        FROM AvisoDebito a
        JOIN Cliente c ON a.id_cliente = c.id
        JOIN Usuario u ON a.id_usuario_creador = u.id
        WHERE (p_numero_aviso IS NULL OR a.numero_aviso ILIKE '%' || p_numero_aviso || '%')
          AND (p_estado IS NULL OR a.estado = p_estado)
          AND (p_numero_sap IS NULL OR a.numero_sap ILIKE '%' || p_numero_sap || '%')
          AND (p_usuario_creador IS NULL OR u.nombre ILIKE '%' || p_usuario_creador || '%')
          AND (p_email_usuario_creador IS NULL OR u.email ILIKE '%' || p_email_usuario_creador || '%')
          AND (p_fecha_desde IS NULL OR a.fecha_emision >= p_fecha_desde)
          AND (p_fecha_hasta IS NULL OR a.fecha_emision <= p_fecha_hasta)
          AND (p_nombre_cliente IS NULL OR c.nombre ILIKE '%' || p_nombre_cliente || '%')
          AND (p_ruc_cliente IS NULL OR c.ruc ILIKE '%' || p_ruc_cliente || '%')
          AND (p_moneda IS NULL OR a.moneda = p_moneda)
          AND (p_importe_min IS NULL OR a.importe_total >= p_importe_min)
          AND (p_importe_max IS NULL OR a.importe_total <= p_importe_max)
    ) t;

    RETURN COALESCE(result, '[]'::jsonb);
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION get_clientes_info(
    p_nombre_cliente TEXT
) RETURNS JSONB AS $$
DECLARE
    result JSONB;
BEGIN
    SELECT jsonb_agg(
        jsonb_build_object(
            'id', c.id,
            'nombre', c.nombre,
            'ruc', c.ruc,
            'direccion', c.direccion,
            'contacto', c.contacto
        )
    ) INTO result
    FROM Cliente c
    WHERE c.nombre ILIKE '%' || p_nombre_cliente || '%';

    RETURN COALESCE(result, '[]'::jsonb);
END;
$$ LANGUAGE plpgsql;