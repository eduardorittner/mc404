

a0 = 250960
a1 = 0
a2 = 0
a3 = -1
t0 = 0
contador = 0
naofoi = True


while (True):

    if (a0 % 2) == 0:
        t0 = 0
    else:
        t0 = 1
    a1 += t0
    if t0 == 1:
        if (a2 % 2) == 0:
            a2 += 1
        else:
            a2 -= 1
    a3 += 1
    a0 //= 2
    if a0 == 0:
        break
