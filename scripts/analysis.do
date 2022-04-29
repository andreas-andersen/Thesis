********************************************************************************
* MAIN ANALYSIS                                                                *
*                                                                              *
* Note: Use from within the R script "main.R"                                  *
*                                                                              *
********************************************************************************



*************************
*   WRANGLING           *
*************************
{
* Generate logarithm of trade value *
gen logvalue = log(value)

* Generate logarithm of gdp *
gen loggdp_rep = log(gdp_rep)
gen loggdp_par = log(gdp_par)
gen loggdp_ann_rep = log(gdp_ann_rep)
gen loggdp_ann_par = log(gdp_ann_par)

* Generate logarithm of weighted distance *
gen logdistw = log(distw)

* Generate reciprocating stringency index values *
gen si_mul = sqrt(si_rep * si_par)

* Encode categorical variables *
encode repcode, gen(repcode_i)
encode parcode, gen(parcode_i)

* Generate GVC dummies based on median value *
quietly sum gvc_rep if oecd == 1, detail
local median_gvc = r(p50)
generate gvc_rep_i = 0
replace gvc_rep_i = 1 if gvc_rep > `median_gvc'

* Generate Upstreamness dummies based on median value *
quietly sum upstreamness_rep if oecd == 1, detail
local median_upstreamness = r(p50)
generate upstreamness_rep_i = 0
replace upstreamness_rep_i = 1 if upstreamness_rep > `median_upstreamness'
}


*************************
*   ANALYSIS            *
*************************

*********************************************************
* SI (World, OECD) (2020, 2021)                         *
*********************************************************
eststo clear

