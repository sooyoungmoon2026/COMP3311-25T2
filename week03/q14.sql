create table Car (
    regoNo  char(6),
    model   text,
    year    integer
)

create table Person (
    licenceNo   integer,
    name        text,
    address     text
)

create table Accident (
    reportNo    integer,
    location    text,
    occuredAt   date
)

create table Owns (
    car     char(6) references Car(regoNo),
    person  integer references Person(licenceNo),

    primary key (car,person)
)

create table Involved (
    car         char(6) references Car(regoNo),
    person      integer references Person(licenceNo),
    accident    integer references Accident(reportNo),

    damage      Numeric,

    primary key (car,person,accident)
)
