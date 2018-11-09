EESchema Schematic File Version 4
LIBS:peripherals-cache
EELAYER 26 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 3 9
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L peripherals:Q_NMOS_SSSGDDDD Q?
U 1 1 5B7233C9
P 5400 3100
AR Path="/5B7233C9" Ref="Q?"  Part="1" 
AR Path="/5B7230C4/5B7233C9" Ref="Q201"  Part="1" 
AR Path="/5B725BF5/5B7233C9" Ref="Q?"  Part="1" 
AR Path="/5B6E69BA/5B7233C9" Ref="Q301"  Part="1" 
AR Path="/5B6E69C9/5B7233C9" Ref="Q401"  Part="1" 
AR Path="/5B6E69CE/5B7233C9" Ref="Q501"  Part="1" 
AR Path="/5B6E6A62/5B7233C9" Ref="Q601"  Part="1" 
AR Path="/5B6E6A67/5B7233C9" Ref="Q701"  Part="1" 
AR Path="/5B6E6A6C/5B7233C9" Ref="Q801"  Part="1" 
AR Path="/5B6E6A71/5B7233C9" Ref="Q901"  Part="1" 
F 0 "Q301" H 5788 3146 50  0000 L CNN
F 1 "RQ3E100BNTB" H 5788 3055 50  0000 L CNN
F 2 "peripherals:Rohm-HSMT8" H 5600 3200 50  0001 C CNN
F 3 "~" H 5400 3100 50  0001 C CNN
F 4 "755-RQ3E100BNTB" H 5400 3100 50  0001 C CNN "Mouser"
	1    5400 3100
	1    0    0    -1  
$EndComp
$Comp
L peripherals:DGD0506A U?
U 1 1 5B7233D1
P 4250 3400
AR Path="/5B7233D1" Ref="U?"  Part="1" 
AR Path="/5B7230C4/5B7233D1" Ref="U201"  Part="1" 
AR Path="/5B725BF5/5B7233D1" Ref="U?"  Part="1" 
AR Path="/5B6E69BA/5B7233D1" Ref="U301"  Part="1" 
AR Path="/5B6E69C9/5B7233D1" Ref="U401"  Part="1" 
AR Path="/5B6E69CE/5B7233D1" Ref="U501"  Part="1" 
AR Path="/5B6E6A62/5B7233D1" Ref="U601"  Part="1" 
AR Path="/5B6E6A67/5B7233D1" Ref="U701"  Part="1" 
AR Path="/5B6E6A6C/5B7233D1" Ref="U801"  Part="1" 
AR Path="/5B6E6A71/5B7233D1" Ref="U901"  Part="1" 
F 0 "U301" H 4250 3865 50  0000 C CNN
F 1 "DGD0506A" H 4250 3774 50  0000 C CNN
F 2 "peripherals:Diodes-MSOP10" H 4250 3800 50  0001 C CNN
F 3 "" H 4250 3800 50  0001 C CNN
F 4 "621-DGD0506AM10-13" H 4250 3400 50  0001 C CNN "Mouser"
	1    4250 3400
	-1   0    0    -1  
$EndComp
Wire Wire Line
	5400 3350 5400 3500
Wire Wire Line
	5400 3500 5500 3500
Wire Wire Line
	5700 3500 5700 3650
Wire Wire Line
	5600 3350 5600 3500
Connection ~ 5600 3500
Wire Wire Line
	5600 3500 5700 3500
Wire Wire Line
	5600 3500 5600 3650
Wire Wire Line
	5500 3500 5500 3650
Connection ~ 5500 3500
Wire Wire Line
	5500 3500 5600 3500
Wire Wire Line
	5400 3500 5400 3650
Connection ~ 5400 3500
Wire Wire Line
	5500 3350 5500 3500
