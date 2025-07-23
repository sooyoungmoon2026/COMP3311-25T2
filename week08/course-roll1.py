#!/usr/bin/env python3

import sys
import psycopg2

if len(sys.argv) != 3:
    print('Usage: course-roll1 subject term')
    exit(1)

subj, term = sys.argv[1:]

conn = None
try:
    conn = psycopg2.connect("dbname=uni")
    cur = conn.cursor()

    cur.execute("select id, name from Subjects where code = %s", (subj,))
    result = cur.fetchone()
    if not result:
        print("Invalid subject", subj)
        exit(0)
    subjectId, subjectName = result
    
    cur.execute("select id from Terms where code = %s", (term,))
    result = cur.fetchone()
    if not result:
        print("Invalid term", term)
        exit(0)
    termId = result[0]

    cur.execute("select id from Courses where subject = %s and term = %s", (subjectId, termId))
    result = cur.fetchone()
    if not result:
        print("No offering:", subj, term)
        exit(0)
    courseId = result[0]

    print(subj, term, subjectName)

    cur.execute('''
        select P.id, P.family, P.given from Course_enrolments CE
        join Courses CS on (CS.id = CE.course)
        join People P on (P.id = CE.student)
        where CS.id = %s
        order by P.family, P.given
    ''', (courseId,))

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