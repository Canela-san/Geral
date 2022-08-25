import os
import random
import matplotlib.pyplot as plt
from alive_progress import alive_bar
type_dice = []
quant_dice = int(input('How many dice do you want to throw? '))
print('Digit the combination of dice which at a time:')
for i in range(0, quant_dice):
    ele = int(input())
    type_dice.append(ele)
print(type_dice)
# print('The program will calculate the porcentage of the sum of dice that`s been equal or bigger then? ')
# base = int(input())
max_quant = 0
x = []
y = []
for i in type_dice:
    max_quant += i
print ('How many times do you want the program to test the result? ')
quant_loop = int(input())
with alive_bar(int(max_quant), force_tty=True) as bar:
    for base in range(1, max_quant):
        media = 0
        count = 0
        for n in range(1, quant_loop):
            sums = 0
            for i in type_dice:
                sums += random.randint(1, i)
            if sums >= base:
                count += 1
            media = 100*count/(n)

            if (n % 10000) == 0:
                os.system('clear')
                print ('The chances are:')
                print (media, '%')
                print ()

            if n-10 == quant_loop:
                os.system('clear')
                print ('The chances are:')
                print (media, '%')
                print ()
                bar()
        os.system('clear')
        print ('The chances are:')
        print (media, '%')
        print ()
        bar()
        y.append(media)
        x.append(base)
    os.system('clear')
    print ('The chances are:')
    print (media, '%')
    print ()
    bar()
plt.plot(x,y)
plt.xlabel('Quantidade mínima')
plt.ylabel('Probabilidade')
plt.title("Gráfico de probabilidade")
plt.show()