$Comp
L power:GND #PWR?
U 1 1 5B7233E5
P 5400 4250
AR Path="/5B7233E5" Ref="#PWR?"  Part="1" 
AR Path="/5B7230C4/5B7233E5" Ref="#PWR0207"  Part="1" 
AR Path="/5B725BF5/5B7233E5" Ref="#PWR?"  Part="1" 
AR Path="/5B6E69BA/5B7233E5" Ref="#PWR0307"  Part="1" 
AR Path="/5B6E69C9/5B7233E5" Ref="#PWR0407"  Part="1" 
AR Path="/5B6E69CE/5B7233E5" Ref="#PWR0507"  Part="1" 
AR Path="/5B6E6A62/5B7233E5" Ref="#PWR0607"  Part="1" 
AR Path="/5B6E6A67/5B7233E5" Ref="#PWR0707"  Part="1" 
AR Path="/5B6E6A6C/5B7233E5" Ref="#PWR0807"  Part="1" 
AR Path="/5B6E6A71/5B7233E5" Ref="#PWR0907"  Part="1" 
F 0 "#PWR0307" H 5400 4000 50  0001 C CNN
F 1 "GND" H 5405 4077 50  0000 C CNN
F 2 "" H 5400 4250 50  0001 C CNN
F 3 "" H 5400 4250 50  0001 C CNN
	1    5400 4250
	1    0    0    -1  
$EndComp
Wire Wire Line
	5400 4150 5400 4200
Wire Wire Line
	5500 4150 5500 4200
Wire Wire Line
	5500 4200 5400 4200
Connection ~ 5400 4200
Wire Wire Line
	5400 4200 5400 4250
Wire Wire Line
	5600 4150 5600 4200
Wire Wire Line
	5600 4200 5500 4200
Connection ~ 5500 4200
$Comp
L Device:R_Small R?
U 1 1 5B7233F3
P 5150 3100
AR Path="/5B7233F3" Ref="R?"  Part="1" 
AR Path="/5B7230C4/5B7233F3" Ref="R201"  Part="1" 
AR Path="/5B725BF5/5B7233F3" Ref="R?"  Part="1" 
AR Path="/5B6E69BA/5B7233F3" Ref="R301"  Part="1" 
AR Path="/5B6E69C9/5B7233F3" Ref="R401"  Part="1" 
AR Path="/5B6E69CE/5B7233F3" Ref="R501"  Part="1" 
AR Path="/5B6E6A62/5B7233F3" Ref="R601"  Part="1" 
AR Path="/5B6E6A67/5B7233F3" Ref="R701"  Part="1" 
AR Path="/5B6E6A6C/5B7233F3" Ref="R801"  Part="1" 
AR Path="/5B6E6A71/5B7233F3" Ref="R901"  Part="1" 
F 0 "R301" V 4954 3100 50  0000 C CNN
F 1 "0" V 5045 3100 50  0000 C CNN
F 2 "Resistors_SMD:R_0603_HandSoldering" H 5150 3100 50  0001 C CNN
F 3 "~" H 5150 3100 50  0001 C CNN
F 4 "755-SFR03EZPJ000" V 5150 3100 50  0001 C CNN "Mouser"
	1    5150 3100
	0    1    1    0   
$EndComp
Wire Wire Line
	5250 3100 5200 3100
Wire Wire Line
	4350 3900 5200 3900
$Comp
L power:GND #PWR?
U 1 1 5B723403
P 3700 3300
AR Path="/5B723403" Ref="#PWR?"  Part="1" 
AR Path="/5B7230C4/5B723403" Ref="#PWR0205"  Part="1" 
AR Path="/5B725BF5/5B723403" Ref="#PWR?"  Part="1" 
AR Path="/5B6E69BA/5B723403" Ref="#PWR0305"  Part="1" 
AR Path="/5B6E69C9/5B723403" Ref="#PWR0405"  Part="1" 
AR Path="/5B6E69CE/5B723403" Ref="#PWR0505"  Part="1" 
AR Path="/5B6E6A62/5B723403" Ref="#PWR0605"  Part="1" 
AR Path="/5B6E6A67/5B723403" Ref="#PWR0705"  Part="1" 
AR Path="/5B6E6A6C/5B723403" Ref="#PWR0805"  Part="1" 
AR Path="/5B6E6A71/5B723403" Ref="#PWR0905"  Part="1" 
F 0 "#PWR0305" H 3700 3050 50  0001 C CNN
F 1 "GND" V 3705 3172 50  0000 R CNN
F 2 "" H 3700 3300 50  0001 C CNN
F 3 "" H 3700 3300 50  0001 C CNN
	1    3700 3300
	0    1    1    0   
