# to implement threads

import threading
import time
def get_something():
    count=0
    for _ in range(1000000):
        count+=1
        #time.sleep(0.0001)
    print('Counter Value: {0}'.format(count))
    
if __name__=="__main__":
    t1=threading.Thread(target=get_something)
    t2=threading.Thread(target=get_something)
    t1.start()
    t2.start()
    t1.join()
    t2.join()
    print('main Module Ends!')