-- Tipos Enumerados (Enums)
CREATE TYPE public.estado_invitacion AS ENUM ('pendiente', 'aceptada', 'rechazada');
CREATE TYPE public.rol_familia AS ENUM ('miembro', 'capitan', 'lider');
CREATE TYPE public.categoria_mensaje AS ENUM ('jugador', 'familia', 'sistema', 'batalla', 'espionaje');
CREATE TYPE public.estado_flota AS ENUM ('en_camino', 'regresando', 'estacionada', 'combatiendo');
CREATE TYPE public.tipo_mision AS ENUM ('atacar', 'transportar', 'espiar', 'colonizar', 'recolectar');

-- Usuarios y Sistema
CREATE TABLE public.usuario (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid() REFERENCES auth.users(id) ON DELETE CASCADE,
    nombre_usuario text NOT NULL UNIQUE,
    email text NOT NULL UNIQUE,
    url_avatar text,
    nombre text DEFAULT '',
    titulo text,
    rol text DEFAULT 'USER',
    primer_login boolean DEFAULT false,
    ultimo_visto timestamptz DEFAULT now(),
    fecha_creacion timestamptz DEFAULT now(),
    fecha_actualizacion timestamptz DEFAULT now()
);

CREATE TABLE public.historial_acceso (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id uuid REFERENCES public.usuario(id) ON DELETE CASCADE,
    fecha_acceso timestamptz DEFAULT now(),
    direccion_ip text,
    agente_usuario text,
    fecha_creacion timestamptz,
    fecha_actualizacion timestamptz
);

CREATE TABLE public.puntuacion_usuario (
    usuario_id uuid PRIMARY KEY REFERENCES public.usuario(id) ON DELETE CASCADE,
    puntos_habitaciones real DEFAULT 0,
    puntos_tropas real DEFAULT 0,
    puntos_entrenamientos real DEFAULT 0,
    puntos_totales real DEFAULT 0,
    puntos_honor_atacante real DEFAULT 0,
    puntos_honor_defensor real DEFAULT 0,
    puntos_honor_totales real DEFAULT 0,
    fecha_creacion timestamptz,
    fecha_actualizacion timestamptz
);

CREATE TABLE public.errores_configuracion (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id uuid,
    mensaje_error text,
    fecha_creacion timestamptz DEFAULT now()
);

-- Configuración (Meta-Data del Juego)
CREATE TABLE public.configuracion_habitacion (
    id text PRIMARY KEY,
    nombre text NOT NULL,
    descripcion text,
    url_imagen text NOT NULL,
    costo_armas bigint DEFAULT 0,
    costo_municion bigint DEFAULT 0,
    costo_dolares bigint DEFAULT 0,
    duracion_construccion integer DEFAULT 0,
    produccion_base real DEFAULT 0,
    recurso_producido text,
    puntos real DEFAULT 0,
    fecha_creacion timestamptz,
    fecha_actualizacion timestamptz
);

CREATE TABLE public.configuracion_entrenamiento (
    id text PRIMARY KEY,
    nombre text NOT NULL,
    url_imagen text NOT NULL,
    costo_armas bigint DEFAULT 0,
    costo_municion bigint DEFAULT 0,
    costo_dolares bigint DEFAULT 0,
    duracion_entrenamiento integer DEFAULT 0,
    puntos real DEFAULT 0,
    fecha_creacion timestamptz,
    fecha_actualizacion timestamptz
);

CREATE TABLE public.configuracion_tropa (
    id text PRIMARY KEY,
    nombre text NOT NULL,
    descripcion text,
    url_imagen text NOT NULL,
    costo_armas bigint DEFAULT 0,
    costo_municion bigint DEFAULT 0,
    costo_dolares bigint DEFAULT 0,
    duracion_reclutamiento integer DEFAULT 0,
    ataque integer DEFAULT 0,
    defensa integer DEFAULT 0,
    capacidad_carga integer DEFAULT 0,
    velocidad bigint DEFAULT 0,
    salario integer DEFAULT 0,
    puntos real DEFAULT 0,
    tipo text NOT NULL,
    requisitos jsonb,
    bonus_ataque text[],
    bonus_defensa text[],
    fecha_creacion timestamptz,
    fecha_actualizacion timestamptz
);

CREATE TABLE public.requisito_habitacion (
    id uuid PRIMARY KEY,
    habitacion_id text REFERENCES public.configuracion_habitacion(id),
    habitacion_requerida_id text REFERENCES public.configuracion_habitacion(id),
    nivel_requerido integer
);

