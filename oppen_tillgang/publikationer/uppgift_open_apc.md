# Uppgift med OpenAPC-data (Excel)
Beräkna snitt-APC för inrapporterade svenska publikationer per förlag 2018-2022 för guld respektive hybrid-publikationer

## Excel
1. Hämta data från OpenAPC  
https://treemaps.openapc.net/apcdata/openapc/

    +  Filtrera fram svenska publikationer.
    +  Ladda ner csv-fil.

2. Importera till Excel.
    + Notera att decimalavgränsaren är punkt i nedladdad fil, kan hanteras vid import eller genom sök och ersätt.
    + Döp om kolumnen euro till apc.

3. Skapa pivot och beräkna snitt per förlag och år för förlag med fler än totalt 60 publikationer under perioden 2018-2022, för guld och hybrid-publikationer var för sig.

### Tips för pivot
Rader: publisher  
Kolumner: period  
Värden: Antal av doi   
        Medel av apc (lägga till apc och ändra fältinställningar till medel, ändra talformat till utan decimaler och med tusentalsavgränsare)  

Filter: is_hybrid  

Välj 2018-2022 från kolumnetiketter
Filtrera publisher med värdefilter Antal av doi större än 60. 

Välj olika resultat för is_hybrid för att få resultat för guld (FALSE) respektive hybrid (TRUE).

## Frågor
1. Vad ser du att du behöver tänka på vid tolkning av resultatet?
