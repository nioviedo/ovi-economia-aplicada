clear all
global main "C:\Users\juanb\OneDrive\Documentos\Juan\UdeSA\Economía Aplicada\Tutoriales\semana 1, 7-8\Tutorial1"
global output "$main/output"
global input "$main/input"


capture mkdir "$output/problemset"
cd "$output/problemset"

cd "$input"
use russia, clear

*Punto 1
*1a)
xtile deciles = totexpr, n(9)
tab deciles
bysort deciles: sum totexpr

preserve
drop if totexpr==.
drop if econrk==.b
missings report
sort deciles econrk totexpr
order deciles econrk totexpr
bysort deciles: tab econrk
bysort deciles: sum econrk
restore

*1b)
*Mujeres
preserve
drop if gender==1
bysort econrk: sum powrnk
bysort econrk: sum resprk
restore

*Hombres
preserve
drop if gender==0
bysort econrk: sum powrnk
bysort econrk: sum resprk
restore

*1c)
gen over_rep = econrk - deciles /*percibido menos objetivo*/
preserve
sort econrk deciles over_rep
order econrk deciles over_rep
restore
pwcorr over_rep height, sig

*Mujeres
preserve
drop if gender==1
twoway scatter over_rep height
restore

*Hombres
preserve
drop if gender==0
twoway scatter over_rep height
restore

*2)
ttest hipsiz , by(gender)

*3)
drop if totexpr==.
drop if econrk==.b
xtile deciles = totexpr, n(9)
collapse (mean) satlif belief evalhl alclmo,  by(deciles)

use russia, clear

*4)
preserve
replace tincm_r=1 if tincm_r==0
gen dif = totexpr - tincm_r
gen difper = dif/tincm_r
sort difper dif tincm_r totexpr 
order difper dif tincm_r totexpr
hist difper
gen raro=0
replace raro=1 if difper>2
order raro difper dif tincm_r totexpr
tab raro
restore

*5)
*Alcoholismo 
graph bar alclmo, over(deciles) by(gender) title(Alcoholismo por género y deciles)

*Distribución del ingreso
gen longing = log(tincm_r)
hist longing, title(Distribución del Ingreso) norm freq

