clear all


*EJERCICIO 1
*a)
*Primero un modelo con 100 observaciones
set obs 100
set seed 150
gen intelligence=int(invnormal(uniform())*50+500)

*sum intelligence
*kdensity intelligence, norm

gen education=int(intelligence/5+invnormal(uniform())*3)
corr education intelligence

gen a=int(invnormal(uniform())*3+10)
gen b=int(invnormal(uniform())*5+5)
gen u=int(invnormal(uniform())*1+20)

*Verdadero modelo
gen wage=2*intelligence+a+2*b+u

*Corremos el modelo con la variable education
reg wage intelligence education a b
est store mco1
outreg2 using prueba1, word dec(4) label

clear

*Ahora con 1000 observaciones
set obs 1000
set seed 150
gen intelligence=int(invnormal(uniform())*50+500)

*sum intelligence
*kdensity intelligence, norm

gen education=int(intelligence/5+invnormal(uniform())*3)
corr education intelligence

gen a=int(invnormal(uniform())*3+10)
gen b=int(invnormal(uniform())*5+5)
gen u=int(invnormal(uniform())*1+20)

*Verdadero modelo
gen wage=2*intelligence+a+2*b+u


reg wage intelligence education a b
est store mco2
outreg2 using prueba1, word dec(4) label

esttab mco1 mco2, se

*b)
clear

set obs 100
set seed 150
gen intelligence=int(invnormal(uniform())*50+500)

*sum intelligence
*kdensity intelligence, norm

gen education=int(intelligence/5+invnormal(uniform())*3)
corr education intelligence

gen a=int(invnormal(uniform())*3+10)
gen b=int(invnormal(uniform())*5+5)
gen u=int(invnormal(uniform())*20+20)

*Verdadero modelo
gen wage=2*intelligence+a+2*b+u


reg wage intelligence education a b
est store mco3
outreg2 using prueba1, word dec(4) label

esttab mco1 mco2 mco3, se


*3)
corr intelligence u

reg intelligence u
outreg2 using prueba2, word dec(4) label

*EJERCICIO 2
*g)i)

clear

set obs 1000
set seed 150
gen assistance=int(invnormal(uniform())*50+500)
gen error_medición=int(invnormal(uniform())*80)
gen assistance_error = assistance + error_medición

gen a=int(invnormal(uniform())*3+10)
gen b=int(invnormal(uniform())*5+5)
gen u=int(invnormal(uniform())*1+20)

gen score=2*assistance+a+2*b+u

*Regresión sin error de medición
reg score assistance a b
est store proof1
outreg2 using prueba3, word dec(4) label

*Regresión con error de medición
reg score assistance_error a b
est store proof2
outreg2 using prueba3, word dec(4) label

esttab proof1 proof2, se

*g)ii)

clear

set obs 1000
set seed 150
gen assistance=int(invnormal(uniform())*50+500)
gen error_medición=int(invnormal(uniform())*80)

gen a=int(invnormal(uniform())*3+10)
gen b=int(invnormal(uniform())*5+5)
gen u=int(invnormal(uniform())*1+20)

gen score_error=2*assistance+a+2*b+u+error_medición

gen score=2*assistance+a+2*b+u

*Regresión sin error de medición
reg score assistance a b
est store proof3
outreg2 using prueba4, word dec(4) label

*Regresión con error de medición
reg score_error assistance a b
est store proof4
outreg2 using prueba4, word dec(4) label

esttab proof3 proof4, se