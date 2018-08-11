EESchema Schematic File Version 4
EELAYER 26 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 2 2
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
AR Path="/5B725BF5/5B7233C9" Ref="Q301"  Part="1" 
F 0 "Q201" H 5788 3146 50  0000 L CNN
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
AR Path="/5B725BF5/5B7233D1" Ref="U301"  Part="1" 
F 0 "U201" H 4250 3865 50  0000 C CNN
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
AR Path="/5B725BF5/5B7233E5" Ref="#PWR0307"  Part="1" 
F 0 "#PWR0207" H 5400 4000 50  0001 C CNN
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
P 4950 3100
AR Path="/5B7233F3" Ref="R?"  Part="1" 
AR Path="/5B7230C4/5B7233F3" Ref="R201"  Part="1" 
AR Path="/5B725BF5/5B7233F3" Ref="R301"  Part="1" 
F 0 "R201" V 4754 3100 50  0000 C CNN
F 1 "0" V 4845 3100 50  0000 C CNN
F 2 "Resistors_SMD:R_0603_HandSoldering" H 4950 3100 50  0001 C CNN
F 3 "~" H 4950 3100 50  0001 C CNN
F 4 "755-SFR03EZPJ000" V 4950 3100 50  0001 C CNN "Mouser"
	1    4950 3100
	0    1    1    0   
$EndComp
Wire Wire Line
	5050 3100 5200 3100
Wire Wire Line
	5150 3900 5200 3900
$Comp
L power:GND #PWR?
U 1 1 5B723403
P 3700 3300
AR Path="/5B723403" Ref="#PWR?"  Part="1" 
AR Path="/5B7230C4/5B723403" Ref="#PWR0204"  Part="1" 
AR Path="/5B725BF5/5B723403" Ref="#PWR0304"  Part="1" 
F 0 "#PWR0204" H 3700 3050 50  0001 C CNN
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
AR Path="/5B725BF5/5B723409" Ref="R302"  Part="1" 
F 0 "R202" H 3541 3846 50  0000 R CNN
F 1 "10k" H 3541 3755 50  0000 R CNN
F 2 "Resistors_SMD:R_0402" H 3600 3800 50  0001 C CNN
F 3 "~" H 3600 3800 50  0001 C CNN
F 4 "603-RC0402JR-0710KL" H 3600 3800 50  0001 C CNN "Mouser"
	1    3600 3800
	-1   0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5B723410
P 3600 4000
AR Path="/5B723410" Ref="#PWR?"  Part="1" 
AR Path="/5B7230C4/5B723410" Ref="#PWR0206"  Part="1" 
AR Path="/5B725BF5/5B723410" Ref="#PWR0306"  Part="1" 
F 0 "#PWR0206" H 3600 3750 50  0001 C CNN
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
	3750 3900 4950 3900
Wire Wire Line
	4700 3400 4800 3400
Wire Wire Line
	4800 3400 4800 3100
Wire Wire Line
	4800 3100 4850 3100
Wire Wire Line
	4700 3500 5300 3500
$Comp
L Device:C_Small C?
U 1 1 5B723429
P 5150 3300
AR Path="/5B723429" Ref="C?"  Part="1" 
AR Path="/5B7230C4/5B723429" Ref="C204"  Part="1" 
AR Path="/5B725BF5/5B723429" Ref="C304"  Part="1" 
F 0 "C204" V 4921 3300 50  0000 C CNN
F 1 "100nF" V 5012 3300 50  0000 C CNN
F 2 "" H 5150 3300 50  0001 C CNN
F 3 "~" H 5150 3300 50  0001 C CNN
	1    5150 3300
	0    -1   1    0   
$EndComp
Wire Wire Line
	5050 3300 4700 3300
Wire Wire Line
	5250 3300 5300 3300
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
	6050 3500 5700 3500
Connection ~ 5700 3500
Wire Wire Line
	4750 2400 4750 3200
$Comp
L Device:C_Small C?
U 1 1 5B723443
P 3900 2550
AR Path="/5B723443" Ref="C?"  Part="1" 
AR Path="/5B7230C4/5B723443" Ref="C201"  Part="1" 
AR Path="/5B725BF5/5B723443" Ref="C301"  Part="1" 
F 0 "C201" H 3992 2596 50  0000 L CNN
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
AR Path="/5B7230C4/5B72344C" Ref="#PWR0202"  Part="1" 
AR Path="/5B725BF5/5B72344C" Ref="#PWR0302"  Part="1" 
F 0 "#PWR0202" H 4300 2450 50  0001 C CNN
F 1 "GND" H 4305 2527 50  0000 C CNN
F 2 "" H 4300 2700 50  0001 C CNN
F 3 "" H 4300 2700 50  0001 C CNN
	1    4300 2700
	1    0    0    -1  
$EndComp
Wire Wire Line
	4300 2650 4300 2700
