use master
GO

create database DB_Solucion
go

use DB_Solucion
go

select * from PRODUCTO
GO

---Registro de Tablas

create table CATEGORIA(
IdCategoria int primary key identity,
Descripcion varchar(100),
Activo bit default 1,
FechaRegistro datetime default getdate()
)
go

create table MARCA(
IdMarca int primary key identity,
Descripcion varchar(100),
Activo bit default 1,
FechaRegistro datetime default getdate()
)
go


create table PRODUCTO(
IdProducto int primary key identity,
Nombre varchar(500),
Descripcion varchar (500),
IdMarca int references MARCA(IdMarca),
IdCategoria int references CATEGORIA(IdCategoria),
Precio decimal(10,2)default 0,
Stock int,
RutaImagen varchar(100),
NombreImagen varchar(100),
Activo bit default 1,
FechaRegistro datetime default getdate()
)


create table CLIENTE(
IdCliente int primary key identity,
Nombres varchar(100),
Apellidos varchar(100),
Correo varchar(100),
Clave varchar(150),
Reestablecer bit default 0,
FechaRegistro datetime default getdate()
)
go

create table CARRITO(
IdCarrito int primary key identity,
IdCliente int references CLIENTE(IdCliente),
IdProducto int references PRODUCTO(IdProducto),
Cantidad int
)
go

create table VENTA(
IdVenta int primary key identity,
IdCliente int references CLIENTE(IdCliente),
TotalProducto int,
MontoTotal decimal(10,2),
Contacto varchar(50),
IdDistrito varchar(10),
Telefono varchar(50),
Direccion varchar(500),
IdTransaccion varchar(50),
FechaVenta datetime default getdate()
)
go


create table DETALLE_VENTA(
IdDetalleventa int primary key identity,
IdVenta int references VENTA(IdVenta),
IdProducto int references PRODUCTO(IdProducto),
Cantidad int,
Total decimal(10,2)
)
go


create table USUARIO(
IdUsuario int primary key identity,
Nombres varchar(100),
Apellidos varchar(100),
Correo varchar(100),
Clave varchar(150),
Reestablecer bit default 1,
Activo bit default 1,
FechaRegistro datetime default getdate()
)
go


/*--- Procedimientos de Almacenado ---*/

--- LISTAR PRODUCTOS
CREATE OR ALTER PROC usp_productos
AS
BEGIN
    SELECT 
        p.IdProducto,
        p.Nombre,
        p.Descripcion,
        m.Descripcion AS Marca,
        c.Descripcion AS Categoria,
        p.Precio,
        p.Stock,
        p.RutaImagen,
        p.NombreImagen,
        p.Activo
    FROM 
        PRODUCTO p 
        JOIN MARCA m ON p.IdMarca = m.IdMarca
        JOIN CATEGORIA c ON p.IdCategoria = c.IdCategoria
    ORDER BY 
        p.Nombre ASC;
END;
GO


--- FILTRAR PRODUCTOS
CREATE OR ALTER PROC usp_filtrar_productos
    @Nombre VARCHAR(500)
AS
BEGIN
    SELECT 
        p.IdProducto,
        p.Nombre,
        p.Descripcion,
        m.Descripcion AS Marca,
        c.Descripcion AS Categoria,
        p.Precio,
        p.Stock,
        p.RutaImagen,
        p.NombreImagen,
        p.Activo
    FROM 
        PRODUCTO p 
        JOIN MARCA m ON p.IdMarca = m.IdMarca
        JOIN CATEGORIA c ON p.IdCategoria = c.IdCategoria
    WHERE 
        p.Nombre LIKE @Nombre + '%';

END;
GO


/* --- Insert Values --- */

-- Insertar valores de ejemplo (puedes ajustar según tus necesidades)
-- Insertar valores en la tabla CATEGORIA
INSERT INTO CATEGORIA (Descripcion) 
VALUES	('Entradas'),
		('Plato Principal'),
		('Postres');
GO

-- Insertar valores en la tabla MARCA
INSERT INTO MARCA (Descripcion) 
VALUES	('Restaurante Mariscos Sabor del Mar'),
		('Asador Criollo'),
		('Dulces Delicias');
GO

-- Insertar valores en la tabla PRODUCTO
INSERT INTO PRODUCTO (Nombre, Descripcion, IdMarca, IdCategoria, Precio, Stock, RutaImagen, NombreImagen, Activo)
VALUES 
    ('Ceviche', 'Plato de pescado crudo marinado en limón', 1, 1, 20.99, 50, 'ceviche.jpg', 'ceviche_img', 1),
    ('Lomo Saltado', 'Salteado de carne de res con verduras y papas fritas', 2, 1, 25.50, 40, 'lomo-saltado.jpg', 'lomo_img', 1),
    ('Mazamorra Morada', 'Postre a base de maíz morado', 3, 3, 10.99, 20, 'mazamorra-morada.jpg', 'mazamorra_img', 1);
GO

EXEC usp_productos
GO
