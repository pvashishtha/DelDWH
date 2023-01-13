with open('myfile.txt', 'r') as file:
    i=0
    for line in file:
        i+=1
        print(f'Line{i}: {line}')