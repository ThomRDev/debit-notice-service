CREATE EXTENSION IF NOT EXISTS unaccent;
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
    fecha_emision TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    importe_total NUMERIC(15,2),
    estado VARCHAR(20) CHECK (estado IN ('BORRADOR', 'PENDIENTE', 'ANULADO', 'MIGRADO')),
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


INSERT INTO AvisoDebito(
    id_cliente,
    moneda,
    tipo_cambio_moneda,
    numero_aviso,
    fecha_emision,
    importe_total,
    estado,
    numero_sap,
    condicion_pago,
    id_usuario_creador,
    id_usuario_modificador,
    fecha_creation,
    fecha_modificacion,
    observaciones
) VALUES (
    1,
    'PEN',
    3.57,
    'AD-0001',
    NOW(),
    850.00,
    'PENDIENTE',
    '1234567890',
    'CONTADO',
    1,
    1,
    NOW(),
    NOW(),
    'Observaciones del aviso de débito'
), (
    1,
    'PEN',
    3.57,
    'AD-0002',
    NOW(),
    500.00,
    'BORRADOR',
    '1234567890',
    'CONTADO',
    1,
    NULL,
    NOW(),
    NOW(),
    'Observaciones del aviso de débito'
), (
    2,
    'PEN',
    3.57,
    'AD-0003',
    NOW(),
    750.00,
    'MIGRADO',
    '1234567890',
    'CONTADO',
    2,
    2,
    NOW(),
    NOW(),
    'Observaciones del aviso de débito'
);


INSERT INTO AvisoDebito(
    id_cliente,
    moneda,
    tipo_cambio_moneda,
    numero_aviso,
    fecha_emision,
    importe_total,
    estado,
    numero_sap,
    condicion_pago,
    id_usuario_creador,
    id_usuario_modificador,
    fecha_creation,
    fecha_modificacion,
    observaciones
) VALUES (
    2,
    'PEN',
    3.57,
    'AD-0011',
    NOW(),
    750.00,
    'MIGRADO',
    '1234567890',
    'CONTADO',
    2,
    2,
    NOW(),
    NOW(),
    'Observaciones del aviso de débito'
),(
    2,
    'PEN',
    3.57,
    'AD-0015',
    NOW(),
    750.00,
    'MIGRADO',
    '1234567890',
    'CONTADO',
    2,
    2,
    NOW(),
    NOW(),
    'Observaciones del aviso de débito'
);

-- CREATE OR REPLACE FUNCTION search_aviso_debito_pagination(
--     p_numero_aviso TEXT DEFAULT NULL,
--     p_estado TEXT DEFAULT NULL,
--     p_numero_sap TEXT DEFAULT NULL,
--     p_usuario_creador TEXT DEFAULT NULL,
--     p_email_usuario_creador TEXT DEFAULT NULL,
--     p_fecha_desde DATE DEFAULT NULL,
--     p_fecha_hasta DATE DEFAULT NULL,
--     p_nombre_cliente TEXT DEFAULT NULL,
--     p_ruc_cliente TEXT DEFAULT NULL,
--     p_moneda TEXT DEFAULT NULL,
--     p_importe_min NUMERIC DEFAULT NULL,
--     p_importe_max NUMERIC DEFAULT NULL,
--     p_page INTEGER DEFAULT 1,
--     p_page_size INTEGER DEFAULT 10
-- ) RETURNS JSONB AS $$
-- DECLARE
--     result JSONB;
--     v_offset INTEGER;
-- BEGIN
--     v_offset := (p_page - 1) * p_page_size;

