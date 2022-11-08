from fastapi import FastAPI

app=FastAPI()

student=[
    {'name':'Prateek', 'city':'bangalore'},
    {'name':'Vishal', 'city':'mumbai'},
    {'name':'Deepika', 'city':'coimbatore'}
    ]

@app.get('/getsqr')
def send_square(number):
    number=int(number)
    return {'result':number**2}

@app.get('/student')
def disp_students():
    return {'students': student}

@app.get('/firststudent')
def disp_first_student():
    return {'first_student':student[0]}

