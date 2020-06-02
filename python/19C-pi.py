import random

total = 1000000
ev = 0

for i in range(total):
    x = random.random()
    y = random.random()

    if x * x + y * y <= 1.0:
        ev = ev + 1

print((ev / total) * 4)
