********************************************************************************
* MAIN ANALYSIS																   *
* 																	   		   *
* Note: Use from within the R script "main.R"								   *
*																			   *
********************************************************************************



*************************
* 	WRANGLING			*
*************************

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



*************************
* 	ANALYSIS			*
*************************

*********************************************************
* SI (World, OECD) (2020, 2021) LEAD_GDP				*
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
	estadd local date "Yes"
	
	restore
	preserve

	keep if flow == "Exports"
	
	reghdfe logvalue ///
		si_rep si_par loggdp_rep loggdp_par, ///
		vce(robust) absorb(date repcode_i#parcode_i)
	eststo, title(Exports)
	estadd local pair "Yes"
	estadd local date "Yes"
	
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
	estadd local date "Yes"
	
	restore
	preserve

	keep if flow=="Exports"
	drop if year == 2021
	
	reghdfe logvalue ///
		si_rep si_par loggdp_rep loggdp_par, ///
		vce(robust) absorb(date repcode_i#parcode_i)
	eststo, title(Exports)
	estadd local pair "Yes"
	estadd local date "Yes"
	
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
	estadd local date "Yes"
	
	restore
	preserve

	keep if flow=="Exports"
	drop if year == 2020
	
	reghdfe logvalue ///
		si_rep si_par loggdp_rep loggdp_par, ///
		vce(robust) absorb(date repcode_i#parcode_i)
	eststo, title(Exports)
	estadd local pair "Yes"
	estadd local date "Yes"
	
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
	estadd local date "Yes"
	
	restore
	preserve

	keep if flow == "Exports"
	
	reghdfe logvalue ///
		si_rep si_par loggdp_ann_rep loggdp_ann_par, ///
		vce(robust) absorb(date repcode_i#parcode_i)
	eststo, title(Exports)
	estadd local pair "Yes"
	estadd local date "Yes"
	
	restore
}


esttab /*using "output\tables\si.tex"*/, ///
	title(Regression, Main SI) ///
	se mtitles mgroups(OECD-48 2020 2021 World, pattern(1 0 1 0 1 0 1 0)) ///
	scalars("pair Reporter/Partner Fixed Effects" "date Period Fixed Effects" ///
	"r2_a R-squared overall") ///
	star(* 0.05 ** 0.01 *** 0.001) obslast noomitted replace
}
	
