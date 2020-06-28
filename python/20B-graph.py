import turtle as t

x_min = -5
x_max = +5

y_min = -5
y_max = +5

space = 0.1

func_list = ["y = x*x", "y = abs(x)", "y = 0.5*x + 1"]

t.setworldcoordinates(x_min, y_min, x_max, y_max)
t.speed(0)
t.pensize(2)

t.up()
t.goto(x_min, 0)
t.down()
t.goto(x_max, 0)

t.up()
t.goto(0, y_min)
t.down()
t.goto(0, y_max)

t.color("green")
for func in func_list:
    x = x_min
    exec(func)
    t.up()
    t.goto(x, y)
    t.down()
    while x <= x_max:
        x = x + space
        exec(func)
        t.goto(x, y)
        
