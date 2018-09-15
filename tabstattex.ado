capture program drop tabstattex
program define tabstattex

*! version 0.0.9  TomaHawk  17jul2017
**                undocumented option vardisp(none)

*! version 0.0.8  TomaHawk  27nov2017
version 14

syntax varlist [if] [in] [, by(name) Statistics(str asis) Columns(string) format(str asis) NOTotal Missing  ///
                            texfile(str) caption(str) label(str) intc1(str) intc2(str) note(str) widthtable(string) ///
                            landscape fontsize(string) vardisp(string) position(str)  ///
                            s1(string) s2(string) s3(string) s4(string) s5(string) s6(string) s7(string) s8(string) s9(string) s10(string)    ///
                            dfs1(string) dfs2(string) dfs3(string) dfs4(string) dfs5(string) dfs6(string) dfs7(string) dfs8(string) dfs9(string) dfs10(string)    ///
                                             /* options for latex */ ]
**macro list

mata: mata clear
capture file close texfile

if "`columns'" == "" local columns = "variables"
if "`position'" == "" local position = "!htp"

local statistics = subinword("`statistics'","q","p25 p50 p75",1)
if "`statistics'"=="" local statistics = "mean"
local nstat : word count `statistics'

if "`s1'" == "" local default_stat = 1
else local default_stat = 0

**caratteri da trattare per renderli compatibili con LaTex
forvalues i=1(1)10 {
   if "`s`i''" != "" {
     local s`i' = subinstr("`s`i''","∖","\textbackslash",.)
     local s`i' = subinstr("`s`i''"," ̃","\textasciitilde",.)
     local s`i' = subinstr("`s`i''","°","\degree \ ",.)
   }
}

if "`widthtable'" == "" local widthtable = "\textwidth"

if "`by'" != "" {
  capture which fre
  if _rc==111 {
   di "fre not installed.... installing..."
   ssc inst fre, replace
   exit
  }
  local byvar = "`by'"
  local by = "by(`by')"
  qui fre `byvar'
  local n_catvar = r(r)
}
if "`vardisp'" == "" local vardisp = "varlabel"
**vardisp(varlabel|varname|none)
**none solo per by(specificato)

qui tabstat `varlist' `if' `in', `by' save s(`statistics') c(`columns') /*`nototal'*/ `missing'
**return list
matrix StatTotal = r(StatTotal)



if substr("`columns'",1,1) == "s" {
  local cols_int = "`statistics'"
  local columns = "statistics"
  local ncols : word count `statistics'
}

if substr("`columns'",1,1) == "v" {
  local cols_int = "`varlist'"
  local cols_int_tex : subinstr local varlist "_" "\_", all  /** altrimenti in latex mette in pedice **/
  local columns = "variables"
  local ncols : word count `varlist'
}

if "`by'" != "" {
  forvalues i=1(1)`n_catvar' {
    matrix Stat`i' = r(Stat`i') /** se ci sono + variabili in varlist, la matrice sarà del tipo [nstat x n varlist]  **/
    if "`columns'"=="statistics"  matrix Stat`i' = Stat`i''
    local desc_catvar`i' = "`r(name`i')'"
  }
}


if "`by'"=="" {
  local def_cols = "l*{`ncols'}{Z}"
  local table_ncols = 1 + `ncols'
}
else {
  if "`vardisp'"=="none" local def_cols = "l*{`ncols'}{Z}"
  else {
    local def_cols = "ll*{`ncols'}{Z}"
    local table_ncols = 2 + `ncols'
  }
}

**capture erase "`texfile'"
if "`texfile'" != "" {
  qui file open texfile using "`texfile'", write replace
}


file write texfile "\begin{center}" _n

if "`landscape'" != "" file write texfile  "\begin{sidewaystable}[htp]" _n
else file write texfile "\begin{table}[`position']" _n
if "`caption'"!="" file write texfile "\caption{`caption'}" _n
if "`label'"!="" file write texfile "\label{tbl:`label'}" _n
file write texfile "\centering" _n

if "`fontsize'" != "" file write texfile "\\`fontsize'" _n

**di "\begin{tabular}{`def_cols'}"
file write texfile  "\begin{tabularx}{`widthtable'}{`def_cols'}" _n
file write texfile  "\toprule" _n

** intestazione colonne
local int_cols = "`int_c1'"


local j=1
if "`columns'" == "statistics" {
  foreach i in `cols_int' {
    if "`s1'" == "" {
      if "`i'"=="mean" local ii="Media"
      else if "`i'"=="count" local ii="Numero di osservazioni"
      else if "`i'"=="n" local ii="Numero di osservazioni"
      else if "`i'"=="sum" local ii="Sommatoria"
      else if "`i'"=="max" local ii="Massimo"
      else if "`i'"=="min" local ii="Minimo"
      else if "`i'"=="range" local ii="Massimo - Minimo"
      else if "`i'"=="sd" local ii="Deviazione standard"
      else if "`i'"=="variance" local ii="Varianza"
      else if "`i'"=="cv" local ii="Coefficente di variazione"
      else if "`i'"=="semean" local ii="Errore standard della media"
      else if "`i'"=="skewness" local ii="Simmetria"
      else if "`i'"=="kurtosis" local ii="Curtosi"
      else if "`i'"=="p1" local ii="1\degree \ percentile"
      else if "`i'"=="p5" local ii="5\degree \ percentile"
      else if "`i'"=="p10" local ii="10\degree \ percentile"
      else if "`i'"=="p25" local ii="25\degree \ percentile"
      else if "`i'"=="median" local ii="Mediana"
      else if "`i'"=="p50" local ii="50\degree \ percentile"
      else if "`i'"=="p75" local ii="75\degree \ percentile"
      else if "`i'"=="p90" local ii="90\degree \ percentile"
      else if "`i'"=="p95" local ii="95\degree \ percentile"
      else if "`i'"=="p99" local ii="99\degree \ percentile"
      else if "`i'"=="iqr" local ii="Range interquartile"
      local int_cols = `"`int_cols' & `ii'"'
    }
    else local int_cols = `"`int_cols' & `s`j''"'
    local j `++j'
  }
}

else { /* variables */
    if "`vardisp'" == "varlabel" {
      foreach i in `cols_int' {
        local int_cols = `"`int_cols' & `: variable label `i''"'
     }
   }
    else if "`vardisp'" == "varname" {
      foreach i in `cols_int_tex' {
       local int_cols = `"`int_cols' & `i' "'
      }
  }
}