--     WITH filtered_data AS (
--         SELECT 
--             a.numero_aviso, 
--             a.estado, 
--             a.numero_sap, 
--             u.nombre AS usuario_creador,
--             u.email AS email_usuario_creador,
--             c.nombre AS cliente,
--             c.ruc AS ruc_cliente,
--             a.moneda,
--             a.importe_total,
--             a.fecha_emision
--         FROM AvisoDebito a
--         JOIN Cliente c ON a.id_cliente = c.id
--         JOIN Usuario u ON a.id_usuario_creador = u.id
--         WHERE (p_numero_aviso IS NULL OR a.numero_aviso ILIKE '%' || p_numero_aviso || '%')
--           AND (p_estado IS NULL OR a.estado = p_estado)
--           AND (p_numero_sap IS NULL OR a.numero_sap ILIKE '%' || p_numero_sap || '%')
--           AND (p_usuario_creador IS NULL OR u.nombre ILIKE '%' || p_usuario_creador || '%')
--           AND (p_email_usuario_creador IS NULL OR u.email ILIKE '%' || p_email_usuario_creador || '%')
--           AND (p_fecha_desde IS NULL OR a.fecha_emision >= p_fecha_desde)
--           AND (p_fecha_hasta IS NULL OR a.fecha_emision <= p_fecha_hasta)
--           AND (p_nombre_cliente IS NULL OR c.nombre ILIKE '%' || p_nombre_cliente || '%')
--           AND (p_ruc_cliente IS NULL OR c.ruc ILIKE '%' || p_ruc_cliente || '%')
--           AND (p_moneda IS NULL OR a.moneda = p_moneda)
--           AND (p_importe_min IS NULL OR a.importe_total >= p_importe_min)
--           AND (p_importe_max IS NULL OR a.importe_total <= p_importe_max)
--     )
--     SELECT jsonb_build_object(
--         'total_count', COUNT(*),
--         'current_page', p_page,
--         'page_size', p_page_size,
--         'data', (
--             SELECT jsonb_agg(row_to_json(fd))
--             FROM (
--                 SELECT *
--                 FROM filtered_data
--                 ORDER BY fecha_emision DESC
--                 LIMIT p_page_size OFFSET v_offset
--             ) fd
--         )
--     ) INTO result;

--     RETURN COALESCE(result, '{"total_count": 0, "current_page": p_page, "page_size": p_page_size, "data": []}'::jsonb);
-- END;
-- $$ LANGUAGE plpgsql;


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
          AND (p_estado IS NULL OR LOWER(p_estado) = 'todos' OR LOWER(a.estado) = LOWER(p_estado))
          AND (p_numero_sap IS NULL OR a.numero_sap ILIKE '%' || p_numero_sap || '%')
         AND (p_usuario_creador IS NULL OR unaccent(u.nombre) ILIKE '%' || unaccent(COALESCE(p_usuario_creador, '')) || '%')
          AND (p_email_usuario_creador IS NULL OR u.email ILIKE '%' || p_email_usuario_creador || '%')
          AND (p_fecha_desde IS NULL OR a.fecha_emision >= p_fecha_desde)
          AND (p_fecha_hasta IS NULL OR a.fecha_emision <= p_fecha_hasta)
          AND (p_nombre_cliente IS NULL OR unaccent(c.nombre) ILIKE '%' || unaccent(COALESCE(p_nombre_cliente, '')) || '%')
          AND (p_ruc_cliente IS NULL OR c.ruc ILIKE '%' || p_ruc_cliente || '%')
          AND (p_moneda IS NULL OR LOWER(p_moneda) = 'todas' OR a.moneda = p_moneda)
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


CREATE OR REPLACE FUNCTION get_solicitudes_anticipo(
    p_numero_solicitud TEXT DEFAULT NULL
) RETURNS JSONB AS $$
DECLARE
    result JSONB;
BEGIN
    SELECT jsonb_agg(
        jsonb_build_object(
            'id', sa.id,
            'id_cliente', sa.id_cliente,
            'numero_solicitud', sa.numero_solicitud,
            'fecha_solicitud', sa.fecha_solicitud,
            'solicitante', sa.solicitante,
            'importe', sa.importe,
            'moneda', sa.moneda,
            'motivo', sa.motivo,
            'estado', sa.estado
        )
    ) INTO result
    FROM SolicitudAnticipo sa
    WHERE p_numero_solicitud IS NULL OR sa.numero_solicitud = p_numero_solicitud;

    RETURN COALESCE(result, '[]'::jsonb);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_search_solicitudes_anticipo(
    p_numero_solicitud TEXT DEFAULT NULL,
    p_page INTEGER DEFAULT 1,
    p_page_size INTEGER DEFAULT 10
)RETURNS JSONB AS $$
DECLARE
    result JSONB;
    v_offset INTEGER;
    v_total_records INTEGER;
