' ------------------------------------------------------------------------
' Sakkoz� robot program
' Menyh�rt Bal�zs
' 2016
' ------------------------------------------------------------------------
'******************************************
' Tan�tott pontok
'******************************************
' pObs :     Kamera�ll�s
' pBL  :     T�bla bal als� sarka   (A1)
' pBR  :     T�bla jobb als� sarka  (H1)
' pTL  :     T�bla bal felso sarka  (A8)
' pDrop:     Ledob�hely
'******************************************
' Kommunik�ci�s protokoll
'******************************************
' �zenetek v�rt �rt�kei
allowMoveCmd1      = 21331  ' = 0x5353 - l�p�s ind�t�s els� var�zssz�ma
allowMoveCmd2      = 6425  ' = 0x1919 - l�p�s ind�t�s m�sodik var�zssz�ma
exitCmd            = 13107  ' = 0x3333 - kil�p�s parancs
normalMove         =    33  ' =   0x21 - norm�l l�p�s
hitMove            =   173  ' =   0xAD - �t�ses l�p�s
readyClearCmd     = 2 ' = 0x2 - k�sz t�rl�se parancs
'K�ld�tt �zenetek
moveReady  = 1111 ' = 0x457 - l�p�s k�sz 
' Mem�riac�mei
nWcmd1Addr           = 10800  ' PC: 540
nWcmd2Addr           = 10816  ' PC: 541
nWmovSourceAddr      = 10832  ' PC: 542
nWmovDestAddr        = 10848  ' PC: 543
nWmovTypeAddr        = 10864  ' PC: 544
nWcmdExitAddr        = 10880  ' PC: 545
'******************************************
' Defin�ci�k
'******************************************
Def Plt 1, pBL, pBR, pTL, ,8 , 8, 2  ' Sakkt�bla paletta
delay = 0.5                ' Delay id�, amelyet minden mozdulat ut�n betesz�nk
toolDelay = 2             ' Megfog� becsuk�sa elotti delay
speedlimit = 20            ' Sebess�g %
over = -50                 ' Ennyivel megy�nk f�l� a mezonek
'******************************************
' Inicializ�l�s
'******************************************
' Kommunik�ci�ban r�szt vev� mem�ri�k �s bufferek kinull�z�sa
nWmovSource = 0
nWmovDest   = 0
nWcmd1 = 0
nWcmd2 = 0
nWmoveType = 0
nWcmdExit = 0
nWcmdClrReady = 0
' Robot ind�t�sa
Servo On            ' Szerv�k bekapcsol�sa
Ovrd speedlimit     ' Sebess�g limit %
' Main c�mk�re ugrunk, a program ott kezd�dik
goto *main
'******************************************
' L�p�s - ciklikusan h�v�dik
'******************************************
' �t�ses l�p�s: el�sz�r levessz�k a c�lmez�r�l a b�but
*startHitMove
pGoal = Plt 1, nWmovDest    ' C�lmez� helye
mvs pGoal, over           ' Megk�zel�tem
dly toolDelay
HOpen 1                   ' Kinyitom
dly delay
mvs pGoal                 ' Lemegyek
dly toolDelay
HClose 1                  ' Becsukom
dly delay
mvs pGoal, over           ' Megk�zel�tem
dly delay
mvs pDrop                 ' Le�t�tt b�bu t�rol� f�l� megyek
dly toolDelay
HOpen 1                   ' Kinyitom
dly delay
' Norm�l l�p�s �t�s n�k�l
*startNormalMove
' Kiindul� mezorol felveszem a b�but
pGoal = Plt 1, nWmovSource  ' Kindul� helyet leveszem a palett�r�l
mvs pGoal, over           ' Megk�zel�tem
dly toolDelay
HOpen 1                   ' Kinyitom
dly delay
mvs pGoal                 ' Lemegyek
dly toolDelay
HClose 1                  ' Becsukom
dly delay
mvs pGoal, over            ' Felj�v�k
dly delay
' C�lmezore leteszem a b�but
pGoal = plt 1, nWmovDest    ' Palett�r�l leveszem a c�lhelyet
mvs pGoal, over          ' Megk�zel�tem
dly delay
mvs pGoal                 ' Lemegyek
dly toolDelay
HOpen 1                   ' Kinyitom
dly delay
mvs pGoal, over                 ' Felj�v�k
dly delay
' L�p�s v�g�t jelzem
M_Out16(nWcmd1Addr) = moveReady
' V�rok, hogy a PC visszajelezzen
*waitforpc
nWcmdClrReady = M_In16(nWcmd1Addr)
if nWcmdClrReady <> readyClearCmd then *waitforpc
M_out(nWcmd1Addr) = 0
'******************************************
' Main programr�sz - vez�rl�s
'******************************************
*main
' Vissza a kameran�zetre
mov pObs
dly delay
' �rkezett-e kil�p�s parancs
nWcmdExit = M_In16(nWcmdExitAddr)
if nWcmdExit = exitCmd then *exit
' �rkezett parancsot ellen�rz�m
nWcmd1 = M_In16(nWcmd1Addr)
if nWcmd1 = allowMoveCmd1 Then *readsecond ' Ha az els� parancs l�p�sre sz�l�t
goto *main ' �jrakezdem
*readsecond
nWcmd2 = M_In16(nWcmd2Addr)
if nWcmd2 = allowMoveCmd2 Then *readMoveParams  ' Ha a m�sodik parancs l�p�sre sz�l�t
goto *main ' �jrakezdem
' Ide nem juthatok el:
goto *exit
' Beolvasom a l�p�s param�tereit
*readMoveParams
nWmoveType  = M_In16(nWmovTypeAddr)
nWmovSource = M_In16(nWmovSourceAddr)
nWmovDest   = M_In16(nWmovDestAddr)
' Megfelel� t�pus� l�p�sre ugrok
if nWmoveType = NormalMove Then *startNormalMove
if nWmoveType = HitMove Then *startHitMove
'******************************************
' Program v�ge - le�ll�s
'******************************************
*exit
Servo Off
End