if "`by'"!="" {
  **qui imposto l'intestazione delle colonne
  **nella prima colonna ci va la categorica
  **nella seconda o la descrizione delle statistiche (c(v)) o a. la descrizione delle variabili (c(s)) o b. il nome delle variabili

  if "`intc1'" != "" local int_cols = "`intc1'"
  else local int_cols = "`: variable label `byvar''"

  if "`columns'" == "variables" {
    if "`intc2'"=="" local intc2 = "Statistiche"
    local int_cols = "`int_cols' & `intc2' "
    if "`vardisp'" == "varlabel" {
      foreach i in `varlist' {
      local int_cols = `" `int_cols' & `: variable label `i'' "'
      }
    }
    else {
      foreach i in `cols_int_tex' {
      local int_cols = `"`int_cols' & `i' "'
      }
    }
  }


  else { /* "`columns'" == "statistics"  */
    if "`vardisp'"!="none" {
      if "`intc2'"=="" local intc2 = "Variabili"
      local int_cols = "`int_cols' & `intc2' "
    }
    local j=1
    foreach i in `cols_int' {
      if "`s1'" == "" {
        if "`i'"=="mean" local ii="Media"
        else if "`i'"=="count" local ii="Numero di osservazioni"
        else if "`i'"=="n" local ii="Numero di osservazioni"
        else if "`i'"=="sum" local ii="Sommatoria"
        else if "`i'"=="max" local ii="Massimo"
        else if "`i'"=="min" local ii="Minimo"
        else if "`i'"=="range" local ii="Massimo - Minimo"
        else if "`i'"=="sd" local ii="Deviazione standard"
        else if "`i'"=="variance" local ii="Varianza"
        else if "`i'"=="cv" local ii="Coefficente di variazione"
        else if "`i'"=="semean" local ii="Errore standard della media"
        else if "`i'"=="skewness" local ii="Simmetria"
        else if "`i'"=="kurtosis" local ii="Curtosi"
        else if "`i'"=="p1" local ii="1\degree \ percentile"
        else if "`i'"=="p5" local ii="5\degree \ percentile"
        else if "`i'"=="p10" local ii="10\degree \ percentile"
        else if "`i'"=="p25" local ii="25\degree \ percentile"
        else if "`i'"=="median" local ii="Mediana"
        else if "`i'"=="p50" local ii="50\degree \ percentile"
        else if "`i'"=="p75" local ii="75\degree \ percentile"
        else if "`i'"=="p90" local ii="90\degree \ percentile"
        else if "`i'"=="p95" local ii="95\degree \ percentile"
        else if "`i'"=="p99" local ii="99\degree \ percentile"
        else if "`i'"=="iqr" local ii="Range interquartile"
        local int_cols = `"`int_cols' & `ii'"'
      }
    else local int_cols = `"`int_cols' & `s`j''"'
    local j `++j'
    }
  }
}

file write texfile "`int_cols' \\" _n
file write texfile "\midrule" _n













