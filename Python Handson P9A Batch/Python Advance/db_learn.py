import mysql.connector
import colorama
from colorama import Fore, Back, Style
def get_connection():
    host='localhost'
    user='root'
    password=''
    database='abccorp'
    port=3306
    try:
        conn=mysql.connector.connect(host=host, user=user, password=password,
                                    database=database, port=port)
        cur=conn.cursor()
    except:
        print(Back.YELLOW+'Connection/Cursor Error!')
    return conn, cur
def close_connection(conn, cur):
    cur.close()
    conn.close()
    print(Back.YELLOW+'Connections Closed!')
    return None

def insert(func):
    def inner(*args, **kwargs):
        print(Back.GREEN+Fore.RED+'Starting DB Connection...'+Style.RESET_ALL)
        conn, cur = get_connection()
        sql=func(*args, **kwargs)
        print(Fore.BLACK+'Inserting Values...')
        try:
            cur.execute(sql)
            conn.commit()
            print('Data Inserted!')
        except:
            print(Back.YELLOW+'Insertion Error!')
        print(Fore.RED+'Closing DB Connection...')
        close_connection(conn, cur)
    return inner
          