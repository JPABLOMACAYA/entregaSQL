--RESOLUCIÓN EJERCICIOS PARTE 2
--ÍTEM 2.1.

-- CREANDO LA TABLA AUTOR
create table Autor (
	Cod_autor int,
	Nombre_autor varchar(40),
	Nacimiento_annio int,
	Muerte_annio int,
	primary key (Cod_autor)
);

-- CREANDO LA TABLA LIBRO
create table Libro (
	ISBN varchar(15),
	Titulo varchar(50),
	Nro_paginas int,
	Dias_prestamo int,
	primary key (ISBN)
);

-- CREANDO LA TABLA AUTOR_LIBRO
create table Autor_libro (
	ISBN varchar(15),
	Cod_autor int,
	Tipo_autor varchar(9),
	primary key (ISBN, Cod_autor),
	foreign key (ISBN) references Libro(ISBN),
	foreign key (Cod_autor) references Autor(Cod_autor)
);

-- CREANDO LA TABLA SOCIO
create table Socio (
	RUT varchar(10),
	Nombre varchar(40),
	Direccion varchar(25),
	Telefono int,
	primary key (RUT)
);

-- CREANDO LA TABLA HISTORIAL PRÉSTAMO
create table Historial_prestamo (
	ISBN_libro varchar(15),
	RUT_socio varchar(10),
	Fecha_prestamo date,
	Fecha_dev_real date,	
	primary key (ISBN_libro, RUT_socio, Fecha_prestamo),
	foreign key (ISBN_libro) references Libro(ISBN),
	foreign key (RUT_socio) references Socio(RUT)
);

select * from Autor;
select * from Autor_libro;
select * from Libro;
select * from Historial_prestamo;
select * from Socio;

--ÍTEM 2.2.
--INSERTANDO REGISTROS EN LAS TABLAS
insert into Autor values 
	(3, 'Jose Salgado', 1968, 2020),
	(4, 'Ana Salgado', 1972, null),
	(1, 'Andrés Ulloa', 1982, null),
	(2, 'Sergio Mardones', 1950, 2012),	
	(5, 'Martin Porta', 1976, null);

insert into Libro values 
	('111-1111111-111', 'Cuentos de terror', 344, 7),
	('222-2222222-222', 'Poesías contemporaneas', 167, 7),
	('333-3333333-333', 'Historia de Asia', 511, 14),
	('444-4444444-444', 'Manual de mecánica', 298, 14);

insert into Autor_libro values 
	('111-1111111-111', 3, 'Principal'),
	('111-1111111-111', 4, 'Coautor'),	
	('222-2222222-222', 1, 'Principal'),
	('333-3333333-333', 2, 'Principal'),
	('444-4444444-444', 5, 'Principal');

insert into Socio values 
	('1111111-1', 'Juan Soto', 'Avenida 1, Santiago', 911111111),
	('2222222-2', 'Ana Pérez', 'Pasaje 2, Santiago', 922222222),
	('3333333-3', 'Sandra Aguilar', 'Avenida 2, Santiago', 933333333),
	('4444444-4', 'Esteban Jerez', 'Avenida 3, Santiago', 944444444),
	('5555555-5', 'Silvana Muñoz', 'Pasaje 3, Santiago', 955555555);
	
insert into Historial_prestamo values 
	('111-1111111-111', '1111111-1', '2020-01-20', '2020-01-27'),
	('222-2222222-222', '5555555-5', '2020-01-20', '2020-01-30'),
	('333-3333333-333', '3333333-3', '2020-01-22', '2020-01-30'),
	('444-4444444-444', '4444444-4', '2020-01-23', '2020-01-30'),
	('111-1111111-111', '2222222-2', '2020-01-27', '2020-02-04'),
	('444-4444444-444', '1111111-1', '2020-01-31', '2020-02-12'),
	('222-2222222-222', '3333333-3', '2020-01-31', '2020-02-12');  

-- ÍTEM 2.3.a. 
-- Mostrar todos los libros que posean menos de 300 páginas.
select Titulo, Nro_paginas from Libro
	WHERE Nro_paginas < 300;

-- ÍTEM 2.3.b.
-- Mostrar todos los autores que hayan nacido después del 01-01-1970.
select Nombre_autor, Nacimiento_annio from Autor
	where Nacimiento_annio >= '1970'
	order by Nacimiento_annio asc;

-- ÍTEM 2.3.c.
-- ¿Cuál es el libro más solicitado?
select Titulo, (select count(ISBN_libro) as Mas_solicitado) from Historial_prestamo
	join Libro
	on Historial_prestamo.ISBN_libro = Libro.ISBN
	group by Titulo
	order by Mas_solicitado desc;

-- ÍTEM 2.3.d.
-- Si se cobrara una multa de $100 por cada día de atraso, mostrar cuánto 
-- debería pagar cada usuario que entregue el préstamo fuera de plazo.
select Socio.Nombre, (select Fecha_dev_real-(Fecha_prestamo + Libro.Dias_prestamo) as Retraso), 
(select Fecha_dev_real-(Fecha_prestamo + Libro.Dias_prestamo))*100 as Multa_$ from Historial_prestamo
	join Socio on Historial_prestamo.RUT_socio = Socio.RUT
	join Libro on Historial_prestamo.ISBN_libro = Libro.ISBN
	where Fecha_dev_real-(Fecha_prestamo + Libro.Dias_prestamo) > 0
	order by Multa_$ desc;
/*En este último ítem se comprobó que no era necesario tener en la base de datos un atributo "Fecha_devolucion_esperada" en la tabla
"Historial_prestamo", ya que bastó con sumar a "Fecha_prestamo" el atributo "Dias_prestamo" de la tabla "Libro" 
para obtener la fecha de expiración del préstamo y calcular los días de retraso respecto a la devolución real,
siempre que Fecha_dev_real-(Fecha_prestamo + Libro.Dias_prestamo) > 0.
*/