** START NO BY
if "`by'"== "" {
  if "`columns'" == "statistics" {
    matrix StatTotal_stat = StatTotal'
    local nrows = rowsof(StatTotal_stat)
      forvalues r =1(1)`nrows' {
        if "`vardisp'" == "varlabel" {
          local introw : word `r' of `varlist'
          local introw : variable label `introw'
        }
      else local introw : word `r' of `varlist'

    local rowi = "`introw' "
    forvalues c = 1(1)`ncols' {
       if "`dfs1'" != "" local cell_ij : display `dfs`c'' StatTotal_stat[`r',`c']
       else local cell_ij : display %12.2gc StatTotal_stat[`r',`c']
       local rowi = `"`rowi' & `cell_ij' "'
      }
  file write texfile "`rowi' \\" _n

    }
  }

  else { /** if "`columns'" == "variables"  **/
   matrix StatTotal = StatTotal
   local nrows = rowsof(StatTotal)
   local ncols = colsof(StatTotal)
      forvalues r =1(1)`nrows' {
        if `default_stat' == 1 {
          local i : word `r' of `statistics'
          if "`i'"=="mean" local introw="Media"
          else if "`i'"=="count" local introw="Numero di osservazioni"
          else if "`i'"=="n" local introw="Numero di osservazioni"
          else if "`i'"=="sum" local introw="Sommatoria"
          else if "`i'"=="max" local introw="Massimo"
          else if "`i'"=="min" local introw="Minimo"
          else if "`i'"=="range" local introw="Massimo - Minimo"
          else if "`i'"=="sd" local introw="Deviazione standard"
          else if "`i'"=="variance" local introw="Varianza"
          else if "`i'"=="cv" local introw="Coefficente di variazione"
          else if "`i'"=="semean" local introw="Errore standard della media"
          else if "`i'"=="skewness" local introw="Simmetria"
          else if "`i'"=="kurtosis" local introw="Curtosi"
          else if "`i'"=="p1" local introw="1\degree \ percentile"
          else if "`i'"=="p5" local introw="5\degree \ percentile"
          else if "`i'"=="p10" local introw="10\degree \ percentile"
          else if "`i'"=="p25" local introw="25\degree \ percentile"
          else if "`i'"=="median" local introw="Mediana"
          else if "`i'"=="p50" local introw="50\degree \ percentile"
          else if "`i'"=="p75" local introw="75\degree \ percentile"
          else if "`i'"=="p90" local introw="90\degree \ percentile"
          else if "`i'"=="p95" local introw="95\degree \ percentile"
          else if "`i'"=="p99" local introw="99\degree \ percentile"
          else if "`i'"=="iqr" local introw="Range interquartile"
        }
      else local introw = "`s`r''"
    local rowi = "`introw' "
    forvalues c = 1(1)`ncols' {
       if "`dfs1'" != "" local cell_ij : display `dfs`r'' StatTotal[`r',`c']
       else local cell_ij : display %12.2gc StatTotal[`r',`c']
       local rowi = `"`rowi' & `cell_ij' "'
      }
    file write texfile "`rowi' \\" _n

    }
  }

} /** END NO BY  **/





