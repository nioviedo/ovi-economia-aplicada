clear all

global main "C:\Users\juanb\OneDrive\Documentos\Juan\UdeSA\Economía Aplicada\Tutoriales\Tutorial 5"
global input "$main/input"
global output "$main/output"

cd "$main/input"


use "schooling-card.dta", clear

*EJERCICIO 1

*COLUMNA 2 de la TABLE 1 (los datos que están en la base son para esta submuestra)

*Edad en 1966
gen interval = .
replace interval = 1 if age66==14 | age66==15
replace interval = 2 if age66==16 | age66==17
replace interval = 3 if age66>=18 & age66<=20
replace interval = 4 if age66>=21 & age66<=24

label define linterval 1 "14-15" 2 "16-17" 3 "18-20" 4 "21-24"
label value interval linterval

tab interval

*REGIONES
gen region=.
replace south=1 if reg661==1 | reg662==1 | reg665==1

replace region=1 if reg661==1 | reg662==1 | reg665==1 /*south*/
replace region=2 if reg667==1 | reg669==1 /*northeast*/
replace region=3 if reg663==1 | reg664==1 /*midwest*/
replace region=4 if reg666==1 | reg668==1 /*west*/

label define lregion 1 "south" 2 "northeast" 3 "midwest" 4 "west"
label value region lregion

tab region

*Vivió en SMSA en 1966
tab smsa76r

*Vivió cerca de una Univ de 4 años en 1966
tab nearc4

*Vivió con su madre y padre
tab momdad14

*Vivió con su madre soltera
tab sinmom14

*Educación promedio de la madre
sum momed

*Educación promedio de la madre
sum daded

*Porcentage de color negro
tab black

*Promedio del score en el test KWW
sum kww

*Educación promedio en 1976
sum ed76

*Vivió en el sur en 1976:
sum reg76r


*Submuestra 2: respuestas válidas de salario (empleados)
drop if wage76==.

tab smsa76r
tab nearc4
tab momdad14
tab sinmom14
tab black
tab region

sum momed daded ed76 reg76r

use "schooling-card.dta", clear



*EJERCICIO 2
cd "$main/output"

*Columna 1
reg lwage76 ed76 exp76 exp762 black south66 smsa76r, robust
est store mco1
outreg2 using MCO, word dec(4) label

*Columna 2
reg lwage76 ed76  exp76 exp762  black south66 smsa66r reg66* smsa66r, robust
est store mco2
outreg2 using MCO, word dec(4) label

*Columna 3
reg lwage76 ed76  exp76 exp762  black south66 smsa66r reg66* smsa66r famed, robust
est store mco3
outreg2 using MCO, word dec(4) label

*Columna 4
reg lwage76 ed76  exp76 exp762  black south66 smsa66r reg66* smsa66r famed f1 f2 f3 f4 f5 f6 f7 f8, robust
est store mco4
outreg2 using MCO, word dec(4) label

*Columna 5
reg lwage76 ed76  exp76 exp762  black south66 smsa66r reg66* smsa66r famed f1 f2 f3 f4 f5 f6 f7 f8 momdad14 sinmom14, robust
est store mco5
outreg2 using MCO, word dec(4) label


*EJERCICIO 3

*COLUMNA 1
*Basic speciication
quietly reg lwage76 ed76  exp76 exp762  black south66 smsa66r reg66* smsa66r famed f1 f2 f3 f4 f5 f6 f7 f8 momdad14 sinmom14, robust
local beta1 = _b[ed76]
display `beta1'

*Use 1978 wages and education
quietly reg lwage78 ed76  exp76 exp762  black south66 smsa66r reg66* smsa66r famed f1 f2 f3 f4 f5 f6 f7 f8 momdad14 sinmom14, robust
local beta2 = _b[ed76]
display `beta2'