$EndComp
$Comp
L Device:R_Small R?
U 1 1 5B723409
P 3600 3800
AR Path="/5B723409" Ref="R?"  Part="1" 
AR Path="/5B7230C4/5B723409" Ref="R202"  Part="1" 
AR Path="/5B725BF5/5B723409" Ref="R?"  Part="1" 
AR Path="/5B6E69BA/5B723409" Ref="R302"  Part="1" 
AR Path="/5B6E69C9/5B723409" Ref="R402"  Part="1" 
AR Path="/5B6E69CE/5B723409" Ref="R502"  Part="1" 
AR Path="/5B6E6A62/5B723409" Ref="R602"  Part="1" 
AR Path="/5B6E6A67/5B723409" Ref="R702"  Part="1" 
AR Path="/5B6E6A6C/5B723409" Ref="R802"  Part="1" 
AR Path="/5B6E6A71/5B723409" Ref="R902"  Part="1" 
F 0 "R302" H 3541 3846 50  0000 R CNN
F 1 "100k" H 3541 3755 50  0000 R CNN
F 2 "Resistors_SMD:R_0402" H 3600 3800 50  0001 C CNN
F 3 "~" H 3600 3800 50  0001 C CNN
F 4 "603-RC0402JR-13100KL" H 3600 3800 50  0001 C CNN "Mouser"
	1    3600 3800
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5B723410
P 3600 4000
AR Path="/5B723410" Ref="#PWR?"  Part="1" 
AR Path="/5B7230C4/5B723410" Ref="#PWR0206"  Part="1" 
AR Path="/5B725BF5/5B723410" Ref="#PWR?"  Part="1" 
AR Path="/5B6E69BA/5B723410" Ref="#PWR0306"  Part="1" 
AR Path="/5B6E69C9/5B723410" Ref="#PWR0406"  Part="1" 
AR Path="/5B6E69CE/5B723410" Ref="#PWR0506"  Part="1" 
AR Path="/5B6E6A62/5B723410" Ref="#PWR0606"  Part="1" 
AR Path="/5B6E6A67/5B723410" Ref="#PWR0706"  Part="1" 
AR Path="/5B6E6A6C/5B723410" Ref="#PWR0806"  Part="1" 
AR Path="/5B6E6A71/5B723410" Ref="#PWR0906"  Part="1" 
F 0 "#PWR0306" H 3600 3750 50  0001 C CNN
F 1 "GND" H 3605 3827 50  0000 C CNN
F 2 "" H 3600 4000 50  0001 C CNN
F 3 "" H 3600 4000 50  0001 C CNN
	1    3600 4000
	1    0    0    -1  
$EndComp
Wire Wire Line
	3600 3900 3600 4000
Wire Wire Line
	5400 2750 5500 2750
Wire Wire Line
	5500 2750 5500 2850
Connection ~ 5400 2750
Wire Wire Line
	5400 2750 5400 2850
Wire Wire Line
	5500 2750 5600 2750
Wire Wire Line
	5600 2750 5600 2850
Connection ~ 5500 2750
Wire Wire Line
	5600 2750 5700 2750
Wire Wire Line
	5700 2750 5700 2850
Connection ~ 5600 2750
Wire Wire Line
	3700 3300 3800 3300
Wire Wire Line
	3800 3200 3750 3200
Wire Wire Line
	3750 3200 3750 3900
Wire Wire Line
	3750 3900 4150 3900
Wire Wire Line
	4700 3400 4800 3400
Wire Wire Line
	4800 3400 4800 3100
Wire Wire Line
	4800 3100 5050 3100
Wire Wire Line
	4700 3500 5300 3500