BEGIN   
    v_offset := (p_page - 1) * p_page_size;

    WITH filtered_data AS (
        SELECT *
        FROM SolicitudAnticipo
        WHERE p_numero_solicitud IS NULL OR numero_solicitud = p_numero_solicitud
    )
    SELECT jsonb_build_object(
        'total_count', (SELECT COUNT(*) FROM filtered_data),
        'current_page', p_page,
        'page_size', p_page_size,
        'data', (
            SELECT jsonb_agg(
                jsonb_build_object(
                    'id', sa.id,
                    'id_cliente', sa.id_cliente,
                    'numero_solicitud', sa.numero_solicitud,
                    'fecha_solicitud', sa.fecha_solicitud,
                    'solicitante', sa.solicitante,
                    'importe', sa.importe,
                    'moneda', sa.moneda,
                    'motivo', sa.motivo,
                    'estado', sa.estado
                )
            )
            FROM (
                SELECT *
                FROM filtered_data
                ORDER BY fecha_solicitud DESC
                LIMIT p_page_size OFFSET v_offset
            ) sa
        )
    ) INTO result;

    RETURN COALESCE(result, jsonb_build_object(
    'total_count', 0,
    'current_page', p_page,
    'page_size', p_page_size,
    'data', '[]'::jsonb
	));
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION validar_cambio_estado_avisos(
    avisos VARCHAR[], 
    estado_final TEXT
) RETURNS JSON AS $$
DECLARE
    aviso RECORD;
    resultado JSONB := jsonb_build_object('success', jsonb_build_array(), 'errors', jsonb_build_array());
    estados_validos TEXT[] := ARRAY['BORRADOR', 'PENDIENTE', 'MIGRADO', 'ANULADO'];
BEGIN
    IF estado_final NOT IN (SELECT UNNEST(estados_validos)) THEN
        RAISE EXCEPTION 'Estado final inválido: %', estado_final;
    END IF;

    FOR aviso IN SELECT id, estado, numero_aviso FROM AvisoDebito WHERE numero_aviso = ANY(avisos) LOOP
        IF aviso.estado = 'ANULADO' THEN
            resultado := jsonb_set(resultado, '{errors}', resultado->'errors' || 
                to_jsonb(jsonb_build_object(
                    'id', aviso.id, 
                    'numero_aviso', aviso.numero_aviso,
                    'from', aviso.estado, 
                    'to', estado_final, 
                    'mensaje', 'No se puede cambiar el estado de un aviso anulado',
                    'descripcion', format('El número de aviso %s no puede cambiar de %s a %s', aviso.numero_aviso, aviso.estado, estado_final)
                )), true);
        ELSIF (aviso.estado = 'BORRADOR' AND estado_final = 'PENDIENTE') OR
              (aviso.estado = 'PENDIENTE' AND estado_final = 'MIGRADO') OR
              (aviso.estado = 'MIGRADO' AND estado_final = 'ANULADO') THEN
           
            resultado := jsonb_set(resultado, '{success}', resultado->'success' || 
                to_jsonb(jsonb_build_object(
                    'id', aviso.id, 
                    'numero_aviso', aviso.numero_aviso,  
                    'from', aviso.estado,
                    'to', estado_final, 
                    'mensaje', 'Cambio de estado permitido',
                    'descripcion', format('El número de aviso %s se cambia de %s a %s', aviso.numero_aviso, aviso.estado, estado_final)
                )), true);
        ELSE
            resultado := jsonb_set(resultado, '{errors}', resultado->'errors' || 
                to_jsonb(jsonb_build_object(
                    'id', aviso.id, 
                    'numero_aviso', aviso.numero_aviso,  
                    'from', aviso.estado, 
                    'to', estado_final, 
                    'mensaje', 'Cambio de estado no permitido',
                    'descripcion', format('El número de aviso %s no puede cambiar de %s a %s', aviso.numero_aviso, aviso.estado, estado_final)
                )), true);
        END IF;
    END LOOP;

    RETURN resultado;
END;
$$ LANGUAGE plpgsql;




CREATE OR REPLACE FUNCTION actualizar_estado_avisos(
    avisos JSONB, 
    estado_final TEXT,
    usuario_modificador INTEGER,
    motivo TEXT DEFAULT NULL
) RETURNS VOID AS $$
DECLARE
    aviso JSONB;
    aviso_id INTEGER;
    p_numero_sap TEXT;
BEGIN
    FOR aviso IN SELECT * FROM jsonb_array_elements(avisos) LOOP
        aviso_id := (aviso->>'id')::INTEGER;
        p_numero_sap := aviso->>'numero_sap';

        IF aviso_id IS NULL THEN
            RAISE EXCEPTION 'Datos inválidos en el JSON: %', aviso;
        END IF;

        IF estado_final IN ('MIGRADO')  THEN
            IF p_numero_sap IS NULL THEN
                RAISE EXCEPTION 'El número SAP es obligatorio cuando el estado es MIGRADO para el aviso %', aviso_id;
            END IF;

            UPDATE AvisoDebito 
            SET estado = estado_final, 
                numero_sap = p_numero_sap,
                fecha_modificacion = NOW(),
                id_usuario_modificador = usuario_modificador
            WHERE id = aviso_id;
        ELSE
            UPDATE AvisoDebito 
            SET estado = estado_final, 
                fecha_modificacion = NOW(),
                id_usuario_modificador = usuario_modificador
            WHERE id = aviso_id;
        END IF;

        INSERT INTO LogAvisoDebito(id_aviso, fecha_gestion, usuario_gestion, estado, motivo)
        VALUES (aviso_id, NOW(), usuario_modificador, estado_final, motivo);
    END LOOP;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION crear_aviso_completo(
    p_aviso JSONB,
    p_detalles JSONB[]
) RETURNS INTEGER AS $$
DECLARE
    v_id_aviso INTEGER;
    v_detalle JSONB;