**set trace on
** START YES BY
else {
  if "`columns'" == "statistics" {
    matrix StatTotal_stat = StatTotal'
    local nrows = rowsof(StatTotal_stat)
    local ncols = colsof(StatTotal_stat)
    qui levelsof `byvar' `if', local(val_catvar)
    local j = 1 /* counter per Stat# */
    foreach k of local val_catvar {
      local label_catvar : label (`byvar') `k'
      forvalues r =1(1)`nrows' {

        if "`vardisp'"!= "none" {
          if "`vardisp'" == "variables" local introw : word `r' of `varlist'
          else local introw : variable label `: word `r' of `varlist''
          if `r'==1 local rowi = "`label_catvar' & `introw'"
          else local rowi = " & `introw' "
        }

        else if "`vardisp'"== "none"{
          if `r'==1 local rowi = "`label_catvar'"
          else local rowi = " & "
        }



        forvalues c = 1(1)`ncols' {
          if "`dfs1'" != "" local cell_ij : display `dfs`c'' Stat`j'[`r',`c']
          else  local cell_ij : display %12.2gc Stat`j'[`r',`c']
          local rowi = `"`rowi' & `cell_ij' "'
        }
      file write texfile "`rowi' \\" _n
      }
    local j `++j'
    }

    ** add totals
    if "`nototal'" == "" {
      forvalues r =1(1)`nrows' {
        if "`vardisp'"!= "none" {
          if "`vardisp'" == "variables" local introw : word `r' of `varlist'
          else local introw : variable label `: word `r' of `varlist''
          if `r'==1 local rowi = "Totale & `introw'"
          else local rowi = " & `introw' "
        }

        else if "`vardisp'"== "none"{
          if `r'==1 local rowi = "Totale "
          else local rowi = " & "
        }

        forvalues c = 1(1)`ncols' {
          matrix StatTotal_stat = StatTotal'
          if "`dfs1'" != "" local cell_ij : display `dfs`c'' StatTotal_stat[`r',`c']
          else local cell_ij : display %12.2gc StatTotal_stat[`r',`c']
          local rowi = `"`rowi' & `cell_ij' "'
        }
      file write texfile "`rowi' \\" _n
      }
    }

  }





  else { /** if "`columns'" == "variables"  **/
   local nrows = rowsof(StatTotal)
   local ncols = colsof(StatTotal)
   qui levelsof `byvar' `if', local(val_catvar)
   local j = 1 /* counter per Stat# */
   foreach k of local val_catvar {
     local label_catvar : label (`byvar') `k'
      forvalues r =1(1)`nrows' {
        if `default_stat' == 1 {
          local i : word `r' of `statistics'
          if "`i'"=="mean" local introw="Media"
          else if "`i'"=="count" local introw="Numero di osservazioni"
          else if "`i'"=="n" local introw="Numero di osservazioni"
          else if "`i'"=="sum" local introw="Sommatoria"
          else if "`i'"=="max" local introw="Massimo"
          else if "`i'"=="min" local introw="Minimo"
          else if "`i'"=="range" local introw="Massimo - Minimo"
          else if "`i'"=="sd" local introw="Deviazione standard"
          else if "`i'"=="variance" local introw="Varianza"
          else if "`i'"=="cv" local introw="Coefficente di variazione"
          else if "`i'"=="semean" local introw="Errore standard della media"
          else if "`i'"=="skewness" local introw="Simmetria"
          else if "`i'"=="kurtosis" local introw="Curtosi"
          else if "`i'"=="p1" local introw="1\degree \ percentile"
          else if "`i'"=="p5" local introw="5\degree \ percentile"
          else if "`i'"=="p10" local introw="10\degree \ percentile"
          else if "`i'"=="p25" local introw="25\degree \ percentile"
          else if "`i'"=="median" local introw="Mediana"
          else if "`i'"=="p50" local introw="50\degree \ percentile"
          else if "`i'"=="p75" local introw="75\degree \ percentile"
          else if "`i'"=="p90" local introw="90\degree \ percentile"
          else if "`i'"=="p95" local introw="95\degree \ percentile"
          else if "`i'"=="p99" local introw="99\degree \ percentile"
          else if "`i'"=="iqr" local introw="Range interquartile"
        }
        else local introw = "`s`r''"
        if `r'==1 local rowi = "`label_catvar' & `introw'"
        else local rowi = " & `introw' "
      forvalues c = 1(1)`ncols' {
         if "`dfs1'"!="" local cell_ij : display `dfs`r'' Stat`j'[`r',`c']
         else local cell_ij : display %9.2gc Stat`j'[`r',`c']
         local rowi = `"`rowi' & `cell_ij' "'
        }
    file write texfile "`rowi' \\" _n
    }
   local j `++j'
   }
   ** add totals
   if "`nototal'" == "" {
     forvalues r =1(1)`nrows' {
       if `default_stat' == 1 {
         local i : word `r' of `statistics'
         if "`i'"=="mean" local introw="Media"
         else if "`i'"=="count" local introw="Numero di osservazioni"
         else if "`i'"=="n" local introw="Numero di osservazioni"
         else if "`i'"=="sum" local introw="Sommatoria"
         else if "`i'"=="max" local introw="Massimo"
         else if "`i'"=="min" local introw="Minimo"
         else if "`i'"=="range" local introw="Massimo - Minimo"
         else if "`i'"=="sd" local introw="Deviazione standard"
         else if "`i'"=="variance" local introw="Varianza"
         else if "`i'"=="cv" local introw="Coefficente di variazione"
         else if "`i'"=="semean" local introw="Errore standard della media"
         else if "`i'"=="skewness" local introw="Simmetria"
         else if "`i'"=="kurtosis" local introw="Curtosi"
         else if "`i'"=="p1" local introw="1\degree \ percentile"
         else if "`i'"=="p5" local introw="5\degree \ percentile"
         else if "`i'"=="p10" local introw="10\degree \ percentile"
         else if "`i'"=="p25" local introw="25\degree \ percentile"
         else if "`i'"=="median" local introw="Mediana"
         else if "`i'"=="p50" local introw="50\degree \ percentile"
         else if "`i'"=="p75" local introw="75\degree \ percentile"
         else if "`i'"=="p90" local introw="90\degree \ percentile"
         else if "`i'"=="p95" local introw="95\degree \ percentile"
         else if "`i'"=="p99" local introw="99\degree \ percentile"
         else if "`i'"=="iqr" local introw="Range interquartile"
      }
      else local introw = "`s`r''"
      if `r'==1 local rowi = "Totale & `introw'"
      else local rowi = " & `introw' "
      forvalues c = 1(1)`ncols' {
        if "`dfs1'"!="" local cell_ij : display `dfs`c'' StatTotal[`r',`c']
        else local cell_ij : display %9.2gc StatTotal[`r',`c']
        local rowi = `"`rowi' & `cell_ij' "'
      }
     file write texfile "`rowi' \\" _n
    }
   }
  }


}
** END YES BY


file write texfile  "\bottomrule" _n

if "`note'" != "" file write texfile "\multicolumn{`table_ncols'}{l}{\scriptsize{`note'}}" _n
**\scriptsize or \footnotesize
**di "\end{tabular}"
file write texfile  "\end{tabularx}" _n

if "`landscape'" != "" file write texfile "\end{sidewaystable}" _n
else file write texfile  "\end{table}" _n
file write texfile  "\end{center}" _n

if "`texfile'" != "" file close texfile

**capture log off "`r(filename)'"

end