$Comp
L Device:C_Small C?
U 1 1 5B723429
P 4950 3300
AR Path="/5B723429" Ref="C?"  Part="1" 
AR Path="/5B7230C4/5B723429" Ref="C205"  Part="1" 
AR Path="/5B725BF5/5B723429" Ref="C?"  Part="1" 
AR Path="/5B6E69BA/5B723429" Ref="C305"  Part="1" 
AR Path="/5B6E69C9/5B723429" Ref="C405"  Part="1" 
AR Path="/5B6E69CE/5B723429" Ref="C505"  Part="1" 
AR Path="/5B6E6A62/5B723429" Ref="C605"  Part="1" 
AR Path="/5B6E6A67/5B723429" Ref="C705"  Part="1" 
AR Path="/5B6E6A6C/5B723429" Ref="C805"  Part="1" 
AR Path="/5B6E6A71/5B723429" Ref="C905"  Part="1" 
F 0 "C305" V 4721 3300 50  0000 C CNN
F 1 "100nF" V 4812 3300 50  0000 C CNN
F 2 "Capacitors_SMD:C_0402" H 4950 3300 50  0001 C CNN
F 3 "~" H 4950 3300 50  0001 C CNN
F 4 "710-885012105018" H 4950 3300 50  0001 C CNN "Mouser"
	1    4950 3300
	0    -1   1    0   
$EndComp
Wire Wire Line
	4850 3300 4750 3300
Wire Wire Line
	5050 3300 5150 3300
Wire Wire Line
	5300 3300 5300 3500
Connection ~ 5300 3500
Wire Wire Line
	5300 3500 5400 3500
Wire Wire Line
	3600 3700 3600 3600
Wire Wire Line
	3600 3600 3800 3600
Wire Wire Line
	4750 3200 4700 3200
Wire Wire Line
	6050 3500 5900 3500
Connection ~ 5700 3500
Wire Wire Line
	4750 2400 4750 3200
$Comp
L Device:C_Small C?
U 1 1 5B723443
P 3900 2550
AR Path="/5B723443" Ref="C?"  Part="1" 
AR Path="/5B7230C4/5B723443" Ref="C201"  Part="1" 
AR Path="/5B725BF5/5B723443" Ref="C?"  Part="1" 
AR Path="/5B6E69BA/5B723443" Ref="C301"  Part="1" 
AR Path="/5B6E69C9/5B723443" Ref="C401"  Part="1" 
AR Path="/5B6E69CE/5B723443" Ref="C501"  Part="1" 
AR Path="/5B6E6A62/5B723443" Ref="C601"  Part="1" 
AR Path="/5B6E6A67/5B723443" Ref="C701"  Part="1" 
AR Path="/5B6E6A6C/5B723443" Ref="C801"  Part="1" 
AR Path="/5B6E6A71/5B723443" Ref="C901"  Part="1" 
F 0 "C301" H 3992 2596 50  0000 L CNN
F 1 "10uF" H 3992 2505 50  0000 L CNN
F 2 "Capacitors_SMD:CP_Elec_4x5.7" H 3900 2550 50  0001 C CNN
F 3 "~" H 3900 2550 50  0001 C CNN
F 4 "710-865080440002" H 3900 2550 50  0001 C CNN "Mouser"
	1    3900 2550
	1    0    0    -1  
$EndComp
Wire Wire Line
	4300 2450 4300 2400
Wire Wire Line
	4300 2400 4750 2400
$Comp
L power:GND #PWR?
U 1 1 5B72344C
P 4300 2700
AR Path="/5B72344C" Ref="#PWR?"  Part="1" 
AR Path="/5B7230C4/5B72344C" Ref="#PWR0203"  Part="1" 
AR Path="/5B725BF5/5B72344C" Ref="#PWR?"  Part="1" 
AR Path="/5B6E69BA/5B72344C" Ref="#PWR0303"  Part="1" 
AR Path="/5B6E69C9/5B72344C" Ref="#PWR0403"  Part="1" 
AR Path="/5B6E69CE/5B72344C" Ref="#PWR0503"  Part="1" 
AR Path="/5B6E6A62/5B72344C" Ref="#PWR0603"  Part="1" 
AR Path="/5B6E6A67/5B72344C" Ref="#PWR0703"  Part="1" 
AR Path="/5B6E6A6C/5B72344C" Ref="#PWR0803"  Part="1" 
AR Path="/5B6E6A71/5B72344C" Ref="#PWR0903"  Part="1" 
F 0 "#PWR0303" H 4300 2450 50  0001 C CNN
F 1 "GND" H 4305 2527 50  0000 C CNN
F 2 "" H 4300 2700 50  0001 C CNN
F 3 "" H 4300 2700 50  0001 C CNN
	1    4300 2700
	1    0    0    -1  
