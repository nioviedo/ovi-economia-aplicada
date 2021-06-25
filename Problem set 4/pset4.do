*##_____________________EJERCICIO 1__________________________________________


*Como dice el tema, pone el original



* Let's use a fictional example

clear
set obs 100
set seed 1234
gen intelligence=int(invnormal(uniform())*20+100)

/* We set the standard error of this variable so the correlation between education and intelligence is high (0.90 approximate).*/

gen education=int(intelligence/10+invnormal(uniform())*1)
corr education intelligence

gen a=int(invnormal(uniform())*2+10)
gen b=int(invnormal(uniform())*1+5)
gen u=int(invnormal(uniform())*1+7)
gen wage=3*intelligence+a+2*b+u

* Two different regressions
reg wage intelligence a b


*##_____________Inciso (a) muestra en 100 mil

*Limpio elijo un n y planto una semilla
clear
set obs 100000
set seed 1234
gen intelligence=int(invnormal(uniform())*20+100)

* Aproposito voy a generar correlación muy alta entre educación e inteligencia

gen education=int(intelligence/10+invnormal(uniform())*1)
corr education intelligence

gen a=int(invnormal(uniform())*2+10)
gen b=int(invnormal(uniform())*1+5)
gen u=int(invnormal(uniform())*1+7)
gen wage=3*intelligence+a+2*b+u

* Two different regressions
reg wage intelligence a b



*##_____________Inciso (b) varianza del error


* Let's use a fictional example

clear
set obs 100
set seed 1234
gen intelligence=int(invnormal(uniform())*20+100)

/* We set the standard error of this variable so the correlation between education and intelligence is high (0.90 approximate).*/

gen education=int(intelligence/10+invnormal(uniform())*1)
corr education intelligence

gen a=int(invnormal(uniform())*2+10)
gen b=int(invnormal(uniform())*1+5)
gen u=int(invnormal(uniform())*1+7)
gen wage=3*intelligence+a+2*b+u

* Two different regressions
reg wage intelligence a b

