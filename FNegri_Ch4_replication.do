* Damonte A. and Negri F. (2022, eds.), Causality in Policy Studies. A Pluralist Toolbox, , Springer Series "Texts in Quantitative Political Analysis", Cham (Switzerland): Springer Nature.

* Negri F. (2022), Chapter IV - Correlation Is Not Causation, Yet… Matching and Weighting for Better Counterfactuals.

* Replication materials for section 4.1.

ssc install ebalance, all replace
help ebalance

*When installing ebalance, the dataset cps1re74.dta is copied into your dictory. This is the dataset we will use. You can find it also at https://www.researchgate.net/profile/Fedra-Negri

use "C:\Users\negri\Desktop\Stata14\Stata14\cps1re74.dta", clear

des
tab treat

reg re78 treat age educ black hispan married nodegree re74 re75 u74 u75

ebalance treat age educ black hispan, targets(3)
ebalance treat age educ black hispan, targets(2)
ebalance treat age educ black hispan, targets(1)
ebalance treat age educ black hispan, targets(1 1 2 3)

sysuse cps1re74, clear
foreach v in age educ black hispan married nodegree re74 re75 u74 u75 {
foreach m in age educ black hispan married nodegree re74 re75 u74 u75 {
gen `v'X`m'=`v'*`m'
}
}

foreach v in age educ re74 re75 {
gen `v'X`v'X`v' = `v'^3
}

ebalance treat age educ black hispan married nodegree re74 re75 u74 u75 ///
ageXage ageXeduc ageXblack ageXhispan ageXmarried ageXnodegree ///
ageXre74 ageXre75 ageXu74 ageXu75 educXeduc educXblack educXhispan ///
educXmarried educXnodegree educXre74 educXre75 educXu74 educXu75 ///
blackXmarried blackXnodegree blackXre74 blackXre75 blackXu74 ///
blackXu75 hispanXmarried hispanXnodegree hispanXre74 hispanXre75 ///
hispanXu74 hispanXu75 marriedXnodegree marriedXre74 marriedXre75 ///
marriedXu74 marriedXu75 nodegreeXre74 nodegreeXre75 nodegreeXu74 ///
nodegreeXu75 re74Xre74 re74Xre75 re74Xu75 re75Xre75 re75Xu74 u74Xu75 ///
re75Xre75Xre75 re74Xre74Xre74 ageXageXage educXeducXeduc, keep(baltable)

svyset [pweight=_webal]
svy: reg re78 treat age educ black hispan married nodegree re74 re75 u74 u75
svy: reg re78 treat 

clear

***

*Section 4.2.
*Updates on the CEM algorithm: https://gking.harvard.edu/cem

ssc install cem
help cem

*As before:
use "C:\Users\negri\Desktop\Stata14\Stata14\cps1re74.dta", clear
des
tab treat

reg re78 treat age educ black hispan married nodegree re74 re75 u74 u75

imb age educ black hispan, treatment(treat)

cem age educ black hispan, treatment(treat)

tab age
codebook age
tab educ

cem age (19.5 24.5 34.5 44.5) educ black hispan, treatment(treat)

reg re78 treat age educ black hispan married nodegree re74 re75 u74 u75 [iweight=cem_weights]



