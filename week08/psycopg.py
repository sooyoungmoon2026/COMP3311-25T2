#!/usr/bin/env python3

import sys
import psycopg2

if len(sys.argv) != 2:
    print("Usage: ./psycopg.py DBname")
    exit(1)

dbname = sys.argv[1]
conn = None

try:
    conn = psycopg2.connect(f"dbname={dbname}")
    cur = conn.cursor()

    cur.execute("select * from Goals")

    # print(cur.fetchall())      # all tuples
    # print(cur.fetchone())      # next tuple
    # print(cur.fetchmany(3))    # next 3 tuples

except Exception as e:
    print('DB error: ', e)
    exit(1)
finally:
    if conn is not None:
        conn.close()