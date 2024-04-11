# Kriminalstatistik Plots

Dokumentation ist direkt im sourcefile enthalten, Dokumenterzeugung mit

	rmarkdown::render("kstat.R")

Eine gerenderte Version ist unter 
https://kriminalstatistik.machen.click
verfügbar.

Die Daten von 2016 haben Kommas als Tausenderseparatoren, die in einer Vorprozessierung entfernt wurden (Handhabung direkt in R eher schwierig):

`gunzip -k -c ZR-F-01-T01_csv.csv.gz | ./removethousandscomma.sed |gzip > ZR-F-01-T01_csv_cleanup.csv.gz`


# 2023

`gunzip -k -c 2023-ZR-F-01-T01-Faelle_csv.csv.gz | ./removethousandscomma.sed |gzip > 2023-ZR-F-01-T01-Faelle_cleanup.csv.gz`
