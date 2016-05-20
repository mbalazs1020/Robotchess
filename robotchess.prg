' -------------------------------------
' Sakkozó robot program
' Menyhárt Balázs
' 2016
' -------------------------------------

' Kezdeti lépések
Servo On    ' Szervók bekapcsolása
Ovrd 20     ' Sebesség limit

' Definícók
Def Plt 1,pBottomLeft,pBottomRight, pTopLeft, ,8,8, 2  ' Sakktábla
delay=0.5                                  ' Delay idő, amelyet minden mozdulat után beteszünk                                


' ------------------------------
' Main programrész:

goto *goOverField

' ------------------------------


' Lépés beolvasása a memóriából
*readMove
move = M_In(10162)


' Bábu megközelítése
*goOverField
pGoal = Plt 1, 1  ' Első pontot közelítem
mov pGoal, - 80
HOpen 1
dly delay
mvs pGoal
HClose 1
dly delay
mvs pGoal


' Program vége
*vege
Servo Off
End

