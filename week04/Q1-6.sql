create table Employees (
      eid     integer,
      ename   text,
      age     integer,
      salary  real check (salary >= 15000),
      primary key (eid)
);

create table Departments (
      did     integer,
      dname   text,
      budget  real,
      manager integer not null default 0 references Employees(eid) on delete set default,
      primary key (did)
);

create table WorksIn (
      eid     integer references Employees(eid) on delete cascade,
      did     integer references Departments(did) on delete cascade,
      percent real,
      primary key (eid,did),
      constraint MaxTime check (
        (select 
            sum(percent)
        from WorksIn W
        where eid = W.eid) <= 1
      )
);

update 
    Employees
set 
    salary = salary * 0.8
where
    age < 25
;

-- 2
update Employees set salary = salary * 0.8
where age < 25;

-- 3
update 
    Employees E
set
    E.salary = E.salary * 1.1
where E.eid in (
    select
        W.eid
    from
        WorksIn W, Departments D
    where
        W.did = D.did and D.dname = 'Sales'
)


-- Two ways to join two tables
select
    W.eid
from
    WorksIn W, Departments D
where
    W.did = D.did and D.dname = 'Sales'

select
    W.eid
from
    WorksIn W join Departments D on (W.did = D.did)
where 
    D.dname = 'Sales'