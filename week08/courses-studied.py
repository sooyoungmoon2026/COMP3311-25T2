#!/usr/bin/env python3

import sys
import psycopg2

if len(sys.argv) != 3:
    print("Usage: ./courses-studied studentID term")
    exit(1)

sId, term = sys.argv[1:]
conn = None

try:
    conn = psycopg2.connect("dbname=uni")
    cur = conn.cursor()

    cur.execute("select * from Students where id = %s", (sId,))
    if not cur.fetchone():
        print("No such student")
        exit(0)

    cur.execute('''
        select S.code, S.name from Course_enrolments CE
        join Courses CS on (CS.id = CE.course)
        join Subjects S on (S.id = CS.subject)
        join Terms T on (T.id = CS.term)
        where CE.student = %s and T.code = %s
        order by S.code
    ''', (sId, term))

    for code, name in cur.fetchall():
        print(code, name)

except Exception as e:
    print('DB error: ', e)
    exit(1)
finally:
    if conn is not None:
        conn.close()
