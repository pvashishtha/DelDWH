from fastapi import FastAPI
from fastapi.responses import HTMLResponse
import uvicorn
import mysql.connector

host='IP-ADDR'
user='appdev'
password='Developer@123'
port=3306
database='student'

try:
    conn=mysql.connector.connect(host=host, user=user, password=password, port=port, database=database)
    cur=conn.cursor()
except:
    print('Connection Error')

app=FastAPI()

# replace IPADDR everywhere with actual EC2 public IP

@app.get('/', response_class=HTMLResponse)
def home():
    html="""<body bgcolor='gray'><h1 style='color:blue'>Welcome to Sample Application, Python + MySQL.<br>
    <h3><a href='http://IPADDR/insert_gui'>To insert data, click here</a><br>
    <a href='http://IPADDR/readall'>To view data, click here</a>"""
    return html

@app.get('/insert_gui', response_class=HTMLResponse)
def insert_gui():
    html="""
    <html><head><title>Insert Data Page!</title></head>
    <body bgcolor='pink'>
    <form method=GET action='http://IPADDR/insert'>
    Name: <input type=text name=name><br>
    Course: <input type=text name=course><br>
    <input type=submit value='Insert Data'>
    </form>
    </body></html>
    """
    return html

@app.get('/insert', response_class=HTMLResponse)
def insert(name, course):
    sql=f"insert into student_data values('{name}', '{course}')"
    cur.execute(sql)
    conn.commit()
    return "<h2 style='color:green'> Data Inserted to MySQL Database."

@app.get('/readall', response_class=HTMLResponse)
def readall():
    cur.execute('select * from student_data')
    data=cur.fetchall()
    res=""
    for row in data:
        res+=f"Name: {row[0]}<br>Course: {row[1]}<br>"
        res+="===================================<br>"
    return res

if __name__=='__main__':
    uvicorn.run("myapp:app",host="0.0.0.0", port=8080)
