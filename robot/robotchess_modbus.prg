' ------------------------------------------------------------------------
' Sakkoz� robot program
' Menyh�rt Bal�zs
' 2016
' ------------------------------------------------------------------------

'******************************************
' Tan�tott pontok
'******************************************
' pObserve:     Kamera�ll�s
' pBottomLeft:  T�bla bal als� sarka
' pBottomRight: T�bla jobb als� sarka
' pTopLeft:     T�bla bal fels� sarka
' pDrop:        Ahova a le�t�tt b�but kidobjuk

'******************************************
' Kommunik�ci�s protokoll
'******************************************

' �zenetek v�rt �rt�kei
allowMoveCmd1      = 21331  ' = 0x5353 - l�p�s ind�t�s els� var�zssz�ma
allowMoveCmd2      = 47545  ' = 0xB9B9 - l�p�s ind�t�s m�sodik var�zssz�ma
exitCmd            = 13107  ' = 0x3333 - kil�p�s parancs
NormalMove         =    33  ' =   0x21 - norm�l l�p�s
HitMove            =   173  ' =   0xAD - �t�ses l�p�s

' Mem�riac�mei
cmd1Addr           = 10800  ' PC: 540
cmd2Addr           = 10816  ' PC: 541
movSourceAddr      = 10832  ' PC: 542
movDestAddr        = 10848  ' PC: 543
movTypeAddr        = 10864  ' PC: 544


'******************************************
' Defin�ci�k
'******************************************
Def Plt 1, pBottomLeft, pBottomRight, pTopLeft, ,8 , 8, 2  ' Sakkt�bla paletta
delay = 0.5                ' Delay id�, amelyet minden mozdulat ut�n betesz�nk
speedlimit = 20            ' Sebess�g %

'******************************************
' Inicializ�l�s
'******************************************

' Kommunik�ci�ban r�szt vev� mem�ri�k �s bufferek kinull�z�sa
movSource = 0
movDest   = 0
cmd1 = 0
cmd2 = 0
moveType = 0

M_Out16(allowMoveCmd1Addr) = 0
M_Out16(allowMoveCmd2Addr) = 0
M_Out16(movSourceAddr) = 0
M_Out16(movDestAddr) = 0
M_Out16(movTypeAddr) = 0

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

pGoal = Plt 1, movDest    ' C�lmez� helye
mov pGoal, - 80           ' Megk�zel�tem
HOpen 1                   ' Kinyitom
dly delay
mvs pGoal                 ' Lemegyek
HClose 1                  ' Becsukom
dly delay
mov pGoal, -80            ' Felj�v�k
dly delay
mov pDrop                 ' Le�t�tt b�bu t�rol� f�l� megyek
HOpen 1                   ' Kinyitom
dly delay

' Norm�l l�p�s �t�s n�k�l
*startNormalMove

pGoal = Plt 1, movSource  ' Kindul� helyet leveszem a palett�r�l
mov pGoal, - 80           ' Megk�zel�tem
HOpen 1                   ' Kinyitom
dly delay
mvs pGoal                 ' Lemegyek
HClose 1                  ' Becsukom
dly delay
mov pGoal, -80            ' Felj�v�k
dly delay

pGoal = plt 1, movDest    ' Palett�r�l leveszem a c�lhelyet
mov pGoal, - 80           ' Megk�zel�tem
dly delay
mvs pGoal                 ' Lemegyek
HOpen 1                   ' Kinyitom
dly delay
mvs pGoal                 ' Felj�v�k
dly delay

' Vissza a kameran�zetre
mov pObserve
dly delay


'******************************************
' Main programr�sz - vez�rl�s
'******************************************
*main
dly delay ' Legyen benne egy kis k�sleltet�s, mert nem siet�nk

' �rkezett parancsot ellen�rz�m
cmd1 = M_In16(cmd1Addr)
if cmd1 = exitCmd then *end  ' Kil�p�s, ha ez van a parancsban
if cmd1 = allowMoveCmd1 Then ' Ha az els� parancs l�p�sre sz�l�t
	cmd2 = M_In16(cmd2Addr)
	if cmd2 = exitCmd then *end  ' Ha a m�sodik parancsban kil�p�s van, akkor kil�pek
	if cmd2 = allowMoveCmd2 Then
		goto *readMoveParams
	Else
		goto *main ' �jrakezdem
	Endif	
Else
	goto *main  ' �jrakezdem
Endif

' Ide nem juthatok el:
goto *end

' Beolvasom a l�p�s param�tereit
* readMoveParams
moveType  = M_In16(movTypeAddr)
movSource = M_In16(movSourceAddr)
movDest   = M_In16(movDestAddr)

' Megfelel� t�pus� l�p�sre ugrok
if moveType = NormalMove Then *startNormalMove
if moveType = HitMove Then *startHitMove


'******************************************
' Program v�ge - le�ll�s
'******************************************
*end
Servo Off
End