# Uppgift Unpaywall (Excel/R)
*Hämta uppgifter från Unpaywall via API för hantering i R eller SimpleQueryTool för vidarebearbetning i Excel.   
Bearbeta data enligt KB:s klassificering i Öppen tillgång i siffror, sammanställ och jämför med sammanställning baserat på Unpaywalls klassicifiering.*

## Excel
1. Sammanställ/använd egen en lista med doi:er eller använd lista tillgänglig på kursens git. 
2. Hämta uppgifter med hjälp av Simple Query Tool  
https://unpaywall.org/products/simple-query-tool
    - Klistra in doi:er och ange egen e-postadress.
    - Välj Excel som format (eller csv då får du importera själv).
    - Submit
3. Titta på resulatet i Excel och gör en sammanställning, t.ex. med antal publikationer per typ av öppen tillgång från Unpaywall.
4. Lägg till kolumner som anger typ av ÖT enligt den klassificering som KB använder. 
5. Gör motsvarande sammanställning per typ av öppen tillgång och jämför resultaten.

### Tips för pkt. 4
a. Formeln för gold avgörs av om journal_is_in_doaj = SANT/TRUE, 
    t.ex. =OM(M2=SANT;1;0 )
b. Formeln för hybrid avgörs av om host_type = publisher och licens innehåller cc-by,
    t.ex. =OM(OCH(OM(C3="publisher";SANT;FALSKT);
            OM(ÄRTEXT(D3);OM(HITTA("cc-by";D3);SANT;FALSKT);FALSKT));1;0)
c. Formeln för repo avgörs av om host_type = repository,
    t.ex. =OM(C3="repository";1;0)
d. Slutligen en kolumn som anger kb_oa_status enligt hierarkin guld-hybrid-bara repo (grön), t.ex. =OM(U2=1;"gold";OM(V2=1;"hybrid";OM(W2=1;"green";"closed")))

## R
Du behöver ha biblioteket roadoi i R för att göra den första delen av uppgiften, installera om den saknas.

1. *Lista över doi:er.* 
Sammanställ/använd egen en lista med doi:er eller använd lista tillgänglig på kursens git. Listan kan utöver doi innehålla publ_year, hei (namn/förkortning på lärosäte).

2. *Hämta data från Unpaywall.* 

Kör skript get_unpaywalldata.R som finns i repot (eller skriv eget som använder roadoi). Resultatet av skriptet är en tabell med uppgifter om öppen tillgång, som har en rad per typ och plats som Unpaywall registrerat med tillägg för KB:s klassificering av öppen tillgång.

3. *Sammanställ uppgifter med antal publikationer per typ av öppen tillgång*. 
    - Använd skript process_upw_data.R i repot.
    - I korthet gör det följande:
        + Adderar tre kolumner baserat på vilken typ av ÖT det handlar om utifrån KB:s kriterier.
        + Lägger till en kolumn som anger om repo är den enda formen av öt.
        + Lägger till en kolumn med oa_status enligt hierarkin guld-hybrid-bara repo (grön)
        + Skapar tabell med en rad per artikel med oa_type enligt KB:s kategorisering
        + Skapar tabell för jämförelse mellan Unpaywalls och KB:s kategorisering. 





## Frågor
1. Vilka skillnader finner man beroende på kategorisering?
2. Vad beror de på?
<!-- 3. Hur värderar du dem? -->
