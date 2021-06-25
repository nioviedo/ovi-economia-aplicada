clear all

global main "C:\Users\juanb\OneDrive\Documentos\Juan\UdeSA\Economía Aplicada\Tutoriales\Tutorial 6"
global input "$main/input"
global output "$main/output"

cd "$main/input"


use "crime.dta", clear


*EJERCICIO 1
*Table 2
*Column (A):
forvalues i = 4(1)12 {
sum cartheft if month==`i' & dist>2
}


*Column (B):
forvalues i = 4(1)12 {
sum cartheft if month==`i' & dist==0
}


*Column (C):
forvalues i = 4(1)12 {
sum cartheft if month==`i' & dist==1
}


*Column (D):
forvalues i = 4(1)12 {
sum cartheft if month==`i' & dist==2
}

*Column (E):
gen colE=1 if dist>2
replace colE=0 if dist==0

forvalues i = 4(1)12 {
ttest cartheft if month==`i', by(colE) une
}


*Column (F):
gen colF=1 if dist>2
replace colF=0 if dist==1

forvalues i = 4(1)12 {
ttest cartheft if month==`i', by(colF) une
}


*Column (G):
gen colG=1 if dist>2
replace colG=0 if dist==2

forvalues i = 4(1)12 {
ttest cartheft if month==`i', by(colG) une
}


*Table A1
tab barrio if month==4

bysort barrio: tab inst if month==4

bysort barrio: egen total_cartheft= total(cartheft)

bysort barrio: egen total_cartheft_abrjul = total(cartheft) if month==4 | month==5 | month==6  | month==7

bysort barrio: egen total_cartheft_7273 = total(cartheft) if month==72 | month==73

bysort barrio: egen total_cartheft_agodic = total(cartheft) if month==8 | month==9 | month==10  | month==11 | month==12

br barrio total_cartheft total_cartheft_abrjul total_cartheft_7273 total_cartheft_agodic

*Figure 2
drop if month==72 | month==73

bysort month: egen mean_cartheft_month_d0 = mean(cartheft) if dist==0
bysort month: egen mean_cartheft_month_d1 = mean(cartheft) if dist==1
bysort month: egen mean_cartheft_month_d2 = mean(cartheft) if dist==2
bysort month: egen mean_cartheft_month_dm2 = mean(cartheft) if dist>2

twoway line mean_cartheft_month_* month, title(Figure 2)

*EJERCICIO 2
*Table 3
cd "$main/output"
*Dif in dif
xtreg cartheft instp month5-month12, fe i(blockid) robust
est store A
outreg2 using Table3, word dec(5) label

xtreg cartheft instp inst1p month5-month12, fe i(blockid) robust
est store B
outreg2 using Table3, word dec(5) label

gen inst2p=1 if dist==2 & post==1
replace inst2p=0 if inst2p==.

xtreg cartheft instp inst1p inst2p month5-month12, fe i(blockid) robust
est store C
outreg2 using Table3, word dec(5) label

*Cross section
preserve
drop if month<8
xtreg cartheft instp inst1p inst2p month8-month12, robust
est store D
outreg2 using Table3, word dec(5) label
restore


*Time series
preserve
drop if dist>2
xtreg cartheft instp inst1p inst2p, fe i(blockid) robust
est store E
outreg2 using Table3, word dec(5) label
restore

*EJERCICIO 3
*Table 7

*Column A
gen sbpxnobank = instp * (1-bank)
gen sbpxbank = instp * (bank)

gen onebpxnobank = inst1p * (1-bank)
gen onebpxbank = inst1p * (bank)

gen twobpxnobank = inst2p * (1-bank)
gen twobpxbank = inst2p * (bank)

xtreg cartheft sbpxnobank sbpxbank onebpxnobank onebpxbank twobpxnobank twobpxbank month5-month12, fe i(blockid) robust

est store ols

*Column B
gen sbpxnopublic = instp * (1-public)
gen sbpxpublic = instp * (public)

gen onebpxnopublic = inst1p * (1-public)
gen onebpxpublic = inst1p * (public)

gen twobpxnopublic = inst2p * (1-public)
gen twobpxpublic = inst2p * (public)

xtreg cartheft sbpxnopublic sbpxpublic onebpxnopublic onebpxpublic twobpxnopublic twobpxpublic month5-month12, fe i(blockid) robust

est store ols2

*Column C
gen sbpxnostation = instp * (1-station)
gen sbpxstation = instp * (station)

gen onebpxnostation = inst1p * (1-station)
gen onebpxstation = inst1p * (station)

gen twobpxnostation = inst2p * (1-station)
gen twobpxstation = inst2p * (station)

xtreg cartheft sbpxnostation sbpxstation onebpxnostation onebpxstation twobpxnostation twobpxstation month5-month12, fe i(blockid) robust

est store ols3

*Column D
gen protection=1 if public==1 | station==1 | bank==1
replace protection=0 if protection==.

gen sbpxnoprotec = instp * (1-protection)
gen sbpxprotec = instp * (protection)

gen onebpxnoprotec = inst1p * (1-protection)
gen onebpxprotec = inst1p * (protection)

gen twobpxnoprotec = inst2p * (1-protection)
gen twobpxprotec = inst2p * (protection)

xtreg cartheft sbpxnoprotec sbpxprotec onebpxnoprotec onebpxprotec twobpxnoprotec twobpxprotec month5-month12, fe i(blockid) robust

est store ols4

esttab ols ols2 ols3 ols4 using mydoc.rtf
