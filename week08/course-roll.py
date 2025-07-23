#!/usr/bin/env python3

import sys
import psycopg2

if len(sys.argv) != 3:
    print('Usage: course-roll subject term')
    exit(1)

subj, term = sys.argv[1:]

conn = None
try:
    conn = psycopg2.connect("dbname=uni")
    cur = conn.cursor()

    print(subj, term)

    cur.execute('''
        select P.id, P.family, P.given from Course_enrolments CE
        join Courses CS on (CS.id = CE.course)
        join Subjects S on (S.id = CS.subject)
        join Terms T on (T.id = CS.term)
        join People P on (P.id = CE.student)
        where S.code = %s and T.code = %s
        order by P.family, P.given
    ''', (subj, term))

    resultList = cur.fetchall()

    if len(resultList) == 0:
        print('No students')
        exit(0)

    for pId, family, given in resultList:
        print(pId, family + ', ' + given)

except Exception as e:
    print('DB error: ', e)
    exit(1)
finally:
    if conn is not None:
        conn.close()