$Comp
L Device:C_Small C?
U 1 1 5B723454
P 5550 2550
AR Path="/5B723454" Ref="C?"  Part="1" 
AR Path="/5B7230C4/5B723454" Ref="C202"  Part="1" 
AR Path="/5B725BF5/5B723454" Ref="C302"  Part="1" 
F 0 "C202" H 5642 2596 50  0000 L CNN
F 1 "470uF" H 5642 2505 50  0000 L CNN
F 2 "Capacitors_ThroughHole:CP_Radial_D10.0mm_P5.00mm" H 5550 2550 50  0001 C CNN
F 3 "~" H 5550 2550 50  0001 C CNN
F 4 "140-REA471M1EBK1012P" H 5550 2550 50  0001 C CNN "Mouser"
	1    5550 2550
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C?
U 1 1 5B72345C
P 6000 2550
AR Path="/5B72345C" Ref="C?"  Part="1" 
AR Path="/5B7230C4/5B72345C" Ref="C203"  Part="1" 
AR Path="/5B725BF5/5B72345C" Ref="C303"  Part="1" 
F 0 "C203" H 6092 2596 50  0000 L CNN
F 1 "1000uF" H 6092 2505 50  0000 L CNN
F 2 "Capacitors_ThroughHole:CP_Radial_D18.0mm_P7.50mm" H 6000 2550 50  0001 C CNN
F 3 "~" H 6000 2550 50  0001 C CNN
F 4 "598-108SAK025M" H 6000 2550 50  0001 C CNN "Mouser"
	1    6000 2550
	1    0    0    -1  
$EndComp
Wire Wire Line
	5550 2450 5550 2400
Wire Wire Line
	6000 2450 6000 2400
Wire Wire Line
	6000 2400 5550 2400
$Comp
L power:GND #PWR?
U 1 1 5B723466
P 6000 2800
AR Path="/5B723466" Ref="#PWR?"  Part="1" 
AR Path="/5B7230C4/5B723466" Ref="#PWR0203"  Part="1" 
AR Path="/5B725BF5/5B723466" Ref="#PWR0303"  Part="1" 
F 0 "#PWR0203" H 6000 2550 50  0001 C CNN
F 1 "GND" H 6005 2627 50  0000 C CNN
F 2 "" H 6000 2800 50  0001 C CNN
F 3 "" H 6000 2800 50  0001 C CNN
	1    6000 2800
	1    0    0    -1  
$EndComp
Wire Wire Line
	5550 2650 5550 2700
Wire Wire Line
	5550 2700 6000 2700
Wire Wire Line
	6000 2700 6000 2800
Wire Wire Line
	6000 2650 6000 2700
Connection ~ 6000 2700
Wire Wire Line
	5400 2300 5400 2400
$Comp
L Device:L_Small L?
U 1 1 5B723472
P 5100 2400
AR Path="/5B723472" Ref="L?"  Part="1" 
AR Path="/5B7230C4/5B723472" Ref="L201"  Part="1" 
AR Path="/5B725BF5/5B723472" Ref="L301"  Part="1" 
F 0 "L201" V 5285 2400 50  0000 C CNN
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
AR Path="/5B725BF5/5B72347E" Ref="#PWR0301"  Part="1" 
F 0 "#PWR0201" H 5400 2150 50  0001 C CNN
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
Wire Wire Line
	5400 2400 5550 2400
Connection ~ 5550 2400
$Comp
L peripherals:Q_NMOS_SSSGDDDD Q?
U 1 1 5B723489
P 5400 3900
AR Path="/5B723489" Ref="Q?"  Part="1" 
AR Path="/5B7230C4/5B723489" Ref="Q202"  Part="1" 
AR Path="/5B725BF5/5B723489" Ref="Q302"  Part="1" 
F 0 "Q202" H 5788 3946 50  0000 L CNN
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
P 5050 3900
AR Path="/5B727333" Ref="R?"  Part="1" 
AR Path="/5B7230C4/5B727333" Ref="R?"  Part="1" 
AR Path="/5B725BF5/5B727333" Ref="R?"  Part="1" 
F 0 "R?" V 4854 3900 50  0000 C CNN
F 1 "0" V 4945 3900 50  0000 C CNN
F 2 "Resistors_SMD:R_0603_HandSoldering" H 5050 3900 50  0001 C CNN
F 3 "~" H 5050 3900 50  0001 C CNN
F 4 "755-SFR03EZPJ000" V 5050 3900 50  0001 C CNN "Mouser"
	1    5050 3900
	0    1    1    0   
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
AR Path="/5B7230C4/5B728A25" Ref="#PWR?"  Part="1" 
AR Path="/5B725BF5/5B728A25" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 3900 2450 50  0001 C CNN
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
AR Path="/5B7230C4/5B72F72D" Ref="C?"  Part="1" 
AR Path="/5B725BF5/5B72F72D" Ref="C?"  Part="1" 
F 0 "C?" H 4392 2596 50  0000 L CNN
F 1 "100nF" H 4392 2505 50  0000 L CNN
F 2 "Capacitors_SMD:C_0402" H 4300 2550 50  0001 C CNN
F 3 "~" H 4300 2550 50  0001 C CNN
F 4 "710-885012105018" H 4300 2550 50  0001 C CNN "Mouser"
	1    4300 2550
	1    0    0    -1  
$EndComp
$EndSCHEMATC
