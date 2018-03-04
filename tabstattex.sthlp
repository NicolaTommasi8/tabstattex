{smcl}
{hline}
help for {hi:tabstattex}
{hline}

{title:Esporta l'output di tabstat in LaTex}

{p 8 12 2}
{cmd:tabstattex} {it:varlist} {ifin} [{cmd:,} {help tabstattex##tabstatopt:{it:tabstat_options}}]  {help tabstattex##latexopt:{it:latex_options}}



{title:Description}

{p 4 4 2}{cmd:tabstattex} permette di esportare in LaTex l'output del comando {cmd:tabstat}. {it:varlist} è la lista delle variabili di cui si vogliono esportare le statistiche.
Per funzionare correttamente nel preambolo del documento LaTex devono essere specificate le seguenti direttive:

{synopt:{space 4}\usepackage{tabularx}}{p_end}
{synopt:{space 4}\usepackage{array}}{p_end}
{synopt:{space 4}\usepackage{gensymb}}{p_end}
{synopt:{space 4}\usepackage[italian]{babel}}{p_end}
{synopt:{space 4}\renewcommand{\arraystretch}{1.1}}{p_end}
{synopt:{space 4}\newcolumntype{Z}{>{\centering\arraybackslash}X}}{p_end}



{marker tabstatopt}{title:tabstat options}

{p 4 8 2}{cmd:by(varname)}: specifica che le statistiche di {it:varlist} devono essere visualizzate condizionando per la variabile specificata in {cmd:by(varname)}

{p 4 8 2}{cmdab:s:tatistics(}{it:statname}{cmd:)}: specifica quali statistiche devono essere visualizzate. Se non si specifica nulla viene calcolata la sola media. Ogni statistica deve essere separata da uno spazio. Le possibili statistiche sono:

{synoptset 17}{...}
{synopt:{space 4}{it:statname}}Definizione{p_end}
{space 4}{synoptline}
{synopt:{space 4}{opt me:an}} media{p_end}
{synopt:{space 4}{opt co:unt}} numero di osservazioni non missing{p_end}
{synopt:{space 4}{opt n}} uguale a {cmd:count}{p_end}
{synopt:{space 4}{opt su:m}} sommatoria{p_end}
{synopt:{space 4}{opt ma:x}} massimo{p_end}
{synopt:{space 4}{opt mi:n}} minimo{p_end}
{synopt:{space 4}{opt r:ange}} range = {opt max} - {opt min}{p_end}
{synopt:{space 4}{opt sd}} standard deviation{p_end}
{synopt:{space 4}{opt v:ariance}} varianza{p_end}
{synopt:{space 4}{opt cv}} coefficiente di variatione ({cmd:sd/mean}){p_end}
{synopt:{space 4}{opt sem:ean}} standard error della media ({cmd:sd/sqrt(n)}){p_end}
{synopt:{space 4}{opt sk:ewness}} simmetria{p_end}
{synopt:{space 4}{opt k:urtosis}} curtosi{p_end}
{synopt:{space 4}{opt p1}} 1° percentile{p_end}
{synopt:{space 4}{opt p5}} 5° percentile{p_end}
{synopt:{space 4}{opt p10}} 10° percentile{p_end}
{synopt:{space 4}{opt p25}} 25° percentile{p_end}
{synopt:{space 4}{opt med:ian}} mediana (equivalente a  {opt p50}){p_end}
{synopt:{space 4}{opt p50}} 50° percentile (equivalente a {opt median}){p_end}
{synopt:{space 4}{opt p75}} 75° percentile{p_end}
{synopt:{space 4}{opt p90}} 90° percentile{p_end}
{synopt:{space 4}{opt p95}} 95° percentile{p_end}
{synopt:{space 4}{opt p99}} 99° percentile{p_end}
{synopt:{space 4}{opt iqr}} range interquartile = {opt p75} - {opt p25}{p_end}
{synopt:{space 4}{opt q}} equivale a specificare {cmd:p25 p50 p75}{p_end}
{space 4}{synoptline}
{p2colreset}{...}

{p 4 8 2}{cmdab:c:olumns(}{cmdab:v:ariables|}{cmdab:s:tatistics)}: specifica cosa deve essere visulizzato in colonna. {cmd:variables} visualizza le variabili di {it:varlist} (opzione di default), {cmd:statistics}
visualizza le statistiche specificate nell'opzione {cmd:statistics({it:statname})}.

{p 4 8 2}{opt f:ormat}{cmd:(%}{it:{help format:fmt}}{cmd:)} specifica il formato generale di visualizzazione delle statistiche. Il formato di default è {cmd:%12.2gc}.

{p 4 8 2}{opt not:otal} non visualizza le statistiche generali; si usa sole se viene specificata l'opzione {opt by(varname)}.

{p 4 8 2}{opt m:issing} visualizza le statistiche anche per i valori missing della variabile {opt by(varname)}.



{marker latexopt}{title:latex options}

{p 4 8 2}{cmd:texfile(filename)}: specifica il file .tex (ed eventuale percorso) in cui salvare il codice della tabella. Questa opzione è obbligatoria.

{p 4 8 2}{cmd:replace}: specifica di sovrascrivere il file indicato in {cmd:texfile(filename)}.

{p 4 8 2}{cmd:caption(string)}: specifica il testo da inserire nell'opzione \caption{} del pacchetto table di LaTex. Di default è vuoto.

{p 4 8 2}{cmd:label(string)}: specifica il testo da inserire nell'opzione \label{} del pacchetto table di LaTex. Il comando prevede il prefisso tbl: per cui l'opzione {cmd:label(Tab1)} produce il codice Latex \label{tbl:Tab1}.

{p 4 8 2}{cmd:position(string)}: specifica la posizione della tabella secondo le regole LaTex. Il default è {cmd:position(!htp)}

{p 4 8 2}{cmd:intc1(string)}: specifica il testo da inserire come descrizione della prima colonna della tabella. In assenza dell'opzione {opt by(varname)} nella prima colonna ci possono essere le
variabili o le statistiche, dipende da cosa specificato nell'opzione {cmd:columns()} e in questo caso di default {cmd:intc1()} è vuoto. Se viene specificata l'opzione {opt by(varname)},
nella prima colonna ci sono i valori della variabile {opt varname} e di default in {cmd:intc1()} c'è la descrizione associata a {opt varname}.

{p 4 8 2}{cmd:intc2(string)}: specifica il testo da inserire come descrizione della seconda colonna della tabella e si applica solo nel caso in cui sia specificata l'opzione {cmd:by(varname)}.
Se l'opzione {cmd:columns()} è {cmd:variables} il default è {cmd:intc2(Statistiche)}, se l'opzione {cmd:columns()} è {cmd:statistics} il default è {cmd:intc2(Variabili)}.

{p 4 8 2}{cmd:note(string)}: specifica il testo da inserire come nota a piè di tabella. Di default è vuoto.

{p 4 8 2}{cmd:widthtable(string)}: specifica la larghezza della tabella da esprimersi con un valore numerico ed una unità di misura (ad esempio {cmd:widthtable(5cm)}). Di default vale \textwidth e significa che la larghezza della tabella equivale ai margini della pagina.
Le unità di misura possibili sono pt, mm, cm, in, ex ed em.

{p 4 8 2}{cmd:landscape}: specifica che la tabella deve essere orientata in orizzontale rispetto alla pagina.

{p 4 8 2}{cmd:fontsize(string)}: specifica la dimensione del font da usare nella tabella. I valori ammessi sono quelli di LaTex, cioè Huge, huge, LARGE, Large, large, normalsize (default), small, footnotesize, scriptsize e tiny.
Si veda la documentazione di LaTex per maggiori informazioni.

{p 4 8 2}{cmd:vardisp(varlabel|varname)}: specifica come visualizzare le variabili specificate in {it:varlist}. {cmd:vardisp(varlabel)} visualizza la descrizione associata a ciascuna variabile,
{cmd:vardisp(varname)} visualizza solo il nome della variabile. {cmd:vardisp(varlabel)} è il default.

{p 4 8 2}{cmd:s1(string)...s10(string)}: specifica la descrizione delle statistiche indicate nell'opzione {cmd:statistics({it:statname})}. L'ordine deve essere quello di {it:statname}, ovvero
{cmd:s1()} indica la descrizione della prima statistica di {cmd:statistics({it:statname})}, {cmd:s2()} indica la descrizione della seconda statistica di {cmd:statistics({it:statname})} e così via.
Queste sono le descrizioni di default:

{synoptset 17}{...}
{synopt:{space 4}{it:statname}}Descrizione{p_end}
{space 4}{synoptline}
{synopt:{space 4}{opt mean}} Media{p_end}
{synopt:{space 4}{opt count}} Numero di osservazioni{p_end}
{synopt:{space 4}{opt n}} Numero di osservazioni{p_end}
{synopt:{space 4}{opt sum}} Sommatoria{p_end}
{synopt:{space 4}{opt max}} Massimo{p_end}
{synopt:{space 4}{opt min}} Minimo{p_end}
{synopt:{space 4}{opt range}} Massimo - Minimo{p_end}
{synopt:{space 4}{opt sd}} Deviazione standard{p_end}
{synopt:{space 4}{opt variance}} Varianza{p_end}
{synopt:{space 4}{opt cv}} Coefficiente di variatione{p_end}
{synopt:{space 4}{opt semean}} Errore standard della media{p_end}
{synopt:{space 4}{opt skewness}} Simmetria{p_end}
{synopt:{space 4}{opt kurtosis}} Curtosi{p_end}
{synopt:{space 4}{opt p1}} 1° percentile{p_end}
{synopt:{space 4}{opt p5}} 5° percentile{p_end}
{synopt:{space 4}{opt p10}} 10° percentile{p_end}
{synopt:{space 4}{opt p25}} 25° percentile{p_end}
{synopt:{space 4}{opt median}} Mediana{p_end}
{synopt:{space 4}{opt p50}} 50° percentile{p_end}
{synopt:{space 4}{opt p75}} 75° percentile{p_end}
{synopt:{space 4}{opt p90}} 90° percentile{p_end}
{synopt:{space 4}{opt p95}} 95° percentile{p_end}
{synopt:{space 4}{opt p99}} 99° percentile{p_end}
{synopt:{space 4}{opt iqr}} Range interquartile{p_end}
{space 4}{synoptline}
{p2colreset}{...}

{p 4 8 2}{cmd:dfs1(string)...dfs10(string)}: specifica il formato numerico delle statistiche indicate nell'opzione {cmd:statistics({it:statname})}. L'ordine deve essere quello di {it:statname}, ovvero
{cmd:dfs1()} indica il formato della prima statistica di {cmd:statistics({it:statname})}, {cmd:dfs2()} indica il formato della seconda statistica di {cmd:statistics({it:statname})} e così via.
La sintassi del formato è la medesima di Stata per i formati numerici. A tal prosito si veda l'help di {cmd:{help format:format}}.



{title:Examples}

{p 4 8 2}{cmd:. tabstattex price weight mpg rep78, stat(n mean cv q) col(stat) texfile(ex1.tex) replace dfs1(%9.0f) dfs2(%9.2f) dfs3(%9.2f) dfs4(%9.0f) dfs5(%9.0f) dfs6(%9.0f)}{p_end}

{p 4 8 2}{cmd:. tabstattex price weight mpg rep78, stat(n mean cv q) col(stat) col(v) texfile(ex1.tex) replace dfs1(%9.0f) dfs2(%9.2f) dfs3(%9.2f) dfs4(%9.0f) dfs5(%9.0f) dfs6(%9.0f)}{p_end}

{p 4 8 2}{cmd:. tabstattex price weight mpg rep78, stat(n mean cv q) col(v) texfile(ex2bis.tex) replace ///}{p_end}
{p 6 8 2}{cmd:s1(Nonmissing observations) s2(Mean) s3(Coefficient of variation) s4(25th percentile) s5(50th percentile) s6(75th percentile) ///}{p_end}
{p 6 8 2}{cmd:dfs1(%9.0f) dfs2(%9.2f) dfs3(%9.2f) dfs4(%9.0f) dfs5(%9.0f) dfs6(%9.0f) }{p_end}

{p 4 8 2}{cmd:. tabstattex price weight mpg rep78, by(foreign) stat(mean sd min max) texfile(ex3.tex) replace dfs1(%9.2f) dfs2(%9.2f) dfs3(%9.0f) dfs4(%9.0f)}{p_end}

{p 4 8 2}{cmd:. tabstattex price weight mpg rep78, by(foreign) stat(mean sd min max) c(s) texfile(ex3bis.tex) replace dfs1(%9.2f) dfs2(%9.2f) dfs3(%9.0f) dfs4(%9.0f)}{p_end}



{title:Author}

{p 4 4 2}Nicola Tommasi{break}
nicola.tommasi@univr.it{break}
nicola.tommasi@gmail.com


{title:Acknowledgments}

{p 4 4 2}



{title:References}




{title:Also see}

{p 4 13 2}Online:
{help tabstat},
{help tabstatxls} (if installed)