$EndComp
Wire Wire Line
	4300 2650 4300 2700
Wire Wire Line
	5400 2300 5400 2400
$Comp
L Device:L_Small L?
U 1 1 5B723472
P 5100 2400
AR Path="/5B723472" Ref="L?"  Part="1" 
AR Path="/5B7230C4/5B723472" Ref="L201"  Part="1" 
AR Path="/5B725BF5/5B723472" Ref="L?"  Part="1" 
AR Path="/5B6E69BA/5B723472" Ref="L301"  Part="1" 
AR Path="/5B6E69C9/5B723472" Ref="L401"  Part="1" 
AR Path="/5B6E69CE/5B723472" Ref="L501"  Part="1" 
AR Path="/5B6E6A62/5B723472" Ref="L601"  Part="1" 
AR Path="/5B6E6A67/5B723472" Ref="L701"  Part="1" 
AR Path="/5B6E6A6C/5B723472" Ref="L801"  Part="1" 
AR Path="/5B6E6A71/5B723472" Ref="L901"  Part="1" 
F 0 "L301" V 5285 2400 50  0000 C CNN
F 1 "100uH" V 5194 2400 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" H 5100 2400 50  0001 C CNN
F 3 "~" H 5100 2400 50  0001 C CNN
F 4 "810-MLZ2012N101LT000" V 5100 2400 50  0001 C CNN "Mouser"
	1    5100 2400
	0    -1   -1   0   
$EndComp
Wire Wire Line
	5200 2400 5400 2400
Connection ~ 5400 2400
Wire Wire Line
	5400 2400 5400 2750
Wire Wire Line
	5000 2400 4750 2400
Connection ~ 4750 2400
$Comp
L power:+BATT #PWR?
U 1 1 5B72347E
P 5400 2300
AR Path="/5B72347E" Ref="#PWR?"  Part="1" 
AR Path="/5B7230C4/5B72347E" Ref="#PWR0201"  Part="1" 
AR Path="/5B725BF5/5B72347E" Ref="#PWR?"  Part="1" 
AR Path="/5B6E69BA/5B72347E" Ref="#PWR0301"  Part="1" 
AR Path="/5B6E69C9/5B72347E" Ref="#PWR0401"  Part="1" 
AR Path="/5B6E69CE/5B72347E" Ref="#PWR0501"  Part="1" 
AR Path="/5B6E6A62/5B72347E" Ref="#PWR0601"  Part="1" 
AR Path="/5B6E6A67/5B72347E" Ref="#PWR0701"  Part="1" 
AR Path="/5B6E6A6C/5B72347E" Ref="#PWR0801"  Part="1" 
AR Path="/5B6E6A71/5B72347E" Ref="#PWR0901"  Part="1" 
F 0 "#PWR0301" H 5400 2150 50  0001 C CNN
F 1 "+BATT" H 5415 2473 50  0000 C CNN
F 2 "" H 5400 2300 50  0001 C CNN
F 3 "" H 5400 2300 50  0001 C CNN
	1    5400 2300
	1    0    0    -1  
$EndComp
Wire Wire Line
	3250 3400 3800 3400
Wire Wire Line
	3250 3500 3800 3500
$Comp
L peripherals:Q_NMOS_SSSGDDDD Q?
U 1 1 5B723489
P 5400 3900
AR Path="/5B723489" Ref="Q?"  Part="1" 
AR Path="/5B7230C4/5B723489" Ref="Q202"  Part="1" 
AR Path="/5B725BF5/5B723489" Ref="Q?"  Part="1" 
AR Path="/5B6E69BA/5B723489" Ref="Q302"  Part="1" 
AR Path="/5B6E69C9/5B723489" Ref="Q402"  Part="1" 
AR Path="/5B6E69CE/5B723489" Ref="Q502"  Part="1" 
AR Path="/5B6E6A62/5B723489" Ref="Q602"  Part="1" 
AR Path="/5B6E6A67/5B723489" Ref="Q702"  Part="1" 
AR Path="/5B6E6A6C/5B723489" Ref="Q802"  Part="1" 
AR Path="/5B6E6A71/5B723489" Ref="Q902"  Part="1" 
F 0 "Q302" H 5788 3946 50  0000 L CNN
F 1 "RQ3E100BNTB" H 5788 3855 50  0000 L CNN
F 2 "peripherals:Rohm-HSMT8" H 5600 4000 50  0001 C CNN
F 3 "~" H 5400 3900 50  0001 C CNN
F 4 "755-RQ3E100BNTB" H 5400 3900 50  0001 C CNN "Mouser"
	1    5400 3900
	1    0    0    -1  
