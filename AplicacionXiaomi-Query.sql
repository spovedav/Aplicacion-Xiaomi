Create Database db_AplicacionXiaomi
use db_AplicacionXiaomi
go

--LOGIN DE ADMNISTRACION
--CREATE table AdministracionLogin(Id int primary key identity,Correo_ varchar(50) not null, Password_ varchar(100) not null , FechaCreacion datetime, FechaUpdate datetime )
CREATE table AdministracionLogin(Id int primary key identity,Correo_ varchar(50) not null, Password_ varchar(100) not null , Rol int, FechaCreacion datetime, FechaUpdate datetime )
	--drop table AdministracionLogin
	--insert into AdministracionLogin(Correo_,Password_,Rol,FechaCreacion,FechaUpdate) values ('sp@yahoo.com','fbc71ce36cc20790f2eeed2197898e71',1, SYSDATETIME(),SYSDATETIME())
	--select * from AdministracionLogin
	--fbc71ce36cc20790f2eeed2197898e71
go

--CREATE table Roles(Id int primary key identity, NombreRoles varchar(50), FechaCreacion datetime)
--insert into Roles(NombreRoles,FechaCreacion) values ('Admin', SYSDATETIME())
--insert into Roles(NombreRoles,FechaCreacion) values ('Cliente',SYSDATETIME())
go

--TABLA DE PRODUCTOS
Create table Productos(Id int primary key identity, NombreProducto varchar(50) not null, Precio varchar(20), Imagen varchar(max), Stock int not null, Descripcion varchar(max), IdentificarAdministrador varchar(50), TipoProducto int, FechaInsert date, FechaUpdate date )
	--drop table Productos
	--select * from Productos
	--truncate table Productos 
insert into Productos(NombreProducto,Precio,Imagen,Stock,Descripcion,IdentificarAdministrador,TipoProducto,FechaInsert,FechaUpdate) values ('Xiomi Redmi Note 8Pro','299.99','~/Imagen/2020/xiaomiNote8.jpg',20,'Cammara 64px %% Bateria 4500bt %% Color: Blanco, Negro, Verde','sp@yahoo.com',1,GETDATE(), GETDATE())    
go

create table Categorias(Id int primary key identity, NombreCategoria varchar(200), FechaCreacion date) 
	---drop table Categorias
	---truncate table Categorias
	--insert into Categorias(NombreCategoria,FechaCreacion) values ('Celular',GETDATE())
	--insert into Categorias(NombreCategoria,FechaCreacion) values ('Tv',GETDATE())
	--insert into Categorias(NombreCategoria,FechaCreacion) values ('Laptops',GETDATE())

	--select * from Categorias
go


--------------------------------------------
-- VISTAS --
CREATE view View_Productos
as
	select p.Id, P.NombreProducto,P.Precio,P.Imagen,P.Stock,P.Descripcion,P.IdentificarAdministrador,C.NombreCategoria AS Categoria,P.FechaInsert from Productos as p inner join Categorias c on p.TipoProducto = c.Id 



--------------------------------------------
-- STORED PROCEDURE --

--AGREGAR UN NUEVO PRODUCTO
create proc sp_View_Productos_Id (@Id int)
as
		select p.Id, P.NombreProducto,P.Precio,P.Imagen,P.Stock,P.Descripcion,P.IdentificarAdministrador,C.NombreCategoria AS Categoria,P.FechaInsert from Productos as p inner join Categorias c on p.TipoProducto = c.Id  where p.Id = @Id

exec  sp_View_Productos_Id 3

create proc sp_AgregarProducto  @NombreProducto varchar(50), 
								@Precio varchar(20),
								@Stok int,
								@Imagen varchar(max),
								@Descripcion varchar(max),
								@IdentifiarAdministrador varchar(50),
								@TipoProducto int
AS
	declare @mensaje varchar(100); 
	IF NOT EXISTS (select * from Productos where NombreProducto = @NombreProducto)
		BEGIN
			insert into Productos(NombreProducto,Precio,Imagen,Stock,Descripcion,IdentificarAdministrador,TipoProducto,FechaInsert,FechaUpdate) values 
								 (@NombreProducto,@Precio,@Imagen,@Stok,@Descripcion,@IdentifiarAdministrador,@TipoProducto,GETDATE(),GETDATE())	
			set @mensaje = 'Se agrego un nuevo Producto'
		END
	ELSE
		BEGIN
			set @mensaje = 'Ya Existe un Producto con ese Nombre'
		END
	select @mensaje	
GO


--ACTUALIZAR UN NUEVO PRODUCTO
create proc sp_ActualizarProducto  @Id int,
								   @NombreProducto varchar(50), 
								   @Precio varchar(20),
								   @Stok int,
								   @Imagen varchar(max),
								   @Descripcion varchar(max),
								   @IdentifiarAdministrador varchar(50),
								   @TipoProducto int
AS
	declare @mensaje varchar(100); 
	IF EXISTS (select * from Productos where Id = @Id)
		BEGIN
			UPDATE Productos set NombreProducto = @NombreProducto , Precio = @Precio , Imagen = @Imagen , Stock = @Stok, Descripcion = @Descripcion , IdentificarAdministrador = @IdentifiarAdministrador, 
			TipoProducto = @TipoProducto , FechaUpdate = GETDATE() WHERE Id = @Id
			set @mensaje = 'Se Actualizo un nuevo Producto'
		END
	ELSE
		BEGIN
			set @mensaje = 'No se encontro un Registro'
		END
	select @mensaje	
GO


--ELIMINAR UN PRODUCTO
create proc sp_EliminarProducto @Id int
AS
	declare @mensaje varchar(100)
	IF EXISTS(select * from Productos where Id = @Id)
		begin
			delete from Productos where Id = @Id
			set @mensaje = 'Se elimino un Producto'
		end
	ELSE
		BEGIN
			set @mensaje = 'No hay registro con ese Codigo'
		END
	select @mensaje
go