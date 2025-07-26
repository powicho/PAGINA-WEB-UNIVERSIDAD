-- =====================================================================
-- Script para crear la estructura de tablas del Perfil de Usuario
-- Base de Datos: Inesoftware2025
-- Esquema: Perfil
-- Diseñado para coincidir EXACTAMENTE con el ERD proporcionado
-- =====================================================================

-- Seleccionar la base de datos correcta
USE Inesoftware2025;
GO

-- Crear el nuevo esquema si no existe
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'Perfil')
BEGIN
    EXEC('CREATE SCHEMA Perfil');
END
GO

-- ==================================================
-- 1. CREACIÓN DE TABLAS (Sin Foreign Keys aún)
-- Basado en el ERD
-- ==================================================

-- Tablas de Catálogo / Lookup
CREATE TABLE Perfil.PAIS (
    idPaisPK INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    codigo VARCHAR(3) NULL UNIQUE
);
GO

CREATE TABLE Perfil.DEPARTAMENTO (
    idDepartamentoPK INT IDENTITY(1,1) PRIMARY KEY,
    idPaisFK INT NOT NULL, -- FK se añade después
    nombre VARCHAR(100) NOT NULL,
    codigo VARCHAR(10) NULL UNIQUE
);
GO

CREATE TABLE Perfil.MUNICIPIO (
    idMunicipioPK INT IDENTITY(1,1) PRIMARY KEY,
    idDepartamentoFK INT NOT NULL, -- FK se añade después
    nombre VARCHAR(100) NOT NULL
);
GO

CREATE TABLE Perfil.TIPO_DIRECCION (
    idTipoDireccionPK INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
);
GO

CREATE TABLE Perfil.IDIOMA (
    idIdiomaPK INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    codigo VARCHAR(5) NULL UNIQUE
);
GO

-- Tabla Central USUARIO
CREATE TABLE Perfil.USUARIO (
    idUsuarioPK INT IDENTITY(1,1) PRIMARY KEY,
    primer_nombre VARCHAR(100) NOT NULL,
    otros_nombres VARCHAR(100) NULL,
    primer_apellido VARCHAR(100) NOT NULL,
    otros_apellidos VARCHAR(100) NULL,
    usuario_nombre VARCHAR(100) NOT NULL UNIQUE,
    hashed_password VARCHAR(255) NOT NULL,
    profile_image_file_name VARCHAR(255) NULL,
    tipo_usuario VARCHAR(50) NULL,
    idioma_sistema VARCHAR(10) NULL DEFAULT 'es'
);
GO

-- Tablas Particionadas 1 a 1 con USUARIO (PK es también FK)
CREATE TABLE Perfil.USUARIO_DETALLES_PERSONALES (
    idUsuarioPK INT PRIMARY KEY, -- PK y FK a la vez, NO IDENTITY
    nacionalidad VARCHAR(50) NULL,
    genero VARCHAR(30) NULL,
    fecha_nacimiento DATE NULL,
    estado_civil VARCHAR(50) NULL,
    tipo_persona VARCHAR(50) NULL,
    saludo VARCHAR(30) NULL,
    num_hijos INT NULL,
    apellido_casado VARCHAR(100) NULL,
    nombre_conyuge VARCHAR(200) NULL,
    religion VARCHAR(50) NULL,
    tipo_sangre VARCHAR(10) NULL,
    enfermedades_alergias TEXT NULL
);
GO

CREATE TABLE Perfil.USUARIO_DATOS_LEGALES (
    idUsuarioPK INT PRIMARY KEY, -- PK y FK a la vez, NO IDENTITY
    dpi_number VARCHAR(20) NULL,
    dpi_file_name VARCHAR(255) NULL,
    fe_edad_number VARCHAR(50) NULL,
    fe_edad_file_name VARCHAR(255) NULL,
    pasaporte_number VARCHAR(50) NULL,
    pasaporte_file_name VARCHAR(255) NULL,
    cedula_number VARCHAR(50) NULL,
    cedula_file_name VARCHAR(255) NULL,
    rtu_file_name VARCHAR(255) NULL,
    nit VARCHAR(20) NULL,
    tipo_licencia VARCHAR(50) NULL,
    regimen_tributario VARCHAR(100) NULL,
    igss VARCHAR(50) NULL,
    num_seguro VARCHAR(50) NULL
);
GO

