### Výběr jazyka

- English: [![en](https://img.shields.io/badge/lang-en-red.svg)](https://github.com/jantumajer/TACR-TreeDataClim/blob/main/README.md)
- Čeština: [![cz](https://img.shields.io/badge/lang-cz-yellow.svg)](https://github.com/jantumajer/TACR-TreeDataClim/blob/main/README.cz.md)



# Software "TreeDataClim"

### Autorský kolektiv
Funkce v tomto repozitáři byly vyvinuty pro hodnocení růstových trendů, intenzity klimatického limitování přírůstu a identifikaci extrémních růstových propadů pro nejvýznamnější druhy lesních dřevin na území České republiky. Jejich funkcionalita byla navržena pro zpracování letokruhových sérií (řad šířek letokruhů v jednotlivých letech) uložených v [databázi TreeDataClim](https://treedataclim.cz/). Mezi přispěvatele dat do této databáze patří především:
- [Univerzita Karlova, Přírodovědecká fakulta, laboratoř Dendroekologie](https://web.natur.cuni.cz/physgeo/dendro/)
- [Odbor ekologie lesa, Výzkumný ústav Silva Taroucy, tým Blue Cat](https://pralesy.cz/lide)
- Výzkumný ústav lesního hospodářství a myslivosti
- Mendelova univerzita v Brně, Lesnická a dřevařská fakulta
- [Česká zemědělská univerzita Praha, Lesnická a dřevařská fakulta, Katedra ekologie lesa](https://www.remoteforests.org/?language=en)
- Botanický ústav Akademie věd České republiky
- Univerzita Jana Evangelisty Purkyně v Ústí nad Labem, Fakulta životního prostředí

![obrazek](https://user-images.githubusercontent.com/25429975/235666459-c20a2ca5-748a-42ad-8c4c-44b9c8034a04.png)

### Poděkování
Repozitář obsahuje skripty a funkce vyvinuté v rámci projektu financovaného TAČR SS03010134 *Databáze letokruhových chronologií jako nástroj pro evidenci a predikci reakce hlavních lesních dřevin na klimatickou změnu*.

Vývoj modifikované verze procesního modelu tvorby dřeva VS-Lite byl do značné míry inspirován prací Dr. Suzan Tolwinski-Ward, především kódy původního modelu v jazyce Octave, které jsou k dispozici na adrese [NOAA](https://www.ncei.noaa.gov/access/paleo-search/study/9894). Další funkce vyvinuté v prostředí R pro jednotlivé kroky zpracování dat a vykreslování grafů využívají několik veřejně dostupných balíčků . Autorům těchto balíčků děkujeme za jejich volné zpřístupnění.

### Použití
Tento repozitář představuje kompilaci samostatných funkcí, které byly vyvinuty ke zpracování letokruhových dat podle metodiky projektu TreeDataClim. Jednotlivé funkce jsou seskupeny v následujících složkách:
- `Reductions`: funkce pro identifikaci, vyhodnocení a extrapolaci událostí extrémního snížení růstu
- `Limitations`: procesní model dynamiky tvorby dřeva a jeho aplikace k hodnocení typu a intenzity klimatického limitování tvorby dřeva v měsíčním kroku
- `Trends`: funkce pro vyhodnocení růstových trendů a extrapolaci jejich prostorového rozsahu
- `Misc (aka miscellaneous)`: funkce pro předzpracování dendrochronologických dat, vykreslování klimatických diagramů

Každá složka obsahuje samostatné soubory readme detailně vysvětlující postup použití jednotlivých funkcí. Většina funkcí byla vytvořena v jazyce [R](https://www.r-project.org/) s výjimkou procesního modelu tvorby dřeva VS-Lite, který je napsán v jazyce [Octave](https://octave.org/). Oba jazyky jsou open-source. Pro aplikaci našich skriptů doporučujeme používat nejnovější verze obou programovacích prostředí.

Funkce byly vyvinuty a testovány s ohledem na datovou sadu a metodiku TreeDataClim, tj. hustou síť časových řad šířek letokruhů na území České republiky. Jednotlivé funkce však lze přímo aplikovat na jakoukoli jinou oblast světa s dostupnými letokruhovými časovými řadami. Funkce analyzují růstové trendy, klimatické limitování přírůstu a prudké propady v přírůstu za období 1961-2010, které představuje v rámci TreeDataClim databáze optimální rovnováhu mezi počtem dostupných ploch a spolehlivostí klimatických veličin. Podrobnosti o požadovaných vstupech a způsobu použití jednotlivých funkcí jsou uvedeny jako anotace v konkrétním skriptu. Některé funkce vyžadují předchozí instalaci open-source balíčků a rozšíření jak v jazyce R, tak v jazyce Octave. Požadované balíčky a rozšíření jsou taktéž uvedeny na začátku každého skriptu.

### Vstupní data
Jednotlivé funkce slouží ke zpracování letokruhových dat podle metodiky vyvinuté v rámci projektu TreeDataClim. Nároky na vstupní data a jejich očekávaná struktura se liší podle jednotlivých funkcí a jsou specifikovány vždy na začátku každého skriptu. Příklad struktury každého vstupního souboru naleznete ve složce `Input`. Tato složka obsahuje ukázková data ze 16 lokalit dvou druhů (*Picea abies* a *Quercus robur*) rozmístěných v severní části České republiky.

### Kontakt, hlášení chyb
`Jan Tumajer` tumajerj@natur.cuni.cz

Univerzita Karlova, Přírodovědecká fakulta, Katedra Fyzické Geografie a Geoekologie, Albertov 6, 12843 Praha, Česká Republika



`Jakub Kašpar` kaspar@vukoz.cz

Odbor ekologie lesa, Výzkumný ústav Silva Taroucy
