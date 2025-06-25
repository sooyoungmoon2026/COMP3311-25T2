create table Suppliers (
      sid     integer primary key,
      sname   text,
      address text
);

create table Parts (
      pid     integer primary key,
      pname   text,
      colour  text
);

create table Catalog (
      sid     integer references Suppliers(sid),
      pid     integer references Parts(pid),
      cost    real,
      primary key (sid,pid)
);

-- Find the names of suppliers who supply some red part.
select
    distinct sname
from
    Suppliers S
join
    Catalog C on (C.sid = S.sid)
join
    Parts P on (P.pid = C.pid)
where
    P.colour = 'red'
;

-- Find the sids of suppliers who supply some red or green part.
select
    distinct S.sid
from
    Suppliers S
join
    Catalog C on (C.sid = S.sid)
join
    Parts P on (P.pid = C.pid)
where
    P.colour = 'red' or P.colour = 'green'
;

-- Find the sids of suppliers who supply some red part or whose address is 221 Packer Street.
select
    distinct S.sid
from
    Suppliers S
join
    Catalog C on (C.sid = S.sid)
join
    Parts P on (P.pid = C.pid)
where
    P.colour = 'red' or S.address = '221 Packer Street'
;

-- Find the sids of suppliers who supply some red part and some green part.
(select
    distinct S.sid
from
    Suppliers S
join
    Catalog C on (C.sid = S.sid)
join
    Parts P on (P.pid = C.pid)
where
    P.colour = 'red')
intersect
(select
    distinct S.sid
from
    Suppliers S
join
    Catalog C on (C.sid = S.sid)
join
    Parts P on (P.pid = C.pid)
where
    P.colour = 'green')

select
    distinct S.sid
from
    Suppliers S
join
    Catalog C on (C.sid = S.sid)
join
    Parts P on (P.pid = C.pid)
where
    P.colour = 'red' and exists (
        select 
            *
        from
            Suppliers S1
        join
            Catalog C1 on (C1.sid = S1.sid)
        join
            Parts P1 on (P1.pid = C1.pid)
        where P.colour = 'green' and S1.sid = S.sid 
    )

-- Find the sids of suppliers who supply every part.

select 
    S.sid
from
    Suppliers S
join
    Catalog C on (C.sid = S.sid)
join
    Parts P on (P.pid = C.pid);
group by S.sid
having count(distinct P.pid) = (select count(pid) from Parts)
;

select 
    S.sid
from
    Suppliers S
where not exists (
    (select P.pid from Parts P)
    except 
    (select C.pid from Catalog C where C.sid = S.sid)
)
;

-- Find the sids of suppliers who supply every red part.
select 
    S.sid
from
    Suppliers S
where not exists (
    (select P.pid from Parts P where P.colour = 'red')
    except 
    (select C.pid from Catalog C where C.sid = S.sid)
)
;

-- Find the sids of suppliers who supply every red or green part.
(select 
    S.sid
from
    Suppliers S
where not exists (
    (select P.pid from Parts P where P.colour = 'red')
    except 
    (select C.pid from Catalog C where C.sid = S.sid)
))
union
(select 
    S.sid
from
    Suppliers S
where not exists (
    (select P.pid from Parts P where P.colour = 'green')
    except 
    (select C.pid from Catalog C where C.sid = S.sid)
))
;