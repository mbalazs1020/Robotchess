' -------------------------------------
' Sakkozó robot program
' Menyhárt Balázs
' 2016
' -------------------------------------

' Tanított pontok:
' pObserve:     Kameraállás
' pBottomLeft:  Tábla bal alsó sarka
' pBottomRight: Tábla jobb alsó sarka
' pTopLeft:     Tábla bal felső sarka

' Definícók
Def Plt 1, pBottomLeft, pBottomRight, pTopLeft, ,8 , 8, 2  ' Sakktábla paletta
delay = 0.5                ' Delay idő, amelyet minden mozdulat után beteszünk
endofProgram = 0           ' Program véget érhet bit

' Mozgás pontjai paletta sorszám szerint adva - TODO később memóriából olvasva
movSource = 1
movDest   = 2

' Kezdeti tevékenységek
Servo On    ' Szervók bekapcsolása
Ovrd 20     ' Sebesség limit %
goto *main  ' Elküldöm a main-be



' Lépés itt fog kezdődni
*startMove

' Lépés beolvasása a memóriából
'data = M_In(10162)   ' Adott memóriacímről így kérünk be

' Kiinduló mezőről felveszem a bábut
*goOverField
pGoal = Plt 1, movSource  ' Kinduló helyet leveszem a palettáról
mov pGoal, - 80           ' Megközelítem
HOpen 1                   ' Kinyitom
dly delay
mvs pGoal                 ' Lemegyek
HClose 1                  ' Becsukom
dly delay
mvs pGoal                 ' Feljövök

' Célmezőre leteszem a bábut
pGoal = plt 1, movDest    ' Palettáról leveszem a célhelyet
mov pGoal, - 80           ' Megközelítem
dly delay
mvs pGoal                 ' Lemegyek
HOpen 1                   ' Kinyitom
dly delay
mvs pGoal                 ' Feljövök

' Vissza a kameranézetre
mov pObserve
dly delay

' Kiléptető feltétel - PIG ez csak debug
endofProgram = 1;

' ------------------------------
' Main programrész: Innen az elejére ugrok, majd újra ideérek -> ciklus
*main

if endofProgram = 1 then *end   ' Ha ki kell lépni
goto *startMove                 ' Kezdjük előről a programot

' ------------------------------

' Program vége
*end
Servo Off
End