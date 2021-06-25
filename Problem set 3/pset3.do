* Save path in local or global
global main "C:/Users/User/Downloads/Economía aplicada/Tutorial3"
global output "$main/output"
global input "$main/input"


capture mkdir "$output/problemset"
cd "$output/problemset"


*** Probit ***

probit alclmo gender monage highsc belief obese smokes hattac cmedin totexpr tincm_r work0 marsta1 marsta2, robust
/* Notice that we can only infer qualitative information from the raw coefficients 
(e.g. there is a positive association between smoking and being male, and it is 
statistically different from zero at the 1% level of confidence)*/
outreg2 using outreg_prsmoke, word replace dec(3) label

*"marginal effects at the mean"
*probit

probit alclmo gender monage highsc belief obese smokes hattac cmedin totexpr tincm_r work0 marsta1 marsta2, robust
mfx
outreg2 using outreg_dprsmoke, word replace dec(3) label
mfx, at(median)
outreg2 using outreg_dprsmoke, word dec(3) label
predict alclmo_hat_dpro	

*mean marginal effects

*OLS
reg alclmo gender monage highsc belief obese smokes hattac cmedin totexpr tincm_r work0 marsta1 marsta2, robust
outreg2 using outreg_dprsmoke, word dec(3) label
predict alclmo_hat_ols


*logit
logit alclmo gender monage highsc belief obese smokes hattac cmedin totexpr tincm_r work0 marsta1 marsta2, robust
mfx
outreg2 using outreg_dprsmoke, word dec(3) label
predict alclmo_hat_dlog

