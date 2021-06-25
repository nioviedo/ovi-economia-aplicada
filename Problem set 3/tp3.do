clear all
global main "C:\Users\juanb\OneDrive\Documentos\Juan\UdeSA\Economía Aplicada\Tutoriales\Tutorial3"
global output "$main/output"
global input "$main/input"

cd "$input"
use russia, clear

*capture mkdir "$output/problemset"
cd "$output/problemset"

*Ejercicio 1
*** Probit ***

probit alclmo gender monage highsc belief obese smokes hattac cmedin totexpr tincm_r work0 marsta1 marsta2, robust
outreg2 using outreg_prsmoke, word replace dec(4) label

*Ejercicio 2

*probit

probit alclmo gender monage highsc belief obese smokes hattac cmedin totexpr tincm_r work0 marsta1 marsta2, robust

*"marginal effects at the mean"
mfx2, at(mean)
outreg2 [probit_mfx] using outreg_prsmoke, word dec(4) label

*"marginal effects at the median"
mfx2, at(median)
outreg2 [probit_mfx] using outreg_prsmoke, word dec(4) label

*mean marginal effects
probit alclmo gender monage highsc belief obese smokes hattac cmedin totexpr tincm_r work0 marsta1 marsta2, robust

eststo margin: margins, dydx(gender monage highsc belief obese smokes hattac cmedin totexpr tincm_r work0 marsta1 marsta2) post
est sto b52
outreg2 b52 using outreg_prsmoke, word dec(4) label

*logit
logit alclmo gender monage highsc belief obese smokes hattac cmedin totexpr tincm_r work0 marsta1 marsta2, robust

outreg2 using outreg_prsmoke, word dec(4) label

*"marginal effects at the mean"
mfx2, at(mean)
outreg2 [logit_mfx] using outreg_prsmoke, word dec(4) label

*"marginal effects at the median"
mfx2, at(median)
outreg2 [logit_mfx] using outreg_prsmoke, word dec(4) label

*mean marginal effects
logit alclmo gender monage highsc belief obese smokes hattac cmedin totexpr tincm_r work0 marsta1 marsta2, robust

eststo margin: margins, dydx(gender monage highsc belief obese smokes hattac cmedin totexpr tincm_r work0 marsta1 marsta2) post
est sto b52
outreg2 b52 using outreg_prsmoke, word dec(4) label

*OLS
reg alclmo gender monage highsc belief obese smokes hattac cmedin totexpr tincm_r work0 marsta1 marsta2, robust
outreg2 using outreg_prsmoke, word dec(4) label




*Ejercicio 3
cd "$input"
use russia, clear
cd "$output/problemset"

probit alclmo gender monage highsc belief obese smokes hattac cmedin totexpr tincm_r work0 marsta1 marsta2, robust

predict alclmo_hat_dpro

sort  alclmo alclmo_hat_dpro
order alclmo alclmo_hat_dpro

bysort alclmo: summarize alclmo_hat_dpro

*Dropping observations
summarize alclmo_hat_dpro if alclmo==0 
drop if alclmo==0 & alclmo_hat_dpro==r(max)

summarize alclmo_hat_dpro if alclmo==1 
drop if alclmo==1 & alclmo_hat_dpro==r(min)


*3.a
xtile cuartiles = alclmo_hat_dpro, n(4)
tab cuartiles
sort cuartiles

*Test for difference in means
*Variables: age in months, income, satisfaction with life, perceived respect ranking
foreach j in monage tincm_r satlif resprk{
forvalues i = 1(1)4 {
ttest `j' if cuartiles==`i', by(alclmo) unequal
}
}
