import random

n = random.randint(1, 30)

while True:
    x = input("맞혀 보세요 ")
    g = int(x)
    if g == n:
        print("정답")
        break
    if g < n:
        print("너무 작아요")
    if g > n:
        print("너무 커요")