{
*** OECD ***
quietly {
	preserve

	keep if flow == "Imports"
	
	reghdfe logvalue ///
		si_rep si_par loggdp_rep loggdp_par, ///
		vce(robust) absorb(date repcode_i#parcode_i)
	eststo, title(Imports)
	estadd local pair "Yes"
	estadd local per "Yes"
	
	restore
	preserve

	keep if flow == "Exports"
	
	reghdfe logvalue ///
		si_rep si_par loggdp_rep loggdp_par, ///
		vce(robust) absorb(date repcode_i#parcode_i)
	eststo, title(Exports)
	estadd local pair "Yes"
	estadd local per "Yes"
	
	restore
}

*** 2020 ***
quietly {
	preserve

	keep if flow == "Imports"
	drop if year == 2021
	
	reghdfe logvalue ///
		si_rep si_par loggdp_rep loggdp_par, ///
		vce(robust) absorb(date repcode_i#parcode_i)
	eststo, title(Imports)
	estadd local pair "Yes"
	estadd local per "Yes"
	
	restore
	preserve

	keep if flow=="Exports"
	drop if year == 2021
	
	reghdfe logvalue ///
		si_rep si_par loggdp_rep loggdp_par, ///
		vce(robust) absorb(date repcode_i#parcode_i)
	eststo, title(Exports)
	estadd local pair "Yes"
	estadd local per "Yes"
	
	restore
}

*** 2021 ***
quietly {
	preserve

	keep if flow == "Imports"
	drop if year == 2020
	
	reghdfe logvalue ///
		si_rep si_par loggdp_rep loggdp_par, ///
		vce(robust) absorb(date repcode_i#parcode_i)
	eststo, title(Imports)
	estadd local pair "Yes"
	estadd local per "Yes"
	
	restore
	preserve

	keep if flow=="Exports"
	drop if year == 2020
	
	reghdfe logvalue ///
		si_rep si_par loggdp_rep loggdp_par, ///
		vce(robust) absorb(date repcode_i#parcode_i)
	eststo, title(Exports)
	estadd local pair "Yes"
	estadd local per "Yes"
	
	restore
}

*** World ***
quietly {
	preserve

	keep if flow == "Imports"
	
	reghdfe logvalue ///
		si_rep si_par loggdp_ann_rep loggdp_ann_par, ///
		vce(robust) absorb(date repcode_i#parcode_i)
	eststo, title(Imports)
	estadd local pair "Yes"
	estadd local per "Yes"
	
	restore
	preserve

	keep if flow == "Exports"
	
	reghdfe logvalue ///
		si_rep si_par loggdp_ann_rep loggdp_ann_par, ///
		vce(robust) absorb(date repcode_i#parcode_i)
	eststo, title(Exports)
	estadd local pair "Yes"
	estadd local per "Yes"
	
	restore
}


esttab using "output\si.smcl", ///
	title(Regression, Main SI) ///
	se mtitles mgroups(2020 2021 World, pattern(0 0 1 0 1 0 1 0)) ///
	scalars("pair Reporter/Partner Fixed Effects" "per Period Fixed Effects" ///
	"r2_a R-squared overall") ///
	star(* 0.05 ** 0.01 *** 0.001) obslast noomitted replace
}
	
*********************************************************
* SI & GVC (OECD) (2020, 2021)                          *
*********************************************************
eststo clear

{
*** OECD GVC Dummy ***
quietly {
	preserve

	keep if flow == "Imports"
	
	reghdfe logvalue ///
		si_rep si_par ///
		c.si_rep#i.gvc_rep_i ///
		c.si_par#i.gvc_rep_i ///
		loggdp_rep loggdp_par, ///
		vce(robust) absorb(date repcode_i#parcode_i)
	eststo, title(Imports)
	estadd local pair "Yes"
	estadd local per "Yes"
	
	restore
	preserve

	keep if flow == "Exports"
	
	reghdfe logvalue ///
		si_rep si_par ///
		c.si_rep#i.gvc_rep_i ///
		c.si_par#i.gvc_rep_i ///
		loggdp_rep loggdp_par, ///
		vce(robust) absorb(date repcode_i#parcode_i)
	eststo, title(Exports)
	estadd local pair "Yes"
	estadd local per "Yes"
	
	restore
}

*** OECD GVC Dummy 2020 ***
quietly {
	preserve

	keep if flow == "Imports"
	drop if year == 2021
	
	reghdfe logvalue ///
		si_rep si_par ///
		c.si_rep#i.gvc_rep_i ///
		c.si_par#i.gvc_rep_i ///
		loggdp_rep loggdp_par, ///
		vce(robust) absorb(date repcode_i#parcode_i)
	eststo, title(Imports)
	estadd local pair "Yes"
	estadd local per "Yes"
	
	restore
	preserve

	keep if flow == "Exports"
	drop if year == 2021
	
	reghdfe logvalue ///
		si_rep si_par ///
		c.si_rep#i.gvc_rep_i ///
		c.si_par#i.gvc_rep_i ///
		loggdp_rep loggdp_par, ///
		vce(robust) absorb(date repcode_i#parcode_i)
	eststo, title(Exports)
	estadd local pair "Yes"
	estadd local per "Yes"
	
	restore
}

*** OECD GVC Dummy 2021 ***
quietly {
	preserve

	keep if flow == "Imports"
	drop if year == 2020
	
	reghdfe logvalue ///
		si_rep si_par ///
		c.si_rep#i.gvc_rep_i ///
		c.si_par#i.gvc_rep_i ///
		loggdp_rep loggdp_par, ///
		vce(robust) absorb(date repcode_i#parcode_i)
	eststo, title(Imports)
	estadd local pair "Yes"
	estadd local per "Yes"
	
	restore
	preserve

	keep if flow == "Exports"
	drop if year == 2020
	
	reghdfe logvalue ///
		si_rep si_par ///
		c.si_rep#i.gvc_rep_i ///
		c.si_par#i.gvc_rep_i ///
		loggdp_rep loggdp_par, ///
		vce(robust) absorb(date repcode_i#parcode_i)
	eststo, title(Exports)
	estadd local pair "Yes"
	estadd local per "Yes"
	
	restore
}

*** OECD GVC Continuous ***
quietly {
	preserve

	keep if flow == "Imports"
	
	reghdfe logvalue ///
		si_rep si_par ///
		c.si_rep#c.gvc_rep ///
		c.si_par#c.gvc_rep ///
		loggdp_rep loggdp_par, ///
		vce(robust) absorb(date repcode_i#parcode_i)
	eststo, title(Imports)
	estadd local pair "Yes"
	estadd local per "Yes"
	
	restore
	preserve

	keep if flow == "Exports"
	
	reghdfe logvalue ///
		si_rep si_par ///
		c.si_rep#c.gvc_rep ///
		c.si_par#c.gvc_rep ///
		loggdp_rep loggdp_par, ///
		vce(robust) absorb(date repcode_i#parcode_i)
	eststo, title(Exports)
	estadd local pair "Yes"
	estadd local per "Yes"
	
	restore
}

esttab using "output\si_gvc.smcl", /// 
	title(Regression, SI and GVC participation) ///
	se mtitles mgroups(2020 2021 Continuous, pattern(0 0 1 0 1 0 1 0)) ///
	scalars("pair Reporter/Partner Fixed Effects" "per Period Fixed Effects" ///
	"r2_a R-squared overall") ///
	star(* 0.05 ** 0.01 *** 0.001) obslast varwidth(30) noomitted replace
}	
	
*********************************************************
* SI & Upstreamness (OECD) (2020, 2021)                 *
*********************************************************
eststo clear

{
*** OECD Upstreamness World Dummy ***
quietly {
	preserve

	keep if flow == "Imports"
	
	reghdfe logvalue ///
		si_rep si_par ///
		c.si_rep#i.upstreamness_rep_i ///
		c.si_par#i.upstreamness_rep_i ///
		loggdp_rep loggdp_par, ///
		vce(robust) absorb(date repcode_i#parcode_i)
	eststo, title(Imports)
	estadd local pair "Yes"
	estadd local per "Yes"
	
	restore
	preserve

	keep if flow == "Exports"
	
	reghdfe logvalue ///
		si_rep si_par ///
		c.si_rep#i.upstreamness_rep_i ///
		c.si_par#i.upstreamness_rep_i ///
		loggdp_rep loggdp_par, ///
		vce(robust) absorb(date repcode_i#parcode_i)
	eststo, title(Exports)
	estadd local pair "Yes"
	estadd local per "Yes"
	
	restore
}

*** OECD Upstreamness Dummy 2020 ***
quietly {
	preserve

	keep if flow == "Imports"
	drop if year == 2021
	
	reghdfe logvalue ///
		si_rep si_par ///
		c.si_rep#i.upstreamness_rep_i ///
		c.si_par#i.upstreamness_rep_i ///
		loggdp_rep loggdp_par, ///
		vce(robust) absorb(date repcode_i#parcode_i)
	eststo, title(Imports)
	estadd local pair "Yes"
	estadd local per "Yes"
	
	restore
	preserve

	keep if flow == "Exports"
	drop if year == 2021
	
	reghdfe logvalue ///
		si_rep si_par ///
		c.si_rep#i.upstreamness_rep_i ///
		c.si_par#i.upstreamness_rep_i ///
		loggdp_rep loggdp_par, ///
		vce(robust) absorb(date repcode_i#parcode_i)
	eststo, title(Exports)
	estadd local pair "Yes"
	estadd local per "Yes"
	
	restore
}

*** OECD Upstreamness Dummy 2021 ***
quietly {
	preserve

	keep if flow == "Imports"
	drop if year == 2020
	
	reghdfe logvalue ///
		si_rep si_par ///
		c.si_rep#i.upstreamness_rep_i ///
		c.si_par#i.upstreamness_rep_i ///
		loggdp_rep loggdp_par, ///
		vce(robust) absorb(date repcode_i#parcode_i)
	eststo, title(Imports)
	estadd local pair "Yes"
	estadd local per "Yes"
	
	restore
	preserve

	keep if flow == "Exports"
	drop if year == 2020
	
	reghdfe logvalue ///
		si_rep si_par ///
		c.si_rep#i.upstreamness_rep_i ///
		c.si_par#i.upstreamness_rep_i ///
		loggdp_rep loggdp_par, ///
		vce(robust) absorb(date repcode_i#parcode_i)
	eststo, title(Exports)
	estadd local pair "Yes"
	estadd local per "Yes"
	
	restore
}

*** OECD Upstreamness Continuous***
quietly {
	preserve

	keep if flow == "Imports"
	
	reghdfe logvalue ///
		si_rep si_par ///
		c.si_rep#c.upstreamness_rep ///
		c.si_par#c.upstreamness_rep ///
		loggdp_rep loggdp_par, ///
		vce(robust) absorb(date repcode_i#parcode_i)
	eststo, title(Imports)
	estadd local pair "Yes"
	estadd local per "Yes"
	
	restore
	preserve

	keep if flow == "Exports"
	
	reghdfe logvalue ///
		si_rep si_par ///
		c.si_rep#c.upstreamness_rep ///
		c.si_par#c.upstreamness_rep ///
		loggdp_rep loggdp_par, ///
		vce(robust) absorb(date repcode_i#parcode_i)
	eststo, title(Exports)
	estadd local pair "Yes"
	estadd local per "Yes"
	
	restore
}

esttab using "output\si_upstreamness.smcl", /// 
	title(Regression, SI and Upstreamness World) ///
	se mtitles mgroups(2020 2021 Continuous, pattern(0 0 1 0 1 0 1 0)) ///
	scalars("pair Reporter/Partner Fixed Effects" "per Period Fixed Effects" ///
	"r2_a R-squared overall") ///
	star(* 0.05 ** 0.01 *** 0.001) obslast varwidth(30) noomitted replace
}
	
*********************************************************
* ROBUSTNESS SI Cluster (World, OECD) (2020, 2021)      *
*********************************************************
eststo clear

{
*** OECD ***
quietly {
	preserve

	keep if flow == "Imports"
	
	reghdfe logvalue ///
		si_rep si_par loggdp_rep loggdp_par, ///
		vce(cluster repcode_i#parcode_i) absorb(date repcode_i#parcode_i)
	eststo, title(Imports)
	estadd local pair "Yes"
	estadd local per "Yes"
	
	restore
	preserve

	keep if flow == "Exports"
	
	reghdfe logvalue ///
		si_rep si_par loggdp_rep loggdp_par, ///
		vce(cluster repcode_i#parcode_i) absorb(date repcode_i#parcode_i)
	eststo, title(Exports)
	estadd local pair "Yes"
	estadd local per "Yes"
	
	restore
}

*** 2020 ***
quietly {
	preserve

	keep if flow == "Imports"
	drop if year == 2021
	
	reghdfe logvalue ///
		si_rep si_par loggdp_rep loggdp_par, ///
		vce(cluster repcode_i#parcode_i) absorb(date repcode_i#parcode_i)
	eststo, title(Imports)
	estadd local pair "Yes"
	estadd local per "Yes"
	
	restore
	preserve

	keep if flow=="Exports"
	drop if year == 2021
	
	reghdfe logvalue ///
		si_rep si_par loggdp_rep loggdp_par, ///
		vce(cluster repcode_i#parcode_i) absorb(date repcode_i#parcode_i)
	eststo, title(Exports)
	estadd local pair "Yes"
	estadd local per "Yes"
	
	restore
}

*** 2021 ***
quietly {
	preserve

	keep if flow == "Imports"
	drop if year == 2020
	
	reghdfe logvalue ///
		si_rep si_par loggdp_rep loggdp_par, ///
		vce(cluster repcode_i#parcode_i) absorb(date repcode_i#parcode_i)
	eststo, title(Imports)
	estadd local pair "Yes"
	estadd local per "Yes"
	
	restore
	preserve

	keep if flow=="Exports"
	drop if year == 2020
	
	reghdfe logvalue ///
		si_rep si_par loggdp_rep loggdp_par, ///
		vce(cluster repcode_i#parcode_i) absorb(date repcode_i#parcode_i)
	eststo, title(Exports)
	estadd local pair "Yes"
	estadd local per "Yes"
	
	restore
}

*** World ***
quietly {
	preserve

	keep if flow == "Imports"
	
	reghdfe logvalue ///
		si_rep si_par loggdp_ann_rep loggdp_ann_par, ///
		vce(cluster repcode_i#parcode_i) absorb(date repcode_i#parcode_i)
	eststo, title(Imports)
	estadd local pair "Yes"
	estadd local per "Yes"
	
	restore
	preserve

	keep if flow == "Exports"
	
	reghdfe logvalue ///
		si_rep si_par loggdp_ann_rep loggdp_ann_par, ///
		vce(cluster repcode_i#parcode_i) absorb(date repcode_i#parcode_i)
	eststo, title(Exports)
	estadd local pair "Yes"
	estadd local per "Yes"
	
	restore
}


esttab using "output\si_cluster.smcl", ///
	title(Regression, Main SI, CLUSTER ROBUST) ///
	se mtitles mgroups(2020 2021 World, pattern(0 0 1 0 1 0 1 0)) ///
	scalars("pair Reporter/Partner Fixed Effects" "per Period Fixed Effects" ///
	"r2_a R-squared overall") ///
	star(* 0.05 ** 0.01 *** 0.001) obslast noomitted replace
}
	
*********************************************************
* ROBUSTNESS SI RP,PP-FE (World, OECD) (2020, 2021)     *
*********************************************************
eststo clear

{
*** OECD ***
quietly {
	preserve

	keep if flow == "Imports"
	keep if oecd == 1
	
	reghdfe logvalue ///
		si_mul, ///
		vce(robust) ///
		absorb(date date#repcode_i date#parcode_i repcode_i#parcode_i)
	eststo, title(Imports)
	estadd local pair "Yes"
	estadd local repper "Yes"
	estadd local parper "Yes"
	estadd local per "Yes"
	
	restore
	preserve

	keep if flow == "Exports"
	keep if oecd == 1
	
	reghdfe logvalue ///
		si_mul, ///
		vce(robust) ///
		absorb(date date#repcode_i date#parcode_i repcode_i#parcode_i)
	eststo, title(Exports)
	estadd local pair "Yes"
	estadd local repper "Yes"
	estadd local parper "Yes"
	estadd local per "Yes"
	
	restore
}

*** 2020 ***
quietly {
	preserve

	keep if flow == "Imports"
	drop if year == 2021
	keep if oecd == 1
	
	reghdfe logvalue ///
		si_mul, ///
		vce(robust) ///
		absorb(date date#repcode_i date#parcode_i repcode_i#parcode_i)
	eststo, title(Imports)
	estadd local pair "Yes"
	estadd local repper "Yes"
	estadd local parper "Yes"
	estadd local per "Yes"
	
	restore
	preserve

	keep if flow=="Exports"
	drop if year == 2021
	keep if oecd == 1
	
	reghdfe logvalue ///
		si_mul, ///
		vce(robust) ///
		absorb(date date#repcode_i date#parcode_i repcode_i#parcode_i)
	eststo, title(Exports)
	estadd local pair "Yes"
	estadd local repper "Yes"
	estadd local parper "Yes"
	estadd local per "Yes"
	
	restore
}

*** 2021 ***
quietly {
	preserve

	keep if flow == "Imports"
	drop if year == 2020
	keep if oecd == 1
	
	reghdfe logvalue ///
		si_mul, ///
		vce(robust) ///
		absorb(date date#repcode_i date#parcode_i repcode_i#parcode_i)
	eststo, title(Imports)
	estadd local pair "Yes"
	estadd local repper "Yes"
	estadd local parper "Yes"
	estadd local per "Yes"
	
	restore
	preserve

	keep if flow=="Exports"
	drop if year == 2020
	keep if oecd == 1
	
	reghdfe logvalue ///
		si_mul, ///
		vce(robust) ///
		absorb(date date#repcode_i date#parcode_i repcode_i#parcode_i)
	eststo, title(Exports)
	estadd local pair "Yes"
	estadd local repper "Yes"
	estadd local parper "Yes"
	estadd local per "Yes"
	
	restore
}

*** World ***
quietly {
	preserve

	keep if flow == "Imports"
	
	reghdfe logvalue ///
		si_mul, ///
		vce(robust) ///
		absorb(date date#repcode_i date#parcode_i repcode_i#parcode_i)
	eststo, title(Imports)
	estadd local pair "Yes"
	estadd local repper "Yes"
	estadd local parper "Yes"
	estadd local per "Yes"
	
	restore
	preserve

	keep if flow == "Exports"
	
	reghdfe logvalue ///
		si_mul, ///
		vce(robust) ///
		absorb(date date#repcode_i date#parcode_i repcode_i#parcode_i)
	eststo, title(Exports)
	estadd local pair "Yes"
	estadd local repper "Yes"
	estadd local parper "Yes"
	estadd local per "Yes"
	
	restore
}


esttab using "output\si_rppp_fe.smcl", ///
	title(Regression, Main SI, Reporter-Partner-Period FE) ///
	se mtitles mgroups(2020 2021 World, pattern(0 0 1 0 1 0 1 0)) ///
	scalars("pair Reporter/Partner Fixed Effects" ///
	"repper Reporter-Period Fixed Effects" ///
	"parper Partner-Period Fixed Effects" "per Period Fixed Effects" ///
	"r2_a R-squared overall") ///
	star(* 0.05 ** 0.01 *** 0.001) obslast noomitted replace
}
	
*********************************************************
* ROBUSTNESS SI RPM-FE (World, OECD) (2020, 2021)       *
*********************************************************
eststo clear

{
*** OECD ***
quietly {	
	preserve
	
	keep if flow == "Imports"
	
	reghdfe logvalue ///
		si_rep si_par loggdp_rep loggdp_par, ///
		vce(robust) absorb(date month#repcode_i#parcode_i)
	eststo, title(Imports)
	estadd local pairm "Yes"
	estadd local per "Yes"
	
	restore
	preserve

	keep if flow == "Exports"
	
	reghdfe logvalue ///
		si_rep si_par loggdp_rep loggdp_par, ///
		vce(robust) absorb(date month#repcode_i#parcode_i)
	eststo, title(Imports)
	estadd local pairm "Yes"
	estadd local per "Yes"
	
	restore
}

*** 2020 ***
quietly {
	preserve

	keep if flow == "Imports"
	drop if year == 2021
	
	reghdfe logvalue ///
		si_rep si_par loggdp_rep loggdp_par, ///
		vce(robust) absorb(date month#repcode_i#parcode_i)
	eststo, title(Imports)
	estadd local pairm "Yes"
	estadd local per "Yes"
	
	restore
	preserve

	keep if flow=="Exports"
	drop if year == 2021
	
	reghdfe logvalue ///
		si_rep si_par loggdp_rep loggdp_par, ///
		vce(robust) absorb(date month#repcode_i#parcode_i)
	eststo, title(Imports)
	estadd local pairm "Yes"
	estadd local per "Yes"
	
	restore
}

*** 2021 ***
quietly {
	preserve

	keep if flow == "Imports"
	drop if year == 2020
	
	reghdfe logvalue ///
		si_rep si_par loggdp_rep loggdp_par, ///
		vce(robust) absorb(date month#repcode_i#parcode_i)
	eststo, title(Imports)
	estadd local pairm "Yes"
	estadd local per "Yes"
	
	restore
	preserve

	keep if flow=="Exports"
	drop if year == 2020
	
	reghdfe logvalue ///
		si_rep si_par loggdp_rep loggdp_par, ///
		vce(robust) absorb(date month#repcode_i#parcode_i)
	eststo, title(Imports)
	estadd local pairm "Yes"
	estadd local per "Yes"
	
	restore
}

*** World ***
quietly {
	preserve

	keep if flow == "Imports"
	
	reghdfe logvalue ///
		si_rep si_par loggdp_ann_rep loggdp_ann_par, ///
		vce(robust) absorb(date month#repcode_i#parcode_i)
	eststo, title(Imports)
	estadd local pairm "Yes"
	estadd local per "Yes"
	
	restore
	preserve

	keep if flow == "Exports"
	
	reghdfe logvalue ///
		si_rep si_par loggdp_ann_rep loggdp_ann_par, ///
		vce(robust) absorb(date month#repcode_i#parcode_i)
	eststo, title(Imports)
	estadd local pairm "Yes"
	estadd local per "Yes"
	
	restore
}


esttab using "output\si_rpm_fe.smcl", ///
	title(Regression, Main SI, CLUSTER ROBUST) ///
	se mtitles mgroups(2020 2021 World, pattern(0 0 1 0 1 0 1 0)) ///
	scalars("pairm Reporter-Partner-Month-pairs Fixed Effects" ///
	"per Period Fixed Effects" ///
	"r2_a R-squared overall") ///
	star(* 0.05 ** 0.01 *** 0.001) obslast noomitted replace
}
	
*********************************************************
* ROBUSTNESS SI & Classic Gravity Models (OECD)         *
*********************************************************
eststo clear

{
*** Classic Gravity with Period FE (OECD) ***
quietly {
	preserve

	keep if flow == "Imports"
	
	reghdfe logvalue ///
		si_rep si_par ///
		logdistw rta coldepever comlang_ethno contig ///
		landlocked_rep landlocked_par wto_rep wto_par ///
		loggdp_rep loggdp_par, ///
		vce(robust) ///
		absorb(date)
	eststo, title(Imports)
	estadd local pair "No"
	estadd local reporter "No"
	estadd local partner "No"
	estadd local per "Yes"

	restore
	preserve

	keep if flow == "Exports"
	
	reghdfe logvalue ///
		si_rep si_par ///
		logdistw rta coldepever comlang_ethno contig ///
		landlocked_rep landlocked_par wto_rep wto_par ///
		loggdp_rep loggdp_par, ///
		vce(robust) ///
		absorb(date)
	eststo, title(Imports)
	estadd local pair "No"
	estadd local reporter "No"
	estadd local partner "No"
	estadd local per "Yes"
	
	restore
}

*** Classic Gravity with Reporter and Partner FE (OECD) ***
quietly {
	preserve

	keep if flow == "Imports"
	
	reghdfe logvalue ///
		si_rep si_par ///
		logdistw rta coldepever comlang_ethno contig ///
		loggdp_rep loggdp_par, ///
		vce(robust) ///
		absorb(date repcode_i parcode_i)
	eststo, title(Imports)
	estadd local pair "No"
	estadd local reporter "Yes"
	estadd local partner "Yes"
	estadd local per "Yes"

	restore
	preserve

	keep if flow == "Exports"
	
	reghdfe logvalue ///
		si_rep si_par ///
		logdistw rta coldepever comlang_ethno contig ///
		loggdp_rep loggdp_par, ///
		vce(robust) ///
		absorb(date repcode_i parcode_i)
	eststo, title(Imports)
	estadd local pair "No"
	estadd local reporter "Yes"
	estadd local partner "Yes"
	estadd local per "Yes"
	
	restore
}

esttab using "output\si_gravity.smcl", ///
	title(Regression, SI and classic gravity specifications) ///
	se mtitles mgroups(OECD-48 OECD-48, pattern(1 0 1 0)) ///
	scalars("pair Reporter/Partner Fixed Effects" ///
	"reporter Reporter Fixed Effects" "partner Partner Fixed Effects" ///
	"per Period Fixed Effects" "r2_a R-squared overall") ///
	star(* 0.05 ** 0.01 *** 0.001) obslast varwidth(30) noomitted replace
}	

*********************************************************
* ROBUSTNESS 2021 Countries (2020, 2021)                *
*********************************************************
eststo clear

{
*** OECD ***
quietly {
	preserve

	keep if flow == "Imports" & year == 2021 & oecd == 1
	keep repcode
	duplicates drop
	tempfile temp_imp
	save `temp_imp'

	restore
	preserve

	keep if flow == "Imports"
	merge m:1 repcode using `temp_imp'
	keep if _merge == 3
	
	reghdfe logvalue ///
		si_rep si_par loggdp_rep loggdp_par, ///
		vce(robust) absorb(date repcode_i#parcode_i)
	eststo, title(Imports)
	estadd local pair "Yes"
	estadd local per "Yes"
	
	restore
	preserve

	keep if flow == "Exports" & year == 2021
	keep repcode
	duplicates drop
	tempfile temp_exp
	save `temp_exp'

	restore
	preserve

	keep if flow == "Exports"
	merge m:1 repcode using `temp_exp'
	keep if _merge == 3
	
	reghdfe logvalue ///
		si_rep si_par loggdp_rep loggdp_par, ///
		vce(robust) absorb(date repcode_i#parcode_i)
	eststo, title(Exports)
	estadd local pair "Yes"
	estadd local per "Yes"
	
	restore
}

esttab using "output\si_2021.smcl", ///
	title(Regression, Main SI, 2021 Observations) ///
	se mtitles mgroups(OECD-48, pattern(1 0)) ///
	scalars("pair Reporter/Partner Fixed Effects" "per Period Fixed Effects" ///
	"r2_a R-squared overall") ///
	star(* 0.05 ** 0.01 *** 0.001) obslast noomitted replace
}

*********************************************************
* ROBUSTNESS SI PPML (World, OECD) (2020, 2021)         *
*********************************************************
eststo clear

{
*** OECD ***
quietly {
	preserve

	keep if flow == "Imports"
	
	ppmlhdfe value ///
		si_rep si_par loggdp_rep loggdp_par, ///
		vce(robust) absorb(date repcode_i#parcode_i)
	eststo, title(Imports)
	estadd local pair "Yes"
	estadd local per "Yes"
	
	restore
	preserve

	keep if flow == "Exports"
	
	ppmlhdfe value ///
		si_rep si_par loggdp_rep loggdp_par, ///
		vce(robust) absorb(date repcode_i#parcode_i)
	eststo, title(Imports)
	estadd local pair "Yes"
	estadd local per "Yes"
	
	restore
}

*** 2020 ***
quietly {
	preserve

	keep if flow == "Imports"
	drop if year == 2021
	
	ppmlhdfe value ///
		si_rep si_par loggdp_rep loggdp_par, ///
		vce(robust) absorb(date repcode_i#parcode_i)
	eststo, title(Imports)
	estadd local pair "Yes"
	estadd local per "Yes"
	
	restore
	preserve

	keep if flow=="Exports"
	drop if year == 2021
	
	ppmlhdfe value ///
		si_rep si_par loggdp_rep loggdp_par, ///
		vce(robust) absorb(date repcode_i#parcode_i)
	eststo, title(Imports)
	estadd local pair "Yes"
	estadd local per "Yes"
	
	restore
}

*** 2021 ***
quietly {
	preserve

	keep if flow == "Imports"
	drop if year == 2020
	
	ppmlhdfe value ///
		si_rep si_par loggdp_rep loggdp_par, ///
		vce(robust) absorb(date repcode_i#parcode_i)
	eststo, title(Imports)
	estadd local pair "Yes"
	estadd local per "Yes"
	
	restore
	preserve

	keep if flow=="Exports"
	drop if year == 2020
	
	ppmlhdfe value ///
		si_rep si_par loggdp_rep loggdp_par, ///
		vce(robust) absorb(date repcode_i#parcode_i)
	eststo, title(Imports)
	estadd local pair "Yes"
	estadd local per "Yes"
	
	restore
}

*** World ***
quietly {
	preserve

	keep if flow == "Imports"
	
	ppmlhdfe value ///
		si_rep si_par loggdp_ann_rep loggdp_ann_par, ///
		vce(robust) absorb(date repcode_i#parcode_i)
	eststo, title(Imports)
	estadd local pair "Yes"
	estadd local per "Yes"
	
	restore
	preserve

	keep if flow == "Exports"
	
	ppmlhdfe value ///
		si_rep si_par loggdp_ann_rep loggdp_ann_par, ///
		vce(robust) absorb(date repcode_i#parcode_i)
	eststo, title(Imports)
	estadd local pair "Yes"
	estadd local per "Yes"
	
	restore
}

esttab using "output\si_ppml.smcl", ///
	title(Regression, Main SI, PPML) ///
	se mtitles mgroups(2020 2021 World, pattern(0 0 1 0 1 0 1 0)) ///
	scalars("pair Reporter/Partner Fixed Effects" "per Period Fixed Effects" ///
	"r2_p Pseudo-R-squared") ///
	star(* 0.05 ** 0.01 *** 0.001) obslast noomitted replace
}
