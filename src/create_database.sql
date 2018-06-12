create database Bluedit;
go
use Bluedit;

create table User(
    ID integer primary key identity(1, 1),
    UserName varchar(100) not null,
    CreatedDate datetime not null,
    PasswordSalt varbinary(max) not null,
    PasswordHash varbinary(max) not null
);

go

create table Post(
    ID integer primary key identity(1, 1),
    Text varchar(1000) not null,
    CreatedBy integer foreign key references User(ID),
    CreatedDate datetime not null,
    ParentPost integer null foreign key references Post(ID)
);

go

create trigger PostCreate 
on Post
instead of insert
AS
begin
    insert into Post(Text, CreatedBy, CreatedDate, ParentPost)
    select Text, CreatedBy, GETDATE(), ParentPost
    from inserted
end

go

create trigger UserCreate 
on User
instead of insert
AS
begin
    insert into User(UserName, CreatedDate, PasswordSalt, PasswordHash)
    select UserName, GETDATE(), PasswordSalt, PasswordHash
    from inserted
end