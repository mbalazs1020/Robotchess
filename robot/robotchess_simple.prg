' -------------------------------------
' Sakkozó robot program
' Menyhárt Balázs
' 2016
' -------------------------------------
' Tanított pontok:
' pObserve:     Kameraállás
' pBL:  Tábla bal alsó sarka
' pBR: Tábla jobb alsó sarka
' pTL:     Tábla bal felso sarka

' Definícók

Def Plt 1, pBL, pBR, pTL, ,8 , 8, 2  ' Sakktábla paletta
delay = 0.5                ' Delay ido, amelyet minden mozdulat után beteszünk
over = -50                 ' Ennyivel megyünk fölé a mezőnek
endofProgram = 0           ' Program véget érhet bit
' Mozgás pontjai paletta sorszám szerint adva
movSource = 20
movDest   = 64
' Inicializáló tevékenységek
Servo On    ' Szervók bekapcsolása
Ovrd 20     ' Sebesség limit %
goto *main  ' Elküldöm a main-be
' Lépés itt fog kezdodni
*startMove
' Lépés beolvasása a memóriából
'data = M_In(10162)   ' Adott memóriacímrol így kérünk be
' Kiinduló mezorol felveszem a bábut
*goOverField
pGoal = Plt 1, movSource  ' Kinduló helyet leveszem a palettáról
mvs pGoal, over           ' Megközelítem
HOpen 1                   ' Kinyitom
dly delay
mvs pGoal                 ' Lemegyek
HClose 1                  ' Becsukom
dly delay
mvs pGoal, over            ' Feljövök
dly delay
' Célmezore leteszem a bábut
pGoal = plt 1, movDest    ' Palettáról leveszem a célhelyet
mvs pGoal, over          ' Megközelítem
dly delay
mvs pGoal                 ' Lemegyek
HOpen 1                   ' Kinyitom
dly delay
mvs pGoal, over                 ' Feljövök
dly delay
' Kilépteto feltétel
endofProgram = 1
' ------------------------------
' Main programrész: Innen az elejére ugrok, majd újra ideérek -> ciklus
*main
' Vissza a kameranézetre
mov pObserve
dly delay
if endofProgram = 1 then *exit   ' Ha ki kell lépni
goto *startMove                 ' Kezdjük elorol a programot
' ------------------------------
' Program vége
*exit
Servo Off
End