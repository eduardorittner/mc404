

a0 = 250960
a1 = 0
a2 = 0
a3 = -1
t0 = 0
contador = 0
naofoi = True


while (True):
    contador += 1
    if contador == 8:
        resposta4 = "Q4: " + str(a0) + ", " + str(a1) + \
            ", " + str(a2) + ", " + str(a3)
    if contador == 5:
        resposta2 = "Q2: " + str(a0) + ", " + str(a1) + \
            ", " + str(a2) + ", " + str(a3)

    if (a0 % 2) == 0:
        t0 = 0
    else:
        t0 = 1
    a1 += t0
    if a1 != 0 and naofoi:
        if a1 == a2:
            naofoi = False
            resposta6 = "Q6: " + str(a0) + ", " + str(a3)
    if t0 == 1:
        if (a2 % 2) == 0:
            a2 += 1
        else:
            a2 -= 1
    if a1 != 0 and naofoi:
        if a1 == a2:
            naofoi = False
            resposta6 = "Q6: " + str(a0) + ", " + str(a3)
    a3 += 1
    a0 //= 2
    if a0 == 0:
        break

print(f"Q1: {a0}, {a1}, {a2}, {a3}")
print(resposta2)
print("Q3: não sei")
print(resposta4)
print("Q3: não sei")
print(resposta6)
print(f"Q7: {a1}")
