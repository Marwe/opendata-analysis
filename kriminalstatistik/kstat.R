#' ---
#' title: "Kriminalstatistik grafisch 2017"
#' author: "Martin Weis"
#' output: 
#'     html_document:
#'         toc: true
#'         toc_depth: 3
#'         fig_caption: true
#'         code_folding: hide
#'         self_contained: false
#'     pdf_document:
#'         toc: true
#'         toc_depth: 3
#' ---

#' # Einleitung
#' 
#' In diesem Dokument werden Plots der Rohdaten der Kriminalstatistik des BKA 
#' erstellt. Aus der Fragestellung heraus, dass in der öffentlichen Wahrnehmung, z.B. durch Aussagen in TV-Shows und anderen Medienberichten 
#' immer wieder der Eindruck erweckt wird, dass die Kriminalität ansteigt. 
#' In letzter Zeit häufen sich darüberhinaus Aussagen, die eine erhöhte Kriminalität von Ausländern darstellen.
#' Diese Aussagen werden nach meiner Wahrnehmung zunehmend nicht nur von Populisten, sondern auch Politikern und Beamten gemacht, die eigentlich entsprechenden Zuganng zu den Zahlen haben sollten.
#' 
#' ## Erster Eindruck
#' 
#' Der erste Eindruck ist: die Fallzahlen gehen fast überall zurück, eine erhöhte Angst und Panikmache sind daher nicht angemessen. 
#' Das gilt besonders für die oft öffentlichkeitswirksam dargestellten Teilbereiche Diebstahl (verschiedene Arten), Einbruch und Straßenkriminalität, 
#' die aufgrund des insgesamt hohen Niveaus der Fallzahlen m.E. Relevanz haben und recht zuverlässig Trends zeigen.
#' 
#' Hingegen zeigen verschiedene Körperverletzungsdelikte eine steigende Tendenz. 
#' Hier wäre zu klären, ob es sich um tatsächlich stark ansteigende Fallzahlen handelt, oder ob der Anstieg aus einer größeren Bereitschaft zur Anzeige resultiert (hohe Dunkelziffer).
#' 
#' ## Zur Beachtung
#' 
#' Die Zahlen scheinen erst seit 1995 soweit konsolodiert zu sein, dass sie Trends zeigen können, vorher möglicherweise inkohärente Erfassung (neue/alte Bundesländer).
#' Siehe Plot "Straftaten insgesamt"
#' Manche Grafiken zeigen nur kurze Zeitabschnitte, immer die x-Achse beachten!
#' 
#' Da sich diese Daten auf das gesamte Bundesgebiet beziehen, sind lokal anders verlaufende Fallzahlen möglich und wahrscheinlich (z.B. zeitlich/örtlich eingeschränkt ein Anstieg bei Einbrüchen).
#' 
#' ## Quellen
#' https://www.bka.de/DE/AktuelleInformationen/StatistikenLagebilder/PolizeilicheKriminalstatistik/pks_node.html
#'  http://www.bka.de/DE/Publikationen/PolizeilicheKriminalstatistik/2015/2015Zeitreihen/pks2015ZeitreihenFaelleUebersicht.html
#'  http://www.bka.de/SharedDocs/Downloads/DE/Publikationen/PolizeilicheKriminalstatistik/2015/Zeitreihen/Faelle/tb01__FaelleGrundtabelleAb1987__csv,templateId=raw,property=publicationFile.csv/tb01__FaelleGrundtabelleAb1987__csv.csv
#'  https://www.bka.de/SharedDocs/Downloads/DE/Publikationen/PolizeilicheKriminalstatistik/2023/Interpretation/Faelle/ZR-F-01-T01-Faelle_csv.csv?__blob=publicationFile&v=3
#' 
#' Die Nutzung der Daten (vollständig oder auszugsweise) ist nur mit Quellenangabe (PKS Bundeskriminalamt, Angabe der Version) zulässig. 
#' Es gilt die Datenlizenz Deutschland - Namensnennung - Version 2.0 
#' > https://www.govdata.de/dl-de/by-2-0
#'
#' Quellcode via git: [github.com/Marwe/opendata-analysis/](https://github.com/Marwe/opendata-analysis/)
#' render script in R with ```rmarkdown::render("kstat.R")```
#' 

yearversion=2016
if (!exists("maxplots")){maxplots=20000}

require("ggplot2")
require("reshape2")
require("dplyr")
require("pander")
panderOptions('table.split.table', Inf)
panderOptions('table.style', 'rmarkdown')

# header changed 2016, 
# but since order is the same, lets also read the old one and replace the names in the new
ocsvfilename="tb01__FaelleGrundtabelleAb1987__csv.csv.gz"

