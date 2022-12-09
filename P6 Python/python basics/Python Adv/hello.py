name=input('Enter Your Name First: ')
salary=int(input('Enter Salary for year 2022-23: '))
comm=((salary*.25)+(salary*0.15))*12
print('Hello {0}, Welcome to HR Portal!'.format(name))
print('Your Bonus for year 2022-23 will be Rs. : {0}'.format(comm))