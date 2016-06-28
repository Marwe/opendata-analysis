#' ---
#' title: "Kriminalstatistik grafisch 2016"
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
#' immer wieder der Eindruck geweckt wird, dass die Kriminalität ansteigt. 
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
#' http://www.bka.de/DE/Publikationen/PolizeilicheKriminalstatistik/pks__node.html
#'  http://www.bka.de/DE/Publikationen/PolizeilicheKriminalstatistik/2015/2015Zeitreihen/pks2015ZeitreihenFaelleUebersicht.html
#'  http://www.bka.de/SharedDocs/Downloads/DE/Publikationen/PolizeilicheKriminalstatistik/2015/Zeitreihen/Faelle/tb01__FaelleGrundtabelleAb1987__csv,templateId=raw,property=publicationFile.csv/tb01__FaelleGrundtabelleAb1987__csv.csv
#' 
#' Die Nutzung der Daten (vollständig oder auszugsweise) ist nur mit Quellenangabe (PKS Bundeskriminalamt, Angabe der Version) zulässig. 
#' Es gilt die Datenlizenz Deutschland - Namensnennung - Version 2.0 
#' > https://www.govdata.de/dl-de/by-2-0
#'
#' render script in R with ```rmarkdown::render("kstat.R")```

if (!exists("maxplots")){maxplots=20000}

require("ggplot2")
require("reshape2")
require("dplyr")
require("pander")
panderOptions('table.split.table', Inf)
panderOptions('table.style', 'rmarkdown')

csvfilename="tb01__FaelleGrundtabelleAb1987__csv.csv.gz"

kd<-read.csv(csvfilename,sep=";",
             skip=1,
             header=TRUE,
             encoding="latin1")

kd.header<-as.vector(t(read.csv(csvfilename,sep=";",
             skip=1,
             header=FALSE,
             nrows=1,
             encoding="latin1")))

#pandoc.table(kd[1:4,], style = "grid", caption = "First lines of source data")
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
plotkstat<-function(kd,sortst=NA,maxplots=99999999){
    plotcnt=0
    if (is.na(sortst)){sortst=unique(kd$Straftat);}
    for (s in sortst){
        plotcnt=plotcnt+1
        if (plotcnt>=maxplots){break;}
        # TODO: output rmarkdown header here
        # cat('#',s,'\n\n')
        #' `{r} cat('#',h,'\n')`
        
        pandoc.header(paste('[',plotcnt,']:',s))
        
        pdat<-kd[kd$Straftat==s,]#filter(kd,Straftat==s)
        
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