$EndComp
Text HLabel 6050 3500 2    50   Input ~ 0
OUT
Text HLabel 3250 3400 0    50   Input ~ 0
IN
Text HLabel 3250 3500 0    50   Input ~ 0
EN
$Comp
L Device:R_Small R?
U 1 1 5B727333
P 4250 3900
AR Path="/5B727333" Ref="R?"  Part="1" 
AR Path="/5B7230C4/5B727333" Ref="R203"  Part="1" 
AR Path="/5B725BF5/5B727333" Ref="R?"  Part="1" 
AR Path="/5B6E69BA/5B727333" Ref="R303"  Part="1" 
AR Path="/5B6E69C9/5B727333" Ref="R403"  Part="1" 
AR Path="/5B6E69CE/5B727333" Ref="R503"  Part="1" 
AR Path="/5B6E6A62/5B727333" Ref="R603"  Part="1" 
AR Path="/5B6E6A67/5B727333" Ref="R703"  Part="1" 
AR Path="/5B6E6A6C/5B727333" Ref="R803"  Part="1" 
AR Path="/5B6E6A71/5B727333" Ref="R903"  Part="1" 
F 0 "R303" V 4054 3900 50  0000 C CNN
F 1 "0" V 4145 3900 50  0000 C CNN
F 2 "Resistors_SMD:R_0603_HandSoldering" H 4250 3900 50  0001 C CNN
F 3 "~" H 4250 3900 50  0001 C CNN
F 4 "755-SFR03EZPJ000" V 4250 3900 50  0001 C CNN "Mouser"
	1    4250 3900
	0    -1   1    0   
$EndComp
Wire Wire Line
	3900 2450 3900 2400
Wire Wire Line
	3900 2400 4300 2400
Connection ~ 4300 2400
$Comp
L power:GND #PWR?
U 1 1 5B728A25
P 3900 2700
AR Path="/5B728A25" Ref="#PWR?"  Part="1" 
AR Path="/5B7230C4/5B728A25" Ref="#PWR0202"  Part="1" 
AR Path="/5B725BF5/5B728A25" Ref="#PWR?"  Part="1" 
AR Path="/5B6E69BA/5B728A25" Ref="#PWR0302"  Part="1" 
AR Path="/5B6E69C9/5B728A25" Ref="#PWR0402"  Part="1" 
AR Path="/5B6E69CE/5B728A25" Ref="#PWR0502"  Part="1" 
AR Path="/5B6E6A62/5B728A25" Ref="#PWR0602"  Part="1" 
AR Path="/5B6E6A67/5B728A25" Ref="#PWR0702"  Part="1" 
AR Path="/5B6E6A6C/5B728A25" Ref="#PWR0802"  Part="1" 
AR Path="/5B6E6A71/5B728A25" Ref="#PWR0902"  Part="1" 
F 0 "#PWR0302" H 3900 2450 50  0001 C CNN
F 1 "GND" H 3905 2527 50  0000 C CNN
F 2 "" H 3900 2700 50  0001 C CNN
F 3 "" H 3900 2700 50  0001 C CNN
	1    3900 2700
	1    0    0    -1  
$EndComp
Wire Wire Line
	3900 2650 3900 2700