*Include KWW Test Score
quietly reg lwage76 ed76  exp76 exp762  black south66 smsa66r reg66* smsa66r famed f1 f2 f3 f4 f5 f6 f7 f8 momdad14 sinmom14 kww, robust
local beta3 = _b[ed76]
display `beta3'

*Use subsample age 14-19 in 1966
drop if age66<14 | age66>19
quietly reg lwage76 ed76  exp76 exp762  black south66 smsa66r reg66* smsa66r famed f1 f2 f3 f4 f5 f6 f7 f8 momdad14 sinmom14, robust
local beta4 = _b[ed76]
display `beta4'
cd "$main/input"
use "schooling-card.dta", clear

*COLUMNA 2:

*Basic speciication
quietly ivregress 2sls  lwage76 exp76 exp762  black south66 smsa66r reg66* smsa66r famed f1 f2 f3 f4 f5 f6 f7 f8 momdad14 sinmom14 (ed76= nearc4), robust
est store iv
local beta5 = _b[ed76]
display `beta5'

*Use 1978 wages and education
quietly ivregress 2sls  lwage78  exp76 exp762  black south66 smsa66r reg66* smsa66r famed f1 f2 f3 f4 f5 f6 f7 f8 momdad14 sinmom14 (ed76= nearc4), robust
local beta6 = _b[ed76]
display `beta6'

*Include KWW Test Score
quietly ivregress 2sls  lwage76  exp76 exp762  black south66 smsa66r reg66* smsa66r famed f1 f2 f3 f4 f5 f6 f7 f8 momdad14 sinmom14 kww (ed76= nearc4), robust
local beta7 = _b[ed76]
display `beta7'

*Include KWW Test Score / Instrument with IQ
quietly ivregress 2sls  lwage76 exp76 exp762  black south66 smsa66r reg66* smsa66r famed f1 f2 f3 f4 f5 f6 f7 f8 momdad14 sinmom14 kww (ed76= nearc4 iq), robust
local beta8 = _b[ed76]
display `beta8'

*Use proximity to public college as isntrument for education
quietly ivregress 2sls  lwage76 exp76 exp762  black south66 smsa66r reg66* smsa66r famed f1 f2 f3 f4 f5 f6 f7 f8 momdad14 sinmom14 (ed76= nearc4a iq), robust
local beta9 = _b[ed76]
display `beta9'

*Use proximity to 2 year and 4 year college as isntrument for education
quietly ivregress 2sls  lwage76 exp76 exp762  black south66 smsa66r reg66* smsa66r famed f1 f2 f3 f4 f5 f6 f7 f8 momdad14 sinmom14 (ed76= nearc2 nearc4 iq), robust
local beta10 = _b[ed76]
display `beta10'

*Use subsample age 14-19 in 1966
drop if age66<14 | age66>19
quietly ivregress 2sls  lwage76 exp76 exp762  black south66 smsa66r reg66* smsa66r famed f1 f2 f3 f4 f5 f6 f7 f8 momdad14 sinmom14 (ed76= nearc4), robust
local beta11 = _b[ed76]
display `beta11'
cd "$main/input"
use "schooling-card.dta", clear


*EJERCICIO 4
hausman iv mco5, force


*EJERCICIO 5
* Sargan test


quietly ivregress 2sls  lwage76 exp76 exp762  black south66 smsa66r reg66* smsa66r famed f1 f2 f3 f4 f5 f6 f7 f8 momdad14 sinmom14 (ed76 = nearc4), robust
predict resid, residual

reg resid nearc4 exp76 exp762  black south66 smsa66r reg66* smsa66r famed f1 f2 f3 f4 f5 f6 f7 f8 momdad14 sinmom14, robust

ereturn list
display chi2(2,e(N)*e(r2))


*EJERCICIO 6

*first stage 
reg ed76 nearc4 age66 black south66 smsa66r reg66* smsa66r famed f1 f2 f3 f4 f5 f6 f7 f8 momdad14 sinmom14, robust

*test
test nearc4==0