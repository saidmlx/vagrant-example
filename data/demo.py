n=3
val = 1
total = 0
for i in range(1,n+1):
    for j in range(1,i+1):
        print(str(i) +" - "+  str(j) +" > "+ str(val))
        if i == n:
            total = total + val 
        val+=2
print(total)