$Comp
L Device:C_Small C?
U 1 1 5B72F72D
P 4300 2550
AR Path="/5B72F72D" Ref="C?"  Part="1" 
AR Path="/5B7230C4/5B72F72D" Ref="C202"  Part="1" 
AR Path="/5B725BF5/5B72F72D" Ref="C?"  Part="1" 
AR Path="/5B6E69BA/5B72F72D" Ref="C302"  Part="1" 
AR Path="/5B6E69C9/5B72F72D" Ref="C402"  Part="1" 
AR Path="/5B6E69CE/5B72F72D" Ref="C502"  Part="1" 
AR Path="/5B6E6A62/5B72F72D" Ref="C602"  Part="1" 
AR Path="/5B6E6A67/5B72F72D" Ref="C702"  Part="1" 
AR Path="/5B6E6A6C/5B72F72D" Ref="C802"  Part="1" 
AR Path="/5B6E6A71/5B72F72D" Ref="C902"  Part="1" 
F 0 "C302" H 4392 2596 50  0000 L CNN
F 1 "100nF" H 4392 2505 50  0000 L CNN
F 2 "Capacitors_SMD:C_0402" H 4300 2550 50  0001 C CNN
F 3 "~" H 4300 2550 50  0001 C CNN
F 4 "710-885012105018" H 4300 2550 50  0001 C CNN "Mouser"
	1    4300 2550
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C?
U 1 1 5B6EFABB
P 4950 3600
AR Path="/5B6EFABB" Ref="C?"  Part="1" 
AR Path="/5B7230C4/5B6EFABB" Ref="C206"  Part="1" 
AR Path="/5B725BF5/5B6EFABB" Ref="C?"  Part="1" 
AR Path="/5B6E69BA/5B6EFABB" Ref="C306"  Part="1" 
AR Path="/5B6E69C9/5B6EFABB" Ref="C406"  Part="1" 
AR Path="/5B6E69CE/5B6EFABB" Ref="C506"  Part="1" 
AR Path="/5B6E6A62/5B6EFABB" Ref="C606"  Part="1" 
AR Path="/5B6E6A67/5B6EFABB" Ref="C706"  Part="1" 
AR Path="/5B6E6A6C/5B6EFABB" Ref="C806"  Part="1" 
AR Path="/5B6E6A71/5B6EFABB" Ref="C906"  Part="1" 
F 0 "C306" V 4721 3600 50  0000 C CNN
F 1 "DNP 0603" V 4812 3600 50  0000 C CNN
F 2 "Capacitors_SMD:C_0603_HandSoldering" H 4950 3600 50  0001 C CNN
F 3 "~" H 4950 3600 50  0001 C CNN
F 4 "NoPart" H 4950 3600 50  0001 C CNN "Mouser"
	1    4950 3600
	0    -1   1    0   
$EndComp
Wire Wire Line
	5050 3600 5150 3600
Wire Wire Line
	5150 3600 5150 3300
Connection ~ 5150 3300
Wire Wire Line
	5150 3300 5300 3300
Wire Wire Line
	4750 3300 4750 3600
Wire Wire Line
	4750 3600 4850 3600
Connection ~ 4750 3300
Wire Wire Line
	4750 3300 4700 3300
$Comp
L Connector:TestPoint_Alt TP201
U 1 1 5B6F8326
P 4750 3650
AR Path="/5B7230C4/5B6F8326" Ref="TP201"  Part="1" 
AR Path="/5B6E69BA/5B6F8326" Ref="TP301"  Part="1" 
AR Path="/5B6E69C9/5B6F8326" Ref="TP401"  Part="1" 
AR Path="/5B6E69CE/5B6F8326" Ref="TP501"  Part="1" 
AR Path="/5B6E6A62/5B6F8326" Ref="TP601"  Part="1" 
AR Path="/5B6E6A67/5B6F8326" Ref="TP701"  Part="1" 
AR Path="/5B6E6A6C/5B6F8326" Ref="TP801"  Part="1" 
AR Path="/5B6E6A71/5B6F8326" Ref="TP901"  Part="1" 
F 0 "TP301" H 4692 3677 50  0000 R CNN
F 1 "TestPoint_Alt" H 4692 3768 50  0000 R CNN
F 2 "Measurement_Points:Measurement_Point_Round-SMD-Pad_Small" H 4950 3650 50  0001 C CNN
F 3 "~" H 4950 3650 50  0001 C CNN
F 4 "NoPart" H 4750 3650 50  0001 C CNN "Mouser"
	1    4750 3650
	-1   0    0    1   
$EndComp
Wire Wire Line
	4750 3600 4750 3650
