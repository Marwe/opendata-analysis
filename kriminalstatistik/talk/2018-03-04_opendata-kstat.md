% Kriminalstatistik visualisieren
% Martin Weis
% Open Data Day 2018-03-03

# Kriminalstatistik

## Quelle

Polizei­liche Kriminal­statistik (PKS) des Bundeskriminalamtes (BKA)
* [PKS 2015](https://www.bka.de/DE/AktuelleInformationen/StatistikenLagebilder/PolizeilicheKriminalstatistik/PKS2015/pks2015_node.html)
* [PKS 2016](https://www.bka.de/DE/AktuelleInformationen/StatistikenLagebilder/PolizeilicheKriminalstatistik/PKS2016/pks2016_node.html)

---

## Bedeutung, Inhalt, Aussagekraft

> Die PKS enthält die der Polizei bekannt gewordenen rechtswidrigen Straftaten einschließlich der mit Strafe bedrohten Versuche, die Anzahl der ermittelten Tatverdächtigen und eine Reihe weiterer Angaben zu Fällen, Opfern oder Tatverdächtigen.

> Nicht enthalten sind

> * Staatsschutzdelikte
> * Verkehrsdelikte
> * Ordnungswidrigkeiten
> * Delikte, die nicht zum Aufgabenbereich der Polizei gehören (z.B. Finanz- und Steuerdelikte) und
Straftaten, die unmittelbar bei der Staatsanwaltschaft angezeigt werden.

---

## Lizenz, Quellenangabe

Die Nutzung der Daten (vollständig oder auszugsweise) ist nur mit Quellenangabe (PKS Bundeskriminalamt, Angabe der Version) zulässig. 
Es gilt die Datenlizenz Deutschland - Namensnennung - Version 2.0 
> https://www.govdata.de/dl-de/by-2-0

---

## Hinweise

Auf den Seiten des BKA gibt es einige Hinweise zu den Daten, die bei einer Interpretation herangezogen werden sollten, z.B. [PKS 2015 - Wichtige Hinweise zu den Tabellen](https://www.bka.de/SharedDocs/Downloads/DE/Publikationen/PolizeilicheKriminalstatistik/2015/pks2015wichtigeHinweise_pdf.pdf;jsessionid=E0B3AF31DC86EB1E4EF4ADF0CB50E661.live2291?__blob=publicationFile&v=3)

> Bei sogenannten Kontrolldelikten (Ein Kontrolldelikt ist eine Straftat, deren Auftreten durch Kontrollen von
Polizei oder Sicherheitspersonal überhaupt erst festgestellt wird - ohne Kontrolle bleibt sie unbemerkt) wie
z.B. Beförderungserschleichung (515001), Ladendiebstahl (326000) oder Verstöße gegen das Betäubungs-
mittelgesetz (730000) liegen die Ursachen für Anstiege bzw. Rückgänge im Umfang der im jeweiligen Be-
richtsjahr durchgeführten Kontrollen begründet.

---

## Hinweise (Auszug)

> Infolge des Zustroms von Asylbewerbern und Flüchtlingen waren im PKS-Jahr 2015 außergewöhnliche
Steigerungen im Deliktsbereich AufenthaltsG/AsylverfahrensG/FreizügigkeitsG-EU (Schlüssel 725000) zu
verzeichnen (+ 246.345 Fälle, 157,5%), was sich in dem Anstieg der Fallzahl bei Straftaten insgesamt um
4,1 % von 6.082.064 auf 6.330.649 Fälle) niederschlägt.
Der Umstand, dass es sich vorwiegend um sog. Formalverstöße handelt, die von den Staatsanwaltschaften
zumeist eingestellt werden, wirkt sich in der PKS nicht aus (s. Ziff. 4.3 PKS-Richtlinien).

---

## Hinweise (Auszug)

> Diebstahl insgesamt von/aus Automaten (***700) Rheinland-Pfalz
> Ein Teil des Anstieges ist auf einen TV zurückzuführen, der im nördli-
chen Rheinland-Pfalz überwiegend Kaugummi- und Zigarettenautoma-
ten aufbrach

# Aufbereiten, Visualisieren

## R-project

* Die Auswertung wurde mit [R](https://www.r-project.org/) durchgeführt.
* Quellcode im git repository [github.com/Marwe/opendata-analysis/](https://github.com/Marwe/opendata-analysis/)
* Text in Markdown, R-Code und Text in einem Dokument, so dass direkt ein html erstellt werden kann (`rmarkdown` und Paket `pander`)
`rmarkdown::render("kstat.R")`

> Verwendete Pakete:
> require("ggplot2")
> require("reshape2")
> require("dplyr")
> require("pander")
> panderOptions('table.split.table', Inf)
> panderOptions('table.style', 'rmarkdown')

## Daten 2015/2016

`gunzip -k -c tb01__FaelleGrundtabelleAb1987__csv.csv.gz | head`

~~~
1;2;3;4;5;6;7;8;9;10;11;12;13;14
Schluesse;Straftat;Jahr;erfasste Faelle;HZ vor Zensus bis 2013;HZ nach Zensus ab2013;Versuche - Anzahl;Versuche - Anteil in %;mit Schusswaffe gedroht;mit Schusswaffe geschossen;Aufklaerungsquote in %;Tatverdaechtige insgesamt;Nichtdeutsche Tatverdaechtige - Anzahl;Nichtdeutsche Tatverdaechtige - Anteil in %
------;Straftaten insgesamt;1987;4444108;7268.7;-;382623;8.6;6564;5429;44.2;1290441;258329;20
------;Straftaten insgesamt;1988;4356726;7114.4;-;371110;8.5;6639;4976;45.9;1314080;286741;21.8
~~~

`gunzip -k -c ZR-F-01-T01_csv.csv.gz | head`

~~~
1;2;3;4;5;6;7;8;9;10;11;12;13;14
Schluesse;Straftat;Jahr;erfasste Faelle;HZ vor Zensus bis 2013;HZ nach Zensus ab2013;Versuche - Anzahl;Versuche - Anteil in %;mit Schusswaffe gedroht;mit Schusswaffe geschossen;Aufklaerungsquote in %;Tatverdaechtige insgesamt;Nichtdeutsche Tatverdaechtige - Anzahl;Nichtdeutsche Tatverdaechtige - Anteil in %
------;Straftaten insgesamt;1987;4,444,108;7,268.70;-;382,623;8.6;6,564;5,429;44.2;1,290,441;258,329;20
------;Straftaten insgesamt;1988;4,356,726;7,114.40;-;371,110;8.5;6,639;4,976;45.9;1,314,080;286,741;21.8
~~~

## Änderungen in CSV von 2015/2016

Das Script steigt bei den neuen Daten aus mit:
 
 > Fehler in summarise_impl(.data, dots) : 
 > Evaluation error: 'max' not meaningful for factors.

~~~
str(kd)
'data.frame':	11289 obs. of  14 variables:
 $ erfasste.Fälle                       : Factor w/ 7027 levels "0","1","10","100",..: 4450 4393 4395 4456 4677 4947 5802 5673 5751 5743 ...
~~~

Oops, warum sind das plötzlich *Factors*? Vorher:

~~~
str(okd)
'data.frame':	10475 obs. of  14 variables:
$ erfasste.Fälle                       : int  4444108 4356726 4358573 4455333 4752175 5209060 6750613 6537748 6668717 6647598 ...
~~~