CREATE TABLE public.requisito_entrenamiento (
    id uuid PRIMARY KEY,
    entrenamiento_id text REFERENCES public.configuracion_entrenamiento(id),
    entrenamiento_requerido_id text REFERENCES public.configuracion_entrenamiento(id),
    nivel_requerido integer
);

CREATE TABLE public.tropa_bonus_contrincante (
    id uuid PRIMARY KEY,
    tropa_atacante_id text REFERENCES public.configuracion_tropa(id),
    tropa_defensora_id text REFERENCES public.configuracion_tropa(id),
    factor_prioridad real
);

-- Propiedades (Estado del Juego)
CREATE TABLE public.propiedad (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id uuid REFERENCES public.usuario(id) ON DELETE CASCADE,
    nombre text NOT NULL,
    coordenada_ciudad integer NOT NULL,
    coordenada_barrio integer NOT NULL,
    coordenada_edificio integer NOT NULL,
    armas bigint DEFAULT 0 CHECK (armas >= 0),
    municion bigint DEFAULT 0 CHECK (municion >= 0),
    alcohol bigint DEFAULT 0 CHECK (alcohol >= 0),
    dolares bigint DEFAULT 0 CHECK (dolares >= 0),
    ultima_recogida_recursos timestamptz,
    fecha_creacion timestamptz,
    fecha_actualizacion timestamptz,
    UNIQUE (coordenada_ciudad, coordenada_barrio, coordenada_edificio)
);

CREATE TABLE public.habitacion_usuario (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    propiedad_id uuid REFERENCES public.propiedad(id) ON DELETE CASCADE,
    habitacion_id text REFERENCES public.configuracion_habitacion(id),
    nivel smallint DEFAULT 0,
    fecha_creacion timestamptz,
    fecha_actualizacion timestamptz,
    UNIQUE (propiedad_id, habitacion_id)
);

CREATE TABLE public.tropa_propiedad (
    propiedad_id uuid REFERENCES public.propiedad(id) ON DELETE CASCADE,
    tropa_id text REFERENCES public.configuracion_tropa(id),
    cantidad integer DEFAULT 0 CHECK (cantidad >= 0),
    fecha_creacion timestamptz,
    fecha_actualizacion timestamptz,
    PRIMARY KEY (propiedad_id, tropa_id)
);

CREATE TABLE public.tropa_seguridad_propiedad (
    propiedad_id uuid REFERENCES public.propiedad(id) ON DELETE CASCADE,
    tropa_id text REFERENCES public.configuracion_tropa(id),
    cantidad integer DEFAULT 0 CHECK (cantidad >= 0),
    fecha_creacion timestamptz,
    fecha_actualizacion timestamptz,
    PRIMARY KEY (propiedad_id, tropa_id)
);

CREATE TABLE public.entrenamiento_usuario (
    usuario_id uuid REFERENCES public.usuario(id) ON DELETE CASCADE,
    entrenamiento_id text REFERENCES public.configuracion_entrenamiento(id),
    nivel integer DEFAULT 0,
    fecha_creacion timestamptz,
    fecha_actualizacion timestamptz,
    PRIMARY KEY (usuario_id, entrenamiento_id)
);

-- Colas de Procesos
CREATE TABLE public.cola_construccion (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    propiedad_id uuid REFERENCES public.propiedad(id) ON DELETE CASCADE,
    habitacion_id text REFERENCES public.configuracion_habitacion(id),
    nivel_destino integer NOT NULL,
    duracion_segundos integer NOT NULL,
    fecha_inicio timestamptz NOT NULL,
    fecha_fin timestamptz,
    fecha_creacion timestamptz,
    fecha_actualizacion timestamptz
);

CREATE TABLE public.cola_investigacion (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id uuid REFERENCES public.usuario(id) ON DELETE CASCADE,
    propiedad_id uuid REFERENCES public.propiedad(id),
    entrenamiento_id text REFERENCES public.configuracion_entrenamiento(id),
    nivel_destino integer NOT NULL,
    fecha_inicio timestamptz NOT NULL,
    fecha_fin timestamptz NOT NULL,
    fecha_creacion timestamptz,
    fecha_actualizacion timestamptz,
    UNIQUE (propiedad_id)
);

CREATE TABLE public.cola_reclutamiento (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    propiedad_id uuid REFERENCES public.propiedad(id) ON DELETE CASCADE,
    tropa_id text REFERENCES public.configuracion_tropa(id),
    cantidad integer NOT NULL,
    fecha_inicio timestamptz NOT NULL,
    fecha_fin timestamptz NOT NULL,
    fecha_creacion timestamptz,
    fecha_actualizacion timestamptz,
    UNIQUE (propiedad_id)
);

