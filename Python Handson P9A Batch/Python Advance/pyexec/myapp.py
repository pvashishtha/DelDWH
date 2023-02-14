file=open('mystory.txt', 'r')
data=file.read()
file.close()
print("Story Text:\n",data)