BEGIN
    BEGIN
        SELECT crear_aviso(
            (p_aviso->>'id_cliente')::INTEGER,
            p_aviso->>'moneda',
            (p_aviso->>'tipo_cambio_moneda')::NUMERIC,
            p_aviso->>'numero_aviso',
            (p_aviso->>'fecha_emision')::DATE,
            (p_aviso->>'importe_total')::NUMERIC,
            p_aviso->>'estado',
            p_aviso->>'numero_sap',
            p_aviso->>'condicion_pago',
            (p_aviso->>'id_usuario_modificador')::INTEGER,
            (p_aviso->>'fecha_modificacion')::TIMESTAMP,
            p_aviso->>'observaciones'
        ) INTO v_id_aviso;
        
        IF p_detalles IS NOT NULL AND array_length(p_detalles, 1) IS NOT NULL THEN
            FOREACH v_detalle IN ARRAY p_detalles
            LOOP
                PERFORM crear_detalle_aviso(
                    v_id_aviso,
                    (v_detalle->>'numero_linea')::INTEGER,
                    v_detalle->>'tipo_concepto',
                    v_detalle->>'codigo_concepto',
                    v_detalle->>'descripcion_concepto',
                    (v_detalle->>'cantidad')::NUMERIC,
                    v_detalle->>'unidad_medida',
                    (v_detalle->>'precio_unitario')::NUMERIC,
                    (v_detalle->>'importe')::NUMERIC,
                    v_detalle->>'centro_costo',
                    (v_detalle->>'numero_solicitud_anticipo')::INTEGER,
                    (v_detalle->>'fecha_servicio_desde')::DATE,
                    (v_detalle->>'fecha_servicio_hasta')::DATE,
                    v_detalle->>'observaciones'
                );
            END LOOP;
        END IF;
        
        RETURN v_id_aviso;
        
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Error al crear aviso: %', SQLERRM;
            RETURN NULL;
    END;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION crear_aviso(
    p_id_cliente integer, 
    p_moneda text, 
    p_tipo_cambio_moneda numeric, 
    p_numero_aviso text, 
    p_fecha_emision date, 
    p_importe_total numeric, 
    p_estado text, 
    p_numero_sap text, 
    p_condicion_pago text, 
    p_id_usuario_modificador integer, 
    p_fecha_modificacion timestamp without time zone, 
    p_observaciones text
) RETURNS integer AS $$
DECLARE
    v_id_aviso INTEGER;
