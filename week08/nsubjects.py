#!/usr/bin/env python3

import sys
import psycopg2

if len(sys.argv) != 2:
    print("Usage: ./nsubjects.py partialName")
    exit(1)

partialName = sys.argv[1]
conn = None

try:
    conn = psycopg2.connect("dbname=uni")
    cur = conn.cursor()

    pattern = '%' + partialName + '%'
    qry = '''
        select U.longname, count(S.id) from OrgUnits U
        join Subjects S on (S.offeredby = U.id)
        join OrgUnit_Types T on (T.id = U.utype)
        where T.name = 'School' and U.longname ILIKE %s
        group by U.id, U.longname
    '''
    cur.execute(qry, (pattern,))

    resultList = cur.fetchall()

    if len(resultList) == 0:
        print("No matches")
    elif len(resultList) == 1:
        name, count = resultList[0]
        print(name, "teaches", count, "subjects")
    else:
        print("Multiple schools match:")
        for name, count in resultList:
            print(name)

except Exception as e:
    print('DB error: ', e)
    exit(1)
finally:
    if conn is not None:
        conn.close()