CREATE TABLE Perfil.USUARIO_PERFIL_ACADEMICO (
    idUsuarioPK INT PRIMARY KEY, -- PK y FK a la vez, NO IDENTITY
    carne_actual VARCHAR(30) NULL,
    otros_carne TEXT NULL,
    estudia_actualmente_bool BIT NULL,
    estudia_que VARCHAR(200) NULL,
    estudia_lugar VARCHAR(200) NULL,
    estudia_horario VARCHAR(100) NULL,
    ultimo_grado VARCHAR(100) NULL,
    colegiado_activo VARCHAR(50) NULL,
    cv_file_name VARCHAR(255) NULL
);
GO

-- Tablas Relacionadas 1 a Muchos con USUARIO
CREATE TABLE Perfil.DIRECCION (
    idDireccionPK INT IDENTITY(1,1) PRIMARY KEY,
    idUsuarioFK INT NOT NULL,
    idTipoDireccionFK INT NOT NULL,
    direccion VARCHAR(255) NOT NULL,
    zona VARCHAR(50) NULL,
    idMunicipioFK INT NOT NULL
);
GO

CREATE TABLE Perfil.TELEFONO (
    idTelefonoPK INT IDENTITY(1,1) PRIMARY KEY,
    idUsuarioFK INT NOT NULL,
    numero VARCHAR(30) NOT NULL,
    es_principal BIT NOT NULL DEFAULT 0
);
GO

CREATE TABLE Perfil.CORREO_ELECTRONICO (
    idCorreoElectronicoPK INT IDENTITY(1,1) PRIMARY KEY,
    idUsuarioFK INT NOT NULL,
    correo VARCHAR(255) NOT NULL,
    es_principal BIT NOT NULL DEFAULT 0
);
GO

CREATE TABLE Perfil.CONTACTO_EMERGENCIA (
    idContactoEmergenciaPK INT IDENTITY(1,1) PRIMARY KEY,
    idUsuarioFK INT NOT NULL,
    nombre VARCHAR(200) NOT NULL,
    relacion VARCHAR(100) NULL,
    telefonos VARCHAR(100) NULL
);
GO

CREATE TABLE Perfil.VEHICULO (
    idVehiculoPK INT IDENTITY(1,1) PRIMARY KEY,
    idUsuarioFK INT NOT NULL,
    placa VARCHAR(10) NOT NULL,
    marca VARCHAR(50) NULL,
    modelo VARCHAR(50) NULL,
    color VARCHAR(30) NULL
);
GO

CREATE TABLE Perfil.USUARIO_IDIOMA (
    idUsuarioIdiomaPK INT IDENTITY(1,1) PRIMARY KEY,
    idUsuarioFK INT NOT NULL,
    idIdiomaFK INT NOT NULL,
    nivel_escrito INT NULL CHECK (nivel_escrito BETWEEN 0 AND 100),
    nivel_hablado INT NULL CHECK (nivel_hablado BETWEEN 0 AND 100)
);
GO

CREATE TABLE Perfil.TITULO_ACADEMICO (
    idTituloAcademicoPK INT IDENTITY(1,1) PRIMARY KEY,
    idUsuarioFK INT NOT NULL,
    nombre_archivo VARCHAR(255) NOT NULL,
    descripcion VARCHAR(200) NULL
);
GO

-- ==================================================
-- 2. CREACIÓN DE FOREIGN KEYS (ALTER TABLE)
-- Usando los nombres exactos del ERD
-- ==================================================

-- FKs en Tablas de Catálogo / Lookup
ALTER TABLE Perfil.DEPARTAMENTO
ADD CONSTRAINT FK_Departamento_Pais FOREIGN KEY (idPaisFK) REFERENCES Perfil.PAIS(idPaisPK);
GO

ALTER TABLE Perfil.MUNICIPIO
ADD CONSTRAINT FK_Municipio_Departamento FOREIGN KEY (idDepartamentoFK) REFERENCES Perfil.DEPARTAMENTO(idDepartamentoPK);
GO

