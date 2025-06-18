create table Person (
    addressNo   integer,
    street      varchar(40),
    suburb      varchar(30),
    first       varchar(30),
    initial     char(1),
    family      varchar(30),
    birthdate   date,
    primary key (first, initial, family)
)

char(8)
varchar(8)
text