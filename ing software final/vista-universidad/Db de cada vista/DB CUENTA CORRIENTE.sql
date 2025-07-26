Create Database Inesoftware2025;

--Crear las tablas
-----------------------------------------------------------------------------------------------------------
-- Tabla: Usuario 
CREATE TABLE Usuario (
    idUsuarioPK INT NOT NULL IDENTITY(1,1),
    nombreCompleto      VARCHAR(50),
    Carne              VARCHAR(50),
    Campus             VARCHAR(50),
    Jornada            VARCHAR(50),
    ModeloVistaUsuario VARCHAR(50),
);
-----------------------------------------------------------------------------------------------------------
-- Tabla: Tarjeta 
CREATE TABLE Tarjeta (
    idTarjetaPK INT NOT NULL IDENTITY(1,1),
    idUsuarioFK INT,
    numeroTarjeta   VARCHAR(16),
    cvv             CHAR(3),
    fechaExpiracion DATE,
);
-----------------------------------------------------------------------------------------------------------
-- Tabla: Estado_cuenta 
CREATE TABLE Estado_cuenta (
    idEstadoCuentaPK INT NOT NULL IDENTITY(1,1),
    idUsuarioFK INT,
    fechaConsulta  DATE,
    Observaciones  VARCHAR(50),
);
-----------------------------------------------------------------------------------------------------------
-- Tabla: Cuota 
CREATE TABLE Cuota (
    idCuotaPK INT NOT NULL IDENTITY(1,1),
    idUsuarioFK INT,
    FechaVencimiento DATE,
    Monto           DECIMAL(10,2),
    mora            DECIMAL(10,2),
);
-----------------------------------------------------------------------------------------------------------
-- Tabla: Pago_Tarjeta 
-- 'idBanco' es un entero informativo (sin FK)
CREATE TABLE Pago_Tarjeta (
    idPagoPK INT NOT NULL IDENTITY(1,1),
    idBanco       INT,
    idUsuarioFK   INT,
    idTarjetaFK   INT,
    monto         DECIMAL(10,2),
    Fecha_pago    DATE,
    Monto_estipulado DECIMAL(10,2),
);
-----------------------------------------------------------------------------------------------------------
-- Tabla: Detalle_Pago 
-- 'idBanco' es un entero informativo (sin FK)
CREATE TABLE Detalle_Pago (
    idDetallePagoPK INT NOT NULL IDENTITY(1,1),
    idPagoFK   INT,
    idBanco    INT,
    Fecha_pago DATE,
    Descripcion  VARCHAR(100),
    montoParcial DECIMAL(10,2),
    estado       VARCHAR(20),
);
-----------------------------------------------------------------------------------------------------------
-- Tabla: Detalle_Pago_Cuota 
CREATE TABLE Detalle_Pago_Cuota (
    idDetallePagoCuotaPK INT NOT NULL IDENTITY(1,1),
    idDetallePagoFK INT,
    idCuotaFK       INT,
    Fecha_pago      DATE,
);
--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
-- 4) Agregar las PK con ALTER TABLE
--------------------------------------------------------------------------------------------------------------
-- Usuario
ALTER TABLE Usuario
ADD CONSTRAINT PK_Usuario
PRIMARY KEY (idUsuarioPK);
--------------------------------------------------------------------------------------------------------------
-- Tarjeta
ALTER TABLE Tarjeta
ADD CONSTRAINT PK_Tarjeta
PRIMARY KEY (idTarjetaPK);
--------------------------------------------------------------------------------------------------------------
-- Estado_cuenta
ALTER TABLE Estado_cuenta
ADD CONSTRAINT PK_EstadoCuenta
PRIMARY KEY (idEstadoCuentaPK);
--------------------------------------------------------------------------------------------------------------
-- Cuota
ALTER TABLE Cuota
ADD CONSTRAINT PK_Cuota
PRIMARY KEY (idCuotaPK);
--------------------------------------------------------------------------------------------------------------
-- Pago_Tarjeta
ALTER TABLE Pago_Tarjeta
ADD CONSTRAINT PK_PagoTarjeta
PRIMARY KEY (idPagoPK);
--------------------------------------------------------------------------------------------------------------
-- Detalle_Pago
ALTER TABLE Detalle_Pago
ADD CONSTRAINT PK_Detalle_Pago
PRIMARY KEY (idDetallePagoPK);
--------------------------------------------------------------------------------------------------------------
-- Detalle_Pago_Cuota
ALTER TABLE Detalle_Pago_Cuota
ADD CONSTRAINT PK_Detalle_Pago_Cuota
PRIMARY KEY (idDetallePagoCuotaPK);
--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
--Agregar las FOREIGN KEY
--------------------------------------------------------------------------------------------------------------
--Usuario -> Tarjeta (Tarjeta es hija)
ALTER TABLE Tarjeta
ADD CONSTRAINT FK_Tarjeta_Usuario
    FOREIGN KEY (idUsuarioFK)
    REFERENCES Usuario (idUsuarioPK);

