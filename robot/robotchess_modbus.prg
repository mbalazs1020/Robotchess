' ------------------------------------------------------------------------
' Sakkozó robot program
' Menyhárt Balázs
' 2016
' ------------------------------------------------------------------------

'******************************************
' Tanított pontok
'******************************************
' pObserve:     Kameraállás
' pBottomLeft:  Tábla bal alsó sarka
' pBottomRight: Tábla jobb alsó sarka
' pTopLeft:     Tábla bal felsõ sarka
' pDrop:        Ahova a leütött bábut kidobjuk

'******************************************
' Kommunikációs protokoll
'******************************************

' Üzenetek várt értékei
allowMoveCmd1      = 21331  ' = 0x5353 - lépés indítás elsõ varázsszáma
allowMoveCmd2      = 47545  ' = 0xB9B9 - lépés indítás második varázsszáma
exitCmd            = 13107  ' = 0x3333 - kilépés parancs
NormalMove         =    33  ' =   0x21 - normál lépés
HitMove            =   173  ' =   0xAD - ütéses lépés

' Memóriacímei
cmd1Addr           = 10800  ' PC: 540
cmd2Addr           = 10816  ' PC: 541
movSourceAddr      = 10832  ' PC: 542
movDestAddr        = 10848  ' PC: 543
movTypeAddr        = 10864  ' PC: 544


'******************************************
' Definíciók
'******************************************
Def Plt 1, pBottomLeft, pBottomRight, pTopLeft, ,8 , 8, 2  ' Sakktábla paletta
delay = 0.5                ' Delay idõ, amelyet minden mozdulat után beteszünk
speedlimit = 20            ' Sebesség %

'******************************************
' Inicializálás
'******************************************

' Kommunikációban részt vevõ memóriák és bufferek kinullázása
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

' Robot indítása
Servo On            ' Szervók bekapcsolása
Ovrd speedlimit     ' Sebesség limit %

' Main címkére ugrunk, a program ott kezdõdik
goto *main


'******************************************
' Lépés - ciklikusan hívódik
'******************************************

' Ütéses lépés: elõször levesszük a célmezõrõl a bábut
*startHitMove

pGoal = Plt 1, movDest    ' Célmezõ helye
mov pGoal, - 80           ' Megközelítem
HOpen 1                   ' Kinyitom
dly delay
mvs pGoal                 ' Lemegyek
HClose 1                  ' Becsukom
dly delay
mov pGoal, -80            ' Feljövök
dly delay
mov pDrop                 ' Leütött bábu tároló fölé megyek
HOpen 1                   ' Kinyitom
dly delay

' Normál lépés ütés nékül
*startNormalMove

pGoal = Plt 1, movSource  ' Kinduló helyet leveszem a palettáról
mov pGoal, - 80           ' Megközelítem
HOpen 1                   ' Kinyitom
dly delay
mvs pGoal                 ' Lemegyek
HClose 1                  ' Becsukom
dly delay
mov pGoal, -80            ' Feljövök
dly delay

pGoal = plt 1, movDest    ' Palettáról leveszem a célhelyet
mov pGoal, - 80           ' Megközelítem
dly delay
mvs pGoal                 ' Lemegyek
HOpen 1                   ' Kinyitom
dly delay
mvs pGoal                 ' Feljövök
dly delay

' Vissza a kameranézetre
mov pObserve
dly delay


'******************************************
' Main programrész - vezérlés
'******************************************
*main
dly delay ' Legyen benne egy kis késleltetés, mert nem sietünk

' Érkezett parancsot ellenõrzöm
cmd1 = M_In16(cmd1Addr)
if cmd1 = exitCmd then *end  ' Kilépés, ha ez van a parancsban
if cmd1 = allowMoveCmd1 Then ' Ha az elsõ parancs lépésre szólít
	cmd2 = M_In16(cmd2Addr)
	if cmd2 = exitCmd then *end  ' Ha a második parancsban kilépés van, akkor kilépek
	if cmd2 = allowMoveCmd2 Then
		goto *readMoveParams
	Else
		goto *main ' Újrakezdem
	Endif	
Else
	goto *main  ' Újrakezdem
Endif

' Ide nem juthatok el:
goto *end

' Beolvasom a lépés paramétereit
* readMoveParams
moveType  = M_In16(movTypeAddr)
movSource = M_In16(movSourceAddr)
movDest   = M_In16(movDestAddr)

' Megfelelõ típusú lépésre ugrok
if moveType = NormalMove Then *startNormalMove
if moveType = HitMove Then *startHitMove


'******************************************
' Program vége - leállás
'******************************************
*end
Servo Off
End