Connection ~ 4750 3600
$Comp
L Connector:TestPoint_Alt TP202
U 1 1 5B6F99EB
P 5300 3650
AR Path="/5B7230C4/5B6F99EB" Ref="TP202"  Part="1" 
AR Path="/5B6E69BA/5B6F99EB" Ref="TP302"  Part="1" 
AR Path="/5B6E69C9/5B6F99EB" Ref="TP402"  Part="1" 
AR Path="/5B6E69CE/5B6F99EB" Ref="TP502"  Part="1" 
AR Path="/5B6E6A62/5B6F99EB" Ref="TP602"  Part="1" 
AR Path="/5B6E6A67/5B6F99EB" Ref="TP702"  Part="1" 
AR Path="/5B6E6A6C/5B6F99EB" Ref="TP802"  Part="1" 
AR Path="/5B6E6A71/5B6F99EB" Ref="TP902"  Part="1" 
F 0 "TP302" H 5242 3677 50  0000 R CNN
F 1 "TestPoint_Alt" H 5242 3768 50  0000 R CNN
F 2 "Measurement_Points:Measurement_Point_Round-SMD-Pad_Small" H 5500 3650 50  0001 C CNN
F 3 "~" H 5500 3650 50  0001 C CNN
F 4 "NoPart" H 5500 3650 50  0001 C CNN "Mouser"
	1    5300 3650
	-1   0    0    1   
$EndComp
Wire Wire Line
	5300 3500 5300 3650
$Comp
L power:PWR_FLAG #FLG0103
U 1 1 5B6F59A4
P 4750 2300
AR Path="/5B7230C4/5B6F59A4" Ref="#FLG0103"  Part="1" 
AR Path="/5B6E69BA/5B6F59A4" Ref="#FLG0104"  Part="1" 
AR Path="/5B6E69C9/5B6F59A4" Ref="#FLG0105"  Part="1" 
AR Path="/5B6E69CE/5B6F59A4" Ref="#FLG0106"  Part="1" 
AR Path="/5B6E6A62/5B6F59A4" Ref="#FLG0107"  Part="1" 
AR Path="/5B6E6A67/5B6F59A4" Ref="#FLG0108"  Part="1" 
AR Path="/5B6E6A6C/5B6F59A4" Ref="#FLG0109"  Part="1" 
AR Path="/5B6E6A71/5B6F59A4" Ref="#FLG0110"  Part="1" 
F 0 "#FLG0104" H 4750 2375 50  0001 C CNN
F 1 "PWR_FLAG" H 4750 2474 50  0000 C CNN
F 2 "" H 4750 2300 50  0001 C CNN
F 3 "~" H 4750 2300 50  0001 C CNN
	1    4750 2300
	1    0    0    -1  
$EndComp
Wire Wire Line
	4750 2300 4750 2400
$Comp
L power:PWR_FLAG #FLG0111
U 1 1 5B6F73EE
P 5900 3450
AR Path="/5B7230C4/5B6F73EE" Ref="#FLG0111"  Part="1" 
AR Path="/5B6E69BA/5B6F73EE" Ref="#FLG0112"  Part="1" 
AR Path="/5B6E69C9/5B6F73EE" Ref="#FLG0113"  Part="1" 
AR Path="/5B6E69CE/5B6F73EE" Ref="#FLG0114"  Part="1" 
AR Path="/5B6E6A62/5B6F73EE" Ref="#FLG0115"  Part="1" 
AR Path="/5B6E6A67/5B6F73EE" Ref="#FLG0116"  Part="1" 
AR Path="/5B6E6A6C/5B6F73EE" Ref="#FLG0117"  Part="1" 
AR Path="/5B6E6A71/5B6F73EE" Ref="#FLG0118"  Part="1" 
F 0 "#FLG0112" H 5900 3525 50  0001 C CNN
F 1 "PWR_FLAG" H 5900 3624 50  0000 C CNN
F 2 "" H 5900 3450 50  0001 C CNN
F 3 "~" H 5900 3450 50  0001 C CNN
	1    5900 3450
	1    0    0    -1  
$EndComp
Wire Wire Line
	5900 3450 5900 3500
Connection ~ 5900 3500
Wire Wire Line
	5900 3500 5700 3500
$EndSCHEMATC