--------------------------------------------------------------------------------------------------------------
--Usuario -> Estado_cuenta (Estado_cuenta es hija)
ALTER TABLE Estado_cuenta
ADD CONSTRAINT FK_EstadoCuenta_Usuario
    FOREIGN KEY (idUsuarioFK)
    REFERENCES Usuario (idUsuarioPK);

--------------------------------------------------------------------------------------------------------------
--Usuario -> Cuota (Cuota es hija)
ALTER TABLE Cuota
ADD CONSTRAINT FK_Cuota_Usuario
    FOREIGN KEY (idUsuarioFK)
    REFERENCES Usuario (idUsuarioPK);

--------------------------------------------------------------------------------------------------------------
--Usuario -> Pago_Tarjeta (Pago_Tarjeta es hija)
ALTER TABLE Pago_Tarjeta
ADD CONSTRAINT FK_PagoTarjeta_Usuario
    FOREIGN KEY (idUsuarioFK)
    REFERENCES Usuario (idUsuarioPK);

--------------------------------------------------------------------------------------------------------------
--Tarjeta -> Pago_Tarjeta (Pago_Tarjeta es hija)
ALTER TABLE Pago_Tarjeta
ADD CONSTRAINT FK_PagoTarjeta_Tarjeta
    FOREIGN KEY (idTarjetaFK)
    REFERENCES Tarjeta (idTarjetaPK);

--------------------------------------------------------------------------------------------------------------
--Pago_Tarjeta -> Detalle_Pago (Detalle_Pago es hija)
ALTER TABLE Detalle_Pago
ADD CONSTRAINT FK_DetallePago_PagoTarjeta
    FOREIGN KEY (idPagoFK)
    REFERENCES Pago_Tarjeta (idPagoPK);

--------------------------------------------------------------------------------------------------------------
--Cuota -> Detalle_Pago_Cuota (Detalle_Pago_Cuota es hija)
ALTER TABLE Detalle_Pago_Cuota
ADD CONSTRAINT FK_DetallePagoCuota_Cuota
    FOREIGN KEY (idCuotaFK)
    REFERENCES Cuota (idCuotaPK);

--------------------------------------------------------------------------------------------------------------
--Detalle_Pago -> Detalle_Pago_Cuota (Detalle_Pago_Cuota es hija)
ALTER TABLE Detalle_Pago_Cuota
ADD CONSTRAINT FK_DetallePagoCuota_DetallePago
    FOREIGN KEY (idDetallePagoFK)
    REFERENCES Detalle_Pago (idDetallePagoPK);
--------------------------------------------------------------------------------------------------------------
Select * From dbo.Cuota
Select * From dbo.Detalle_Pago
Select * From dbo.Detalle_Pago_Cuota
Select * From dbo.Estado_cuenta
Select * From dbo.Pago_Tarjeta
Select * From dbo.Tarjeta
Select * From dbo.Usuario