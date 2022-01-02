use master 
go

if exists(select*from sysdatabases where name = 'obligatorio')
begin
drop database obligatorio
end
go
create database obligatorio
go
use  obligatorio
go
create table Periodista
(
   codigoP int primary key,
   nombreP varchar(30)not null,
   email varchar(50)unique not null
  
)
go
create table Ctel
(
  codigoP int  foreign key references periodista(codigoP),
  tel int not null
  primary key(codigoP,tel)
  

)
go
create table Noticia
(
  numNoticia int  identity(1,1)primary key,
  codigoP int foreign key references periodista(codigop)not null,
  fechaC datetime not null check(fechac <getdate()),
  titulo varchar(30)not null,
  Resumen varchar (100),
  Contenido varchar (3000)not null
  


)
go
create table Internacionales
(
 numNoticia int  foreign key references Noticia(numNoticia),
 pais varchar(30)not null,
 primary key (NumNoticia)
  

)
go
create table secciones
(
 codeSec varchar(3) primary key ,
 nombre varchar(30)not null,
 check(codesec like('[A-Z][A-Z][A-Z]'))
)
go
create table Nacionales
(
numNoticia  int foreign key references Noticia(numNoticia),
codeSec varchar(3) foreign key references secciones(codeSec),
primary key(numNoticia)

)
go

insert into Periodista(codigoP,nombreP,email)values (21,'Mateo','unmail@gmail.com')
insert into Periodista(codigoP,nombreP,email)values(22,'Juan','Otromail@gmail.com')
insert into Periodista (codigoP,nombreP,email)values (23,'Persefone','unotromail@gmail.com')
insert into Periodista (codigoP,nombreP,email)values (24,'Eris','comojabon@gmail.com')

insert into Ctel(codigoP,tel)values(21,098329240)
insert into Ctel (codigoP,tel)values (21,099099099)
insert into Ctel(codigoP,tel)values (22,099099098)
insert into Ctel (codigoP,tel)values (23,099088077)

insert into secciones(codeSec,nombre) values('DEP','Deporte')
insert into secciones (codeSec,nombre)values ('POL','Politica')
insert into secciones (codeSec,nombre)values ('ART','ArteYcultura')
insert into secciones(codeSec,nombre)values ('CAM','Rural')

insert into Noticia(codigoP,fechaC,titulo,Resumen,Contenido)
values (21,'19990402','Hola','Resumen','Habiaunavezunbrujitoengururu')
insert into Noticia(codigoP,fechaC,titulo,Resumen,Contenido)
values(21,'20000101','Adios','otroresumen','Primerdiadelmilenio')
insert into Noticia(codigoP,fechaC,titulo,Resumen,Contenido)
values(21,'20190419','Inicio','Otroresumen','CreaciondelMishimashi')
insert into Noticia(codigoP,fechaC,titulo,Resumen,Contenido)
values(24,'20210928','SevieneSinecdoque','resumido','Batata')
insert into noticia(codigoP,fechaC,titulo,Resumen,Contenido)
values (23,'20210928','Eran vegetarianos','la matanza de la cuchilla','troscorozcomolozco')
insert into Noticia(codigoP,fechaC,titulo,Resumen,Contenido)
values(23,'20210928','Los refuerzossondemondiola','casdad','casadsadac')
go


-------------------------------------------------------------------------------------------------------
--A
create Proc EjercicioA
@Numeronoticia int
as
begin
declare @nn int,@ctrle int
select @nn=numNoticia from Noticia where numNoticia=@Numeronoticia
if @nn is null
return -1
begin tran
Delete from Nacionales where numNoticia=@Numeronoticia
set @ctrle=@@ERROR
if @ctrle <>0
begin
rollback tran
return -2
end
delete from Internacionales where numNoticia=@Numeronoticia
set @ctrle=@@error
if @ctrle <>0
begin
rollback tran
return-2
end
Delete from Noticia where numNoticia=@nn
set @ctrle = @@ERROR
if @ctrle<>0
begin
rollback tran 
return -2
end
commit tran 
return 1
end
go


--B


create Proc EjercicioB
@Codes varchar(3),
@NNombre varchar(30)
as
begin
declare @n varchar(3) ,@ctrle int,@a int
select @n=codeSec from secciones where codeSec=@Codes
if @n is null
return	-1
select @a=COUNT(*)from Nacionales where codeSec=@codes
if @a != 0
return -2
update secciones 
set nombre=@NNombre where secciones.codeSec =@Codes
return 1
end
go

--C


create proc EjercicioC
@codigop int,
@fechac datetime,
@titulo varchar(30),
@resumen varchar(100),
@contenido varchar(3000),
@codesec varchar (3)
as
begin
declare @uid int,@b int

if not exists (select*from secciones where codeSec=@codesec)
return -1
if not  exists (select*from Periodista where codigoP=@codigop)
return-2

begin tran
insert into Noticia(codigoP,fechaC,titulo,Resumen,Contenido)
values(@codigop,@fechac,@titulo,@resumen,@contenido)
if @@ERROR <>0
begin
rollback tran
return -4
end
set @uid=IDENT_Current('Noticia')
insert into Nacionales(numNoticia,codeSec)
values( @uid,@codesec)
if @@ERROR<>0
begin
rollback tran
return-5
end
commit tran

return @uid
end
go



--D
create Proc EjercicioD
as
begin
select nombreP as [Nombre Periodista],email as [Email],COUNT(*) as[Total de Noticias] from Noticia
inner join  Periodista on Periodista.codigoP =Noticia.codigoP
group by  nombreP,email
end
go
--E

create Proc EjercicioE
@fechaIni datetime,
@Fechafinit datetime,
@total int output
as
begin
select @total=COUNT(fechac) from Noticia where Noticia.fechaC between @fechaIni and @Fechafinit
end
go
--F

create Proc EjercicioF
as
begin
select fechac as[fecha], nombre as [Nombre Seccion],
COUNT(*)as[Cantidad]
from Noticia inner join Nacionales inner join secciones 
on secciones.codeSec=Nacionales.codeSec on Nacionales.numNoticia=Noticia.numNoticia
group by fechaC,nombre
end
go


/*declare @resultado int
 exec @resultado = EjercicioA 5
 print @resultado*/



/*declare @r int
exec @r= EjercicioB 'art','policiales'
print @r
select * from secciones*/


/*declare @resultado int
exec @resultado=EjercicioC 22,'20210929','Hola','Resumidado','Contenidodeprueba','art'
print @resultado
declare @r int
exec @r=EjercicioC 23,'20210831','adiosito','otroresumenmas','Contenido24','dep'
print @r
declare @b int
exec @b=EjercicioC 23,'20210929','Oxala','Carrea','Lamaitambiencarrea','Art'
print @b
declare @o int
exec @o =EjercicioC 24,'20180731','lawea','faker','cambiocambiaso','camp'
print @o*/
--declare @g int

--exec EjercicioD	 


/*exec EjercicioE '20190419','20210928',@g output
print 'cantidad: '+ convert(varchar,@g) */


--exec EjercicioF--
















