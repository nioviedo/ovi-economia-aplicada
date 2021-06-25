clear all
global main "C:\Users\juanb\OneDrive\Documentos\Juan\UdeSA\Economía Aplicada\Tutoriales\Tutorial2"
global output "$main/output"
global input "$main/input"

cd "$input"
use russia, clear

capture mkdir "$output/problemset"
cd "$output/problemset"



gen log_ingreso = log(tincm_r)

gen monage_sqr = monage^2


*Estadisticas descriptivas

estpost summarize satlif log_ingreso econrk

esttab . using estadisticos.rtf, replace cells("mean sd min max") noobs

hist satlif, title(Satisfacción con la vida)

kdensity log_ingreso, title(Distribución del ingreso)

corr satlif log_ingreso econrk satecc


*Regresiones
reg satlif log_ingreso econrk
outreg2 using regresiones.txt, word dec(5) replace

reg satlif log_ingreso econrk satecc monage monage_sqr evalhl resprk marsta* belief highsc hosl3m alclmo gender 
outreg2 using regresiones.txt, word dec(5) append

reg satlif log_ingreso econrk satecc monage monage_sqr evalhl resprk marsta*
outreg2 using regresiones.txt, word dec(5) append

reg satlif log_ingreso econrk satecc monage monage_sqr evalhl resprk
outreg2 using regresiones.txt, word dec(5) append


*Partial regression plot:
avplot econrk, title(Correlación parcial entre satlif y econrk)
avplot satecc, title(Correlación parcial entre satlif y satecc)