# 2016 (2023) data has comma as thousands separator (wtf?!?)
# https://stackoverflow.com/questions/25088144/how-to-load-df-with-1000-separator-in-r-as-numeric-class/25090565#25090565
# library(methods)
# setClass("chr.w.commas", contains=numeric())
# setAs("character", "chr.w.commas", function(from) 
#                               as.numeric(gsub("\\,", "",from )) )
# 
# kd<-read.csv("ZR-F-01-T01_csv.csv.gz", header=TRUE, skip=1, sep=";", colClasses="chr.w.commas")

# clumsy, so use preprocessing script removethousandscomma.sed
# gunzip -k -c ZR-F-01-T01_csv.csv.gz | ./removethousandscomma.sed |gzip > ZR-F-01-T01_csv_cleanup.csv.gz
# dataset until 2016, 2023
# csvfilename="ZR-F-01-T01_csv.csv.gz"
#csvfilename="ZR-F-01-T01_csv_cleanup.csv.gz"
csvfilename="2023-ZR-F-01-T01-Faelle_cleanup.csv.gz"; yearversion=2023


kd<-read.csv(csvfilename,sep=";",
             skip=1,
             header=TRUE,
             encoding="latin1",
             na.strings=c("-", "------")
             )
# , colClasses="chr.w.commas" 

# read the old header
okd<-read.csv(ocsvfilename,sep=";",
             skip=1,
             nrows=0,
             header=TRUE,
             encoding="latin1",
             na.strings=c("-", "------"))

oldheader=names(okd)
if ( 2023 == yearversion ){
    # kd header has removed the addional column "HZ.....nach.Zenus.2011.ab.2013", only HZ exists [5]
    oldheader = oldheader[! oldheader %in% c("HZ.....nach.Zenus.2011.ab.2013")]
    oldheader[5]="HZ"

}
# exchange the header
names(kd)<-oldheader

# read from OLD file
kd.header<-as.vector(t(read.csv(ocsvfilename,sep=";",
             skip=1,
             header=FALSE,
             nrows=1,
             encoding="latin1")))

#pandoc.table(kd[1:4,], style = "grid", caption = "First lines of source data")
head(okd,n=1)
head(kd,n=3)

# styp <- group_by(kd, Straftat)
# smost<-summarise(styp,mx=max(styp$erfasste.Fälle))

# transform to title-ready wrapped strings
kd$Straftat<-stringr::str_wrap(stringr::str_trim(stringr::str_replace_all(kd$Straftat,"\n"," ")),width=60)

# order by most frequent types
smost<-arrange(
                group_by(kd, Straftat) %>% 
                    summarise(mx=max(erfasste.Fälle))
               ,desc(mx))

# plot function 
plotkstat<-function(kd,sortst=NULL,maxplots=99999999){
    plotcnt=0
    if (is.null(sortst)){sortst=unique(kd$Straftat);}
    for (s in sortst){
        plotcnt=plotcnt+1
        if (plotcnt>=maxplots){break;}
        # TODO: output rmarkdown header here
        # cat('#',s,'\n\n')
        #' `{r} cat('#',h,'\n')`
        
        pandoc.header(paste('[',plotcnt,']:',s))
        
        pdat<-kd[kd$Straftat==s,]#filter(kd,Straftat==s)
        
        # adapted to 
        p<-ggplot(pdat,aes(Jahr,erfasste.Fälle, color = "Gesamtfälle"))+ 
        geom_line()+
        geom_point()+
        geom_line(aes(Jahr,Tatverdächtige.insges,color="Tatverdächtige"))+
        geom_point(aes(Jahr,Tatverdächtige.insges,color="Tatverdächtige"))+
        geom_line(aes(Jahr,Nichtdeutsche.Tatverdächtige.Anzahl,color="Nichtdeutsche Tatverdächtige"))+
        geom_point(aes(Jahr,Nichtdeutsche.Tatverdächtige.Anzahl,color="Nichtdeutsche Tatverdächtige"))+
        scale_colour_manual("", breaks = c("Gesamtfälle", "Tatverdächtige", "Nichtdeutsche Tatverdächtige"), values = c("black", "blue", "green"))+
        ggtitle(s)
        # How to break long titles?
        print(p)
        
    #     ggplot(pdat,aes(Jahr,erfasste.Fälle))+ geom_line()+ title(s)
    }
}


# pdf("kriminalstatistik_sorted.pdf")
#' # Plots nach Fallzahlen absteigend sortiert
 print(stringr::str_replace_all(unique(smost$Straftat),"\n"," "))
 plotkstat(kd,unique(smost$Straftat),maxplots)
# dev.off()

# pdf("kriminalstatistik.pdf")
#' # Plots in Originalreihenfolge

 print(stringr::str_replace_all(unique(kd$Straftat),"\n"," "))
 plotkstat(kd,unique(kd$Straftat),maxplots)
# dev.off()

# Thanks go to people freely discussing and sharing code, e.g.
# https://stackoverflow.com/questions/10349206/add-legend-to-ggplot2-line-plot
