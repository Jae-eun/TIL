# 소인수 분해 프로그램
x = int(input("? "))
d = 2

while d <= x:
    if x % d == 0:
        print(d)
        x = x / d
    else:
        d = d + 1
