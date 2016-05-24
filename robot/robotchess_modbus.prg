' ------------------------------------------------------------------------
' Sakkozó robot program
' Menyhárt Balázs
' 2016
' ------------------------------------------------------------------------
'******************************************
' Tanított pontok
'******************************************
' pObs :     Kameraállás
' pBL  :     Tábla bal alsó sarka   (A1)
' pBR  :     Tábla jobb alsó sarka  (H1)
' pTL  :     Tábla bal felso sarka  (A8)
' pDrop:     Ledobóhely
'******************************************
' Kommunikációs protokoll
'******************************************
' Üzenetek várt értékei
allowMoveCmd1      = 21331  ' = 0x5353 - lépés indítás elsõ varázsszáma
allowMoveCmd2      = 6425  ' = 0x1919 - lépés indítás második varázsszáma
exitCmd            = 13107  ' = 0x3333 - kilépés parancs
normalMove         =    33  ' =   0x21 - normál lépés
hitMove            =   173  ' =   0xAD - ütéses lépés
readyClearCmd     = 2 ' = 0x2 - kész törlése parancs
'Küldött üzenetek
moveReady  = 1111 ' = 0x457 - lépés kész 
' Memóriacímei
nWcmd1Addr           = 10800  ' PC: 540
nWcmd2Addr           = 10816  ' PC: 541
nWmovSourceAddr      = 10832  ' PC: 542
nWmovDestAddr        = 10848  ' PC: 543
nWmovTypeAddr        = 10864  ' PC: 544
nWcmdExitAddr        = 10880  ' PC: 545
'******************************************
' Definíciók
'******************************************
Def Plt 1, pBL, pBR, pTL, ,8 , 8, 2  ' Sakktábla paletta
delay = 0.5                ' Delay idõ, amelyet minden mozdulat után beteszünk
toolDelay = 2             ' Megfogó becsukása elotti delay
speedlimit = 20            ' Sebesség %
over = -50                 ' Ennyivel megyünk fölé a mezonek
'******************************************
' Inicializálás
'******************************************
' Kommunikációban részt vevõ memóriák és bufferek kinullázása
nWmovSource = 0
nWmovDest   = 0
nWcmd1 = 0
nWcmd2 = 0
nWmoveType = 0
nWcmdExit = 0
nWcmdClrReady = 0
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
pGoal = Plt 1, nWmovDest    ' Célmezõ helye
mvs pGoal, over           ' Megközelítem
dly toolDelay
HOpen 1                   ' Kinyitom
dly delay
mvs pGoal                 ' Lemegyek
dly toolDelay
HClose 1                  ' Becsukom
dly delay
mvs pGoal, over           ' Megközelítem
dly delay
mvs pDrop                 ' Leütött bábu tároló fölé megyek
dly toolDelay
HOpen 1                   ' Kinyitom
dly delay
' Normál lépés ütés nékül
*startNormalMove
' Kiinduló mezorol felveszem a bábut
pGoal = Plt 1, nWmovSource  ' Kinduló helyet leveszem a palettáról
mvs pGoal, over           ' Megközelítem
dly toolDelay
HOpen 1                   ' Kinyitom
dly delay
mvs pGoal                 ' Lemegyek
dly toolDelay
HClose 1                  ' Becsukom
dly delay
mvs pGoal, over            ' Feljövök
dly delay
' Célmezore leteszem a bábut
pGoal = plt 1, nWmovDest    ' Palettáról leveszem a célhelyet
mvs pGoal, over          ' Megközelítem
dly delay
mvs pGoal                 ' Lemegyek
dly toolDelay
HOpen 1                   ' Kinyitom
dly delay
mvs pGoal, over                 ' Feljövök
dly delay
' Lépés végét jelzem
M_Out16(nWcmd1Addr) = moveReady
' Várok, hogy a PC visszajelezzen
*waitforpc
nWcmdClrReady = M_In16(nWcmd1Addr)
if nWcmdClrReady <> readyClearCmd then *waitforpc
M_out(nWcmd1Addr) = 0
'******************************************
' Main programrész - vezérlés
'******************************************
*main
' Vissza a kameranézetre
mov pObs
dly delay
' Érkezett-e kilépés parancs
nWcmdExit = M_In16(nWcmdExitAddr)
if nWcmdExit = exitCmd then *exit
' Érkezett parancsot ellenõrzöm
nWcmd1 = M_In16(nWcmd1Addr)
if nWcmd1 = allowMoveCmd1 Then *readsecond ' Ha az elsõ parancs lépésre szólít
goto *main ' Újrakezdem
*readsecond
nWcmd2 = M_In16(nWcmd2Addr)
if nWcmd2 = allowMoveCmd2 Then *readMoveParams  ' Ha a második parancs lépésre szólít
goto *main ' Újrakezdem
' Ide nem juthatok el:
goto *exit
' Beolvasom a lépés paramétereit
*readMoveParams
nWmoveType  = M_In16(nWmovTypeAddr)
nWmovSource = M_In16(nWmovSourceAddr)
nWmovDest   = M_In16(nWmovDestAddr)
' Megfelelõ típusú lépésre ugrok
if nWmoveType = NormalMove Then *startNormalMove
if nWmoveType = HitMove Then *startHitMove
'******************************************
' Program vége - leállás
'******************************************
*exit
Servo Off
End