-- Familias y Diplomacia
CREATE TABLE public.familia (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre text NOT NULL UNIQUE,
    etiqueta text NOT NULL UNIQUE,
    descripcion text,
    url_avatar text,
    fecha_creacion timestamptz,
    fecha_actualizacion timestamptz
);

CREATE TABLE public.miembro_familia (
    usuario_id uuid PRIMARY KEY REFERENCES public.usuario(id) ON DELETE CASCADE,
    familia_id uuid REFERENCES public.familia(id) ON DELETE CASCADE,
    rol rol_familia DEFAULT 'miembro',
    fecha_creacion timestamptz,
    fecha_actualizacion timestamptz
);

CREATE TABLE public.invitacion_familia (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    familia_id uuid REFERENCES public.familia(id) ON DELETE CASCADE,
    usuario_id uuid REFERENCES public.usuario(id) ON DELETE CASCADE,
    tipo text NOT NULL,
    estado estado_invitacion DEFAULT 'pendiente',
    fecha_creacion timestamptz,
    fecha_actualizacion timestamptz,
    UNIQUE (familia_id, usuario_id)
);

CREATE TABLE public.anuncio_familia (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    familia_id uuid REFERENCES public.familia(id) ON DELETE CASCADE,
    autor_id uuid REFERENCES public.usuario(id) ON DELETE CASCADE,
    contenido text NOT NULL,
    fecha_creacion timestamptz,
    fecha_actualizacion timestamptz
);

-- Sistema de Mensajería y Combate
CREATE TABLE public.cola_misiones (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id uuid REFERENCES public.usuario(id) ON DELETE CASCADE,
    propiedad_origen_id uuid REFERENCES public.propiedad(id),
    tipo_mision tipo_mision NOT NULL,
    tropas jsonb NOT NULL,
    recursos jsonb,
    origen_ciudad integer NOT NULL,
    origen_barrio integer NOT NULL,
    origen_edificio integer NOT NULL,
    destino_ciudad integer NOT NULL,
    destino_barrio integer NOT NULL,
    destino_edificio integer NOT NULL,
    fecha_inicio timestamptz NOT NULL,
    fecha_llegada timestamptz NOT NULL,
    fecha_regreso timestamptz,
    velocidad_flota integer NOT NULL,
    duracion_viaje integer NOT NULL,
    fecha_creacion timestamptz,
    fecha_actualizacion timestamptz
);

CREATE TABLE public.cola_eventos_flota (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    datos jsonb NOT NULL,
    estado text DEFAULT 'en_cola',
    fecha_ejecucion timestamptz,
    fecha_creacion timestamptz
);

CREATE TABLE public.informe_batalla (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    atacante_id uuid REFERENCES public.usuario(id),
    defensor_id uuid REFERENCES public.usuario(id),
    coordenada_ciudad integer NOT NULL,
    coordenada_barrio integer NOT NULL,
    coordenada_edificio integer NOT NULL,
    ganador text NOT NULL,
    detalles jsonb NOT NULL,
    fecha_creacion timestamptz,
    fecha_actualizacion timestamptz
);

CREATE TABLE public.informe_espionaje (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    atacante_id uuid REFERENCES public.usuario(id),
    defensor_id uuid REFERENCES public.usuario(id),
    detalles jsonb NOT NULL,
    fecha_creacion timestamptz,
    fecha_actualizacion timestamptz
);

CREATE TABLE public.mensaje (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    remitente_id uuid REFERENCES public.usuario(id) ON DELETE SET NULL,
    destinatario_id uuid REFERENCES public.usuario(id) ON DELETE CASCADE,
    asunto text NOT NULL,
    contenido text NOT NULL,
    categoria categoria_mensaje DEFAULT 'jugador',
    informe_batalla_id uuid REFERENCES public.informe_batalla(id) ON DELETE SET NULL,
    informe_espionaje_id uuid REFERENCES public.informe_espionaje(id) ON DELETE SET NULL,
    leido boolean DEFAULT false,
    fecha_creacion timestamptz,
    fecha_actualizacion timestamptz
);

CREATE TABLE public.ataque_entrante (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    defensor_id uuid REFERENCES public.usuario(id),
    atacante_id uuid REFERENCES public.usuario(id),
    nombre_atacante text NOT NULL,
    propiedad_objetivo text NOT NULL,
    total_tropas integer NOT NULL,
    fecha_llegada timestamptz NOT NULL,
    mision_id uuid REFERENCES public.cola_misiones(id),
    fecha_creacion timestamptz,
    fecha_actualizacion timestamptz
);