-- FKs en Tablas Particionadas (Relación 1 a 1 con Usuario)
ALTER TABLE Perfil.USUARIO_DETALLES_PERSONALES
ADD CONSTRAINT FK_DetallesPersonales_Usuario FOREIGN KEY (idUsuarioPK) REFERENCES Perfil.USUARIO(idUsuarioPK);
GO

ALTER TABLE Perfil.USUARIO_DATOS_LEGALES
ADD CONSTRAINT FK_DatosLegales_Usuario FOREIGN KEY (idUsuarioPK) REFERENCES Perfil.USUARIO(idUsuarioPK);
GO

ALTER TABLE Perfil.USUARIO_PERFIL_ACADEMICO
ADD CONSTRAINT FK_PerfilAcademico_Usuario FOREIGN KEY (idUsuarioPK) REFERENCES Perfil.USUARIO(idUsuarioPK);
GO

-- FKs en Tablas 1 a Muchos
ALTER TABLE Perfil.DIRECCION
ADD CONSTRAINT FK_Direccion_Usuario FOREIGN KEY (idUsuarioFK) REFERENCES Perfil.USUARIO(idUsuarioPK);
GO
ALTER TABLE Perfil.DIRECCION
ADD CONSTRAINT FK_Direccion_TipoDireccion FOREIGN KEY (idTipoDireccionFK) REFERENCES Perfil.TIPO_DIRECCION(idTipoDireccionPK);
GO
ALTER TABLE Perfil.DIRECCION
ADD CONSTRAINT FK_Direccion_Municipio FOREIGN KEY (idMunicipioFK) REFERENCES Perfil.MUNICIPIO(idMunicipioPK);
GO

ALTER TABLE Perfil.TELEFONO
ADD CONSTRAINT FK_Telefono_Usuario FOREIGN KEY (idUsuarioFK) REFERENCES Perfil.USUARIO(idUsuarioPK);
GO

ALTER TABLE Perfil.CORREO_ELECTRONICO
ADD CONSTRAINT FK_Correo_Usuario FOREIGN KEY (idUsuarioFK) REFERENCES Perfil.USUARIO(idUsuarioPK);
GO
-- Posible UNIQUE constraint para correo (opcional, descomentar si se necesita)
-- ALTER TABLE Perfil.CORREO_ELECTRONICO ADD CONSTRAINT UQ_Correo UNIQUE (correo);
-- GO

ALTER TABLE Perfil.CONTACTO_EMERGENCIA
ADD CONSTRAINT FK_ContactoEmergencia_Usuario FOREIGN KEY (idUsuarioFK) REFERENCES Perfil.USUARIO(idUsuarioPK);
GO

ALTER TABLE Perfil.VEHICULO
ADD CONSTRAINT FK_Vehiculo_Usuario FOREIGN KEY (idUsuarioFK) REFERENCES Perfil.USUARIO(idUsuarioPK);
GO
-- Posible UNIQUE constraint para placa (opcional, descomentar si se necesita)
-- ALTER TABLE Perfil.VEHICULO ADD CONSTRAINT UQ_Vehiculo_Placa UNIQUE (placa);
-- GO

ALTER TABLE Perfil.USUARIO_IDIOMA
ADD CONSTRAINT FK_UsuarioIdioma_Usuario FOREIGN KEY (idUsuarioFK) REFERENCES Perfil.USUARIO(idUsuarioPK);
GO
ALTER TABLE Perfil.USUARIO_IDIOMA
ADD CONSTRAINT FK_UsuarioIdioma_Idioma FOREIGN KEY (idIdiomaFK) REFERENCES Perfil.IDIOMA(idIdiomaPK);
GO
-- Posible UNIQUE constraint para combinación usuario-idioma (opcional, descomentar si se necesita)
-- ALTER TABLE Perfil.USUARIO_IDIOMA ADD CONSTRAINT UQ_Usuario_Idioma UNIQUE (idUsuarioFK, idIdiomaFK);
-- GO

ALTER TABLE Perfil.TITULO_ACADEMICO
ADD CONSTRAINT FK_TituloAcademico_Usuario FOREIGN KEY (idUsuarioFK) REFERENCES Perfil.USUARIO(idUsuarioPK);
GO

PRINT 'Estructura de tablas del esquema Perfil creada exitosamente en Inesoftware2025, coincidiendo con el ERD.';
GO
-- =====================================================================
-- FIN DEL SCRIPT
-- =====================================================================