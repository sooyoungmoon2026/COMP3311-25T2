create table R (
   id       serial,
   name     text,
   d_o_b    date,
   primary key (id)
);

create table S (
    rid     integer,

    foreign key (rid) references R(id)
);