BEGIN
    PERFORM setval('avisodebito_id_seq', COALESCE((SELECT MAX(id) FROM AvisoDebito), 0) + 1, false);
    INSERT INTO AvisoDebito (
        id_cliente, moneda, tipo_cambio_moneda, numero_aviso, fecha_emision,
        importe_total, estado, numero_sap, condicion_pago, id_usuario_modificador,
        fecha_modificacion, observaciones
    ) VALUES (
        p_id_cliente, p_moneda, p_tipo_cambio_moneda, 
        CASE
            WHEN p_estado = 'BORRADOR' THEN 'TEMP-' || TO_CHAR(nextval('avisodebito_id_seq'), 'FM0000')
			ELSE 'AD-' || TO_CHAR(nextval('avisodebito_id_seq'), 'FM0000')
        END, 
        p_fecha_emision,
        p_importe_total, p_estado, p_numero_sap, p_condicion_pago, p_id_usuario_modificador,
        p_fecha_modificacion, p_observaciones
    ) RETURNING id INTO v_id_aviso;

    RETURN v_id_aviso;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION crear_detalle_aviso(
    p_id_aviso_debito integer, 
    p_numero_linea integer, 
    p_tipo_concepto text, 
    p_codigo_concepto text, 
    p_descripcion_concepto text, 
    p_cantidad numeric, 
    p_unidad_medida text, 
    p_precio_unitario numeric, 
    p_importe numeric, 
    p_centro_costo text, 
    p_numero_solicitud_anticipo integer, 
    p_fecha_servicio_desde date, 
    p_fecha_servicio_hasta date, 
    p_observaciones text
) RETURNS void AS $$
BEGIN
    CASE p_tipo_concepto
        WHEN 'SERVICIO' THEN v_prefix := 'SERV-';
        WHEN 'ANTICIPO' THEN v_prefix := 'ANT-';
        WHEN 'OTROS' THEN v_prefix := 'OTRO-';
        ELSE v_prefix := 'AD-';
    END CASE;
	v_importe := p_cantidad * p_precio_unitario;
	SELECT COALESCE(MAX(numero_linea), 0) + 1 
    INTO v_numero_linea
    FROM DetalleAvisoDebito 
    WHERE id_aviso_debito = p_id_aviso_debito;
	PERFORM setval('detalleavisodebito_id_seq', COALESCE((SELECT MAX(id) FROM DetalleAvisoDebito), 0) + 1, false);
    INSERT INTO DetalleAvisoDebito (
        id_aviso_debito, numero_linea, tipo_concepto, codigo_concepto, descripcion_concepto,
        cantidad, unidad_medida, precio_unitario, importe, centro_costo,
        numero_solicitud_anticipo, fecha_servicio_desde, fecha_servicio_hasta, observaciones
    ) VALUES (
        p_id_aviso_debito, v_numero_linea, p_tipo_concepto, 
		v_prefix || TO_CHAR(nextval('avisodebito_id_seq'), 'FM0000'), p_descripcion_concepto,
        p_cantidad, p_unidad_medida, p_precio_unitario, v_importe, p_centro_costo,
        p_numero_solicitud_anticipo, p_fecha_servicio_desde, p_fecha_servicio_hasta, p_observaciones
    );
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_detail_aviso_debito(
    p_numero_aviso TEXT
) RETURNS JSONB AS $$
DECLARE
    aviso_completo JSONB;
    detalle_aviso_debito JSONB;
    result JSONB;
BEGIN
    SELECT row_to_json(aviso)::JSONB 
    INTO aviso_completo
    FROM (
        SELECT a.*, u.nombre AS usuario_creador, c.nombre AS cliente,c.ruc,c.direccion,c.contacto
        FROM AvisoDebito a
        JOIN Usuario u ON a.id_usuario_creador = u.id
        JOIN Cliente c ON a.id_cliente = c.id
        WHERE a.numero_aviso = p_numero_aviso
    ) aviso;

    SELECT COALESCE(jsonb_agg(row_to_json(d)), '[]'::JSONB) 
    INTO detalle_aviso_debito 
    FROM ( 
        SELECT * FROM DetalleAvisoDebito 
        WHERE id_aviso_debito = (aviso_completo->>'id')::INT 
    ) d;

    SELECT jsonb_build_object(
        'aviso_debito', aviso_completo,
        'detalle_aviso_debito', detalle_aviso_debito
    ) INTO result;
    

    RETURN result;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION buscar_clientes(filtro TEXT DEFAULT NULL)
RETURNS SETOF Cliente AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM Cliente
    WHERE 
        filtro IS NULL OR filtro = ''
        OR ruc ILIKE '%' || filtro || '%'
        OR unaccent(nombre) ILIKE '%' || unaccent(filtro) || '%';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.modificar_aviso(p_id_aviso INTEGER, p_id_cliente INTEGER, p_estado TEXT, p_observaciones text, p_id_usuario_modificador INTEGER)
	RETURNS text
 LANGUAGE plpgsql
AS $function$
	BEGIN
		UPDATE AvisoDebito
		SET
			id_cliente = p_id_cliente,
			estado = p_estado,
			observaciones = p_observaciones,
			id_usuario_modificador = p_id_usuario_modificador,
			numero_aviso = CASE 
            	WHEN p_estado = 'PENDIENTE' AND numero_aviso LIKE 'TEMP-%' 
            		THEN 'AD-' || SUBSTRING(numero_aviso FROM 6)
				WHEN p_estado = 'BORRADOR' AND numero_aviso NOT LIKE 'TEMP-%' 
                	THEN 'TEMP-' || SUBSTRING(numero_aviso FROM 4)  
            	ELSE numero_aviso 
        	END
		WHERE id = p_id_aviso;
		RETURN 'Aviso de débito actualizado correctamente';
	END;
$function$
;


CREATE OR REPLACE FUNCTION public.generar_numero_temporal()
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE v_numero_temporal TEXT;
	BEGIN
		v_numero_temporal := 'TEMP-' || TO_CHAR(nextval('avisodebito_id_seq'), 'FM0000');
    	RETURN v_numero_temporal;
	END;
$function$
;

ALTER FUNCTION public.generar_numero_temporal() OWNER TO db_owner;