EESchema Schematic File Version 4
LIBS:controller-cache
EELAYER 26 0
EELAYER END
$Descr USLetter 11000 8500
encoding utf-8
Sheet 1 1
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
L controllerparts:LIS2DE12TR U?
U 1 1 5B819573
P 7900 2850
F 0 "U?" H 7900 3315 50  0000 C CNN
F 1 "LIS2DE12TR" H 7900 3224 50  0000 C CNN
F 2 "" H 7900 2850 50  0001 C CNN
F 3 "" H 7900 2850 50  0001 C CNN
	1    7900 2850
	1    0    0    -1  
$EndComp
$Comp
L controllerparts:BMG250 U?
U 1 1 5B819639
P 8850 5150
F 0 "U?" H 8850 5615 50  0000 C CNN
F 1 "BMG250" H 8850 5524 50  0000 C CNN
F 2 "" H 8850 5150 50  0001 C CNN
F 3 "" H 8850 5150 50  0001 C CNN
	1    8850 5150
	1    0    0    -1  
$EndComp
$Comp
L controllerparts:TPS613222ADBVR U?
U 1 1 5B81971E
P 3900 1650
F 0 "U?" H 3925 1915 50  0000 C CNN
F 1 "TPS613222ADBVR" H 3925 1824 50  0000 C CNN
F 2 "" H 3900 1650 50  0001 C CNN
F 3 "" H 3900 1650 50  0001 C CNN
	1    3900 1650
	1    0    0    -1  
$EndComp
$Comp
L Connector_Generic:Conn_01x02 J?
U 1 1 5B819964
P 850 1650
F 0 "J?" H 770 1867 50  0000 C CNN
F 1 "Conn_01x02" H 770 1776 50  0000 C CNN
F 2 "" H 850 1650 50  0001 C CNN
F 3 "~" H 850 1650 50  0001 C CNN
	1    850  1650
	-1   0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5B819CCE
P 8100 3450
F 0 "#PWR?" H 8100 3200 50  0001 C CNN
F 1 "GND" H 8105 3277 50  0000 C CNN
F 2 "" H 8100 3450 50  0001 C CNN
F 3 "" H 8100 3450 50  0001 C CNN
	1    8100 3450
	1    0    0    -1  
$EndComp
Wire Wire Line
	8100 3350 8100 3400
Wire Wire Line
	8000 3350 8000 3400
Wire Wire Line
	8000 3400 8100 3400
Connection ~ 8100 3400
Wire Wire Line
	8100 3400 8100 3450
Wire Wire Line
	7900 3350 7900 3400
Wire Wire Line
	7900 3400 8000 3400
Connection ~ 8000 3400
Wire Wire Line
	7800 3350 7800 3400
Wire Wire Line
	7800 3400 7900 3400
Connection ~ 7900 3400
$Comp
L power:GND #PWR?
U 1 1 5B819EA0
P 8350 5950
F 0 "#PWR?" H 8350 5700 50  0001 C CNN
F 1 "GND" H 8355 5777 50  0000 C CNN
F 2 "" H 8350 5950 50  0001 C CNN
F 3 "" H 8350 5950 50  0001 C CNN
	1    8350 5950
	1    0    0    -1  
$EndComp
Wire Wire Line
	8400 5850 8350 5850
Wire Wire Line
	8350 5850 8350 5950
Wire Wire Line
	8400 5750 8350 5750
Wire Wire Line
	8350 5750 8350 5850
Connection ~ 8350 5850
$Comp
L power:GND #PWR?
U 1 1 5B819FE3
P 7250 3150
F 0 "#PWR?" H 7250 2900 50  0001 C CNN
F 1 "GND" H 7255 2977 50  0000 C CNN
F 2 "" H 7250 3150 50  0001 C CNN
F 3 "" H 7250 3150 50  0001 C CNN
	1    7250 3150
	1    0    0    -1  
$EndComp
Wire Wire Line
	7300 3050 7250 3050
Wire Wire Line
	7250 3050 7250 3150
$Comp
L power:GND #PWR?
U 1 1 5B81A0E0
P 3900 2250
F 0 "#PWR?" H 3900 2000 50  0001 C CNN
F 1 "GND" H 3905 2077 50  0000 C CNN
F 2 "" H 3900 2250 50  0001 C CNN
F 3 "" H 3900 2250 50  0001 C CNN
	1    3900 2250
	1    0    0    -1  
$EndComp
Wire Wire Line
	3900 2050 3900 2250
$Comp
L power:GND #PWR?
U 1 1 5B81A289
P 6450 5100
F 0 "#PWR?" H 6450 4850 50  0001 C CNN
F 1 "GND" H 6455 4927 50  0000 C CNN
F 2 "" H 6450 5100 50  0001 C CNN
F 3 "" H 6450 5100 50  0001 C CNN
	1    6450 5100
	1    0    0    -1  
$EndComp
Wire Wire Line
	6450 5100 6450 5000
Wire Wire Line
	6450 5000 6350 5000
$Comp
L Device:C_Small C?
U 1 1 5B81A521
P 4500 1850
F 0 "C?" H 4592 1896 50  0000 L CNN
F 1 "22uF" H 4592 1805 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805_HandSoldering" H 4500 1850 50  0001 C CNN
F 3 "~" H 4500 1850 50  0001 C CNN
F 4 "963-LMK212BJ226MG-T" H 4500 1850 50  0001 C CNN "Mouser"
	1    4500 1850
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5B81A5CB
P 4500 2050
F 0 "#PWR?" H 4500 1800 50  0001 C CNN
F 1 "GND" H 4505 1877 50  0000 C CNN
F 2 "" H 4500 2050 50  0001 C CNN
F 3 "" H 4500 2050 50  0001 C CNN
	1    4500 2050
	1    0    0    -1  
$EndComp
Wire Wire Line
	4300 1650 4500 1650
Wire Wire Line
	4500 1650 4500 1750
Wire Wire Line
	4500 1950 4500 2050
$Comp
L Device:L_Small L?
U 1 1 5B81AAF7
P 3350 1650
F 0 "L?" V 3535 1650 50  0000 C CNN
F 1 "4.7uH" V 3444 1650 50  0000 C CNN
F 2 "" H 3350 1650 50  0001 C CNN
F 3 "~" H 3350 1650 50  0001 C CNN
	1    3350 1650
	0    -1   -1   0   
$EndComp
Wire Wire Line
	3450 1650 3550 1650
Wire Wire Line
	3250 1650 3150 1650
Wire Wire Line
	3150 1650 3150 1750
$Comp
L power:GND #PWR?
U 1 1 5B81B00B
P 3150 2050
F 0 "#PWR?" H 3150 1800 50  0001 C CNN
F 1 "GND" H 3155 1877 50  0000 C CNN
F 2 "" H 3150 2050 50  0001 C CNN
F 3 "" H 3150 2050 50  0001 C CNN
	1    3150 2050
	1    0    0    -1  
$EndComp
Wire Wire Line
	3150 1950 3150 2050
Connection ~ 3150 1650
Text Label 2000 1650 2    50   ~ 0
+VBAT
$Comp
L power:GND #PWR?
U 1 1 5B81B8C8
P 1150 1850
F 0 "#PWR?" H 1150 1600 50  0001 C CNN
F 1 "GND" H 1155 1677 50  0000 C CNN
F 2 "" H 1150 1850 50  0001 C CNN
F 3 "" H 1150 1850 50  0001 C CNN
	1    1150 1850
	1    0    0    -1  
$EndComp
Wire Wire Line
	1150 1850 1150 1750
Wire Wire Line
	1150 1750 1050 1750
Text Label 4800 1650 2    50   ~ 0
+5V
Wire Wire Line
	4800 1650 4500 1650
Connection ~ 4500 1650
$Comp
L Device:Q_PMOS_DGS Q?
U 1 1 5B81CA73
P 2600 1750
F 0 "Q?" V 2943 1750 50  0000 C CNN
F 1 "Q_PMOS_DGS" V 2852 1750 50  0000 C CNN
F 2 "" H 2800 1850 50  0001 C CNN
F 3 "~" H 2600 1750 50  0001 C CNN
	1    2600 1750
	0    1    -1   0   
$EndComp
Text Notes 1750 1350 0    50   ~ 0
TODO: make sure the pins are right!!
Wire Wire Line
	2800 1650 3150 1650
Wire Wire Line
	1050 1650 1300 1650
$Comp
L Device:R_Small R?
U 1 1 5B81DAE2
P 2600 2150
F 0 "R?" H 2659 2196 50  0000 L CNN
F 1 "1k" H 2659 2105 50  0000 L CNN
F 2 "Resistors_SMD:R_0603_HandSoldering" H 2600 2150 50  0001 C CNN
F 3 "~" H 2600 2150 50  0001 C CNN
F 4 "755-ESR03EZPJ102" H 2600 2150 50  0001 C CNN "Mouser"
	1    2600 2150
	1    0    0    -1  
$EndComp
Wire Wire Line
	2600 1950 2600 2050
Wire Wire Line
	2600 2400 2600 2250
Text Label 2600 2500 0    50   ~ 0
BOOT_EN
$Comp
L Connector_Generic:Conn_01x02 J?
U 1 1 5B81F303
P 6400 1500
F 0 "J?" H 6480 1492 50  0000 L CNN
F 1 "Conn_01x02" H 6480 1401 50  0000 L CNN
F 2 "" H 6400 1500 50  0001 C CNN
F 3 "~" H 6400 1500 50  0001 C CNN
	1    6400 1500
	1    0    0    -1  
$EndComp
Text Label 6150 1200 3    50   ~ 0
+5V
Wire Wire Line
	6150 1200 6150 1300
Wire Wire Line
	6150 1500 6200 1500
Wire Wire Line
	6200 1600 6150 1600
Wire Wire Line
	6150 1600 6150 1700
Text Label 2850 1650 0    50   ~ 0
+VAUX
Text Label 7750 4450 0    50   ~ 0
+VAUX
Wire Wire Line
	8300 4950 8300 5050
Wire Wire Line
	8300 5050 8400 5050
Connection ~ 8300 4950
Wire Wire Line
	8300 4950 8400 4950
$Comp
L Device:C_Small C?
U 1 1 5B8209B1
P 8200 4650
F 0 "C?" H 8109 4604 50  0000 R CNN
F 1 "100nF" H 8109 4695 50  0000 R CNN
F 2 "Capacitors_SMD:C_0402" H 8200 4650 50  0001 C CNN
F 3 "~" H 8200 4650 50  0001 C CNN
F 4 "710-885012105018" H 8200 4650 50  0001 C CNN "Mouser"
	1    8200 4650
	1    0    0    1   
$EndComp
$Comp
L Device:C_Small C?
U 1 1 5B820A8B
P 7750 4650
F 0 "C?" H 7659 4604 50  0000 R CNN
F 1 "100nF" H 7659 4695 50  0000 R CNN
F 2 "Capacitors_SMD:C_0402" H 7750 4650 50  0001 C CNN
F 3 "~" H 7750 4650 50  0001 C CNN
F 4 "710-885012105018" H 7750 4650 50  0001 C CNN "Mouser"
	1    7750 4650
	1    0    0    1   
$EndComp
Wire Wire Line
	8300 4500 8200 4500
Wire Wire Line
	7750 4500 7750 4550
Wire Wire Line
	7750 4450 7750 4500
Connection ~ 7750 4500
Wire Wire Line
	8200 4500 8200 4550
Connection ~ 8200 4500
Wire Wire Line
	8200 4500 7750 4500
Wire Wire Line
	8300 4500 8300 4950
$Comp
L power:GND #PWR?
U 1 1 5B8254F3
P 7750 4850
F 0 "#PWR?" H 7750 4600 50  0001 C CNN
F 1 "GND" H 7755 4677 50  0000 C CNN
F 2 "" H 7750 4850 50  0001 C CNN
F 3 "" H 7750 4850 50  0001 C CNN
	1    7750 4850
	1    0    0    -1  
$EndComp
Wire Wire Line
	7750 4750 7750 4850
$Comp
L power:GND #PWR?
U 1 1 5B825D38
P 8200 4850
F 0 "#PWR?" H 8200 4600 50  0001 C CNN
F 1 "GND" H 8205 4677 50  0000 C CNN
F 2 "" H 8200 4850 50  0001 C CNN
F 3 "" H 8200 4850 50  0001 C CNN
	1    8200 4850
	1    0    0    -1  
$EndComp
Wire Wire Line
	8200 4750 8200 4850
Text Label 9350 1800 2    50   ~ 0
+VAUX
$Comp
L Device:C_Small C?
U 1 1 5B8268ED
P 8900 2000
F 0 "C?" H 8809 1954 50  0000 R CNN
F 1 "100nF" H 8809 2045 50  0000 R CNN
F 2 "Capacitors_SMD:C_0402" H 8900 2000 50  0001 C CNN
F 3 "~" H 8900 2000 50  0001 C CNN
F 4 "710-885012105018" H 8900 2000 50  0001 C CNN "Mouser"
	1    8900 2000
	-1   0    0    1   
$EndComp
$Comp
L Device:C_Small C?
U 1 1 5B8268F3
P 9350 2000
F 0 "C?" H 9259 1954 50  0000 R CNN
F 1 "100nF" H 9259 2045 50  0000 R CNN
F 2 "Capacitors_SMD:C_0402" H 9350 2000 50  0001 C CNN
F 3 "~" H 9350 2000 50  0001 C CNN
F 4 "710-885012105018" H 9350 2000 50  0001 C CNN "Mouser"
	1    9350 2000
	-1   0    0    1   
$EndComp
Wire Wire Line
	9350 1850 9350 1900
Wire Wire Line
	9350 1800 9350 1850
Connection ~ 9350 1850
Wire Wire Line
	8900 1850 8900 1900
Connection ~ 8900 1850
Wire Wire Line
	8900 1850 9350 1850
$Comp
L power:GND #PWR?
U 1 1 5B826900
P 9350 2200
F 0 "#PWR?" H 9350 1950 50  0001 C CNN
F 1 "GND" H 9355 2027 50  0000 C CNN
F 2 "" H 9350 2200 50  0001 C CNN
F 3 "" H 9350 2200 50  0001 C CNN
	1    9350 2200
	-1   0    0    -1  
$EndComp
Wire Wire Line
	9350 2100 9350 2200
$Comp
L power:GND #PWR?
U 1 1 5B826907
P 8900 2200
F 0 "#PWR?" H 8900 1950 50  0001 C CNN
F 1 "GND" H 8905 2027 50  0000 C CNN
F 2 "" H 8900 2200 50  0001 C CNN
F 3 "" H 8900 2200 50  0001 C CNN
	1    8900 2200
	-1   0    0    -1  
$EndComp
Wire Wire Line
	8900 2100 8900 2200
Wire Wire Line
	8600 1850 8600 2300
Wire Wire Line
	8600 2650 8500 2650
Wire Wire Line
	8600 1850 8900 1850
Wire Wire Line
	8600 2650 8600 2750
Wire Wire Line
	8600 2750 8500 2750
Connection ~ 8600 2650
$Comp
L controllerparts:MSP430FR2512IRHLR U?
U 2 1 5B878C49
P 4900 4800
F 0 "U?" H 5075 4865 50  0000 C CNN
F 1 "MSP430FR2512IRHLR" H 5075 4774 50  0000 C CNN
F 2 "" H 4900 4800 50  0001 C CNN
F 3 "" H 4900 4800 50  0001 C CNN
	2    4900 4800
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C?
U 1 1 5B879B1A
P 3300 5950
F 0 "C?" H 3208 5904 50  0000 R CNN
F 1 "0.33uF" H 3208 5995 50  0000 R CNN
F 2 "Capacitors_SMD:C_0402" H 3300 5950 50  0001 C CNN
F 3 "~" H 3300 5950 50  0001 C CNN
F 4 "710-885012105003" H 3300 5950 50  0001 C CNN "Mouser"
	1    3300 5950
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5B87A959
P 3300 6150
F 0 "#PWR?" H 3300 5900 50  0001 C CNN
F 1 "GND" V 3305 6022 50  0000 R CNN
F 2 "" H 3300 6150 50  0001 C CNN
F 3 "" H 3300 6150 50  0001 C CNN
	1    3300 6150
	1    0    0    -1  
$EndComp
Wire Wire Line
	3300 5850 3300 5700
Wire Wire Line
	3300 5700 3800 5700
Wire Wire Line
	3300 6050 3300 6150
Wire Wire Line
	2800 5600 3800 5600
Wire Wire Line
	2800 5500 3800 5500
$Comp
L Device:Crystal Y?
U 1 1 5B890FEE
P 3050 4200
F 0 "Y?" V 3004 4069 50  0000 R CNN
F 1 "32.786kHz" V 3095 4069 50  0000 R CNN
F 2 "" H 3050 4200 50  0001 C CNN
F 3 "~" H 3050 4200 50  0001 C CNN
	1    3050 4200
	0    -1   1    0   
$EndComp
$Comp
L Device:C_Small C?
U 1 1 5B896369
P 2800 4000
F 0 "C?" V 2571 4000 50  0000 C CNN
F 1 "10pF" V 2662 4000 50  0000 C CNN
F 2 "Capacitors_SMD:C_0402" H 2800 4000 50  0001 C CNN
F 3 "~" H 2800 4000 50  0001 C CNN
F 4 "81-GCQ1555C1H100RB1D" H 2800 4000 50  0001 C CNN "Mouser"
	1    2800 4000
	0    1    1    0   
$EndComp
$Comp
L Device:C_Small C?
U 1 1 5B8963EA
P 2800 4400
F 0 "C?" V 2571 4400 50  0000 C CNN
F 1 "10pF" V 2662 4400 50  0000 C CNN
F 2 "Capacitors_SMD:C_0402" H 2800 4400 50  0001 C CNN
F 3 "~" H 2800 4400 50  0001 C CNN
F 4 "81-GCQ1555C1H100RB1D" V 2800 4400 50  0001 C CNN "Mouser"
	1    2800 4400
	0    1    1    0   
$EndComp
Wire Wire Line
	2900 4400 3050 4400
Wire Wire Line
	3050 4400 3050 4350
Wire Wire Line
	3800 4250 3500 4250
Wire Wire Line
	3500 4250 3500 4400
Wire Wire Line
	3500 4400 3050 4400
Connection ~ 3050 4400
Wire Wire Line
	2900 4000 3050 4000
Wire Wire Line
	3050 4000 3050 4050
Wire Wire Line
	3050 4000 3350 4000
Wire Wire Line
	3350 4000 3350 4150
Wire Wire Line
	3350 4150 3800 4150
Connection ~ 3050 4000
$Comp
L power:GND #PWR?
U 1 1 5B89B5ED
P 3700 4050
F 0 "#PWR?" H 3700 3800 50  0001 C CNN
F 1 "GND" V 3705 3922 50  0000 R CNN
F 2 "" H 3700 4050 50  0001 C CNN
F 3 "" H 3700 4050 50  0001 C CNN
	1    3700 4050
	0    1    1    0   
$EndComp
Wire Wire Line
	3700 4050 3800 4050
$Comp
L controllerparts:MSP430FR2512IRHLR U?
U 1 1 5B878BA4
P 4900 3350
F 0 "U?" H 5719 2746 50  0000 L CNN
F 1 "MSP430FR2512IRHLR" H 5719 2655 50  0000 L CNN
F 2 "" H 4900 3350 50  0001 C CNN
F 3 "" H 4900 3350 50  0001 C CNN
	1    4900 3350
	1    0    0    -1  
$EndComp
Wire Wire Line
	2650 4000 2700 4000
$Comp
L power:GND #PWR?
U 1 1 5B8A493D
P 2550 4400
F 0 "#PWR?" H 2550 4150 50  0001 C CNN
F 1 "GND" V 2555 4272 50  0000 R CNN
F 2 "" H 2550 4400 50  0001 C CNN
F 3 "" H 2550 4400 50  0001 C CNN
	1    2550 4400
	0    1    1    0   
$EndComp
Wire Wire Line
	2550 4400 2650 4400
Wire Wire Line
	3550 4650 3550 4350
Wire Wire Line
	3550 4350 3800 4350
Wire Wire Line
	3600 4750 3600 4450
Wire Wire Line
	3600 4450 3800 4450
$Comp
L Device:C_Small C?
U 1 1 5B8A9CEB
P 1850 3650
F 0 "C?" H 1942 3696 50  0000 L CNN
F 1 "4.7uF" H 1942 3605 50  0000 L CNN
F 2 "Capacitors_SMD:C_0603_HandSoldering" H 1850 3650 50  0001 C CNN
F 3 "~" H 1850 3650 50  0001 C CNN
F 4 "810-CGB3B1X5R1A475MC" H 1850 3650 50  0001 C CNN "Mouser"
	1    1850 3650
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C?
U 1 1 5B8A9D61
P 2350 3650
F 0 "C?" H 2442 3696 50  0000 L CNN
F 1 "100nF" H 2442 3605 50  0000 L CNN
F 2 "Capacitors_SMD:C_0402" H 2350 3650 50  0001 C CNN
F 3 "~" H 2350 3650 50  0001 C CNN
F 4 "710-885012105018" H 2350 3650 50  0001 C CNN "Mouser"
	1    2350 3650
	1    0    0    -1  
$EndComp
Wire Wire Line
	2350 3550 2350 3450
Wire Wire Line
	3400 3950 3800 3950
Wire Wire Line
	2350 3450 3400 3450
Wire Wire Line
	3400 3450 3400 3950
Wire Wire Line
	1850 3550 1850 3450
Wire Wire Line
	1850 3450 2350 3450
Connection ~ 2350 3450
Text Label 2050 3450 2    50   ~ 0
+VBAT
$Comp
L power:GND #PWR?
U 1 1 5B8B288C
P 1850 3850
F 0 "#PWR?" H 1850 3600 50  0001 C CNN
F 1 "GND" H 1855 3677 50  0000 C CNN
F 2 "" H 1850 3850 50  0001 C CNN
F 3 "" H 1850 3850 50  0001 C CNN
	1    1850 3850
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5B8B28FA
P 2350 3850
F 0 "#PWR?" H 2350 3600 50  0001 C CNN
F 1 "GND" H 2355 3677 50  0000 C CNN
F 2 "" H 2350 3850 50  0001 C CNN
F 3 "" H 2350 3850 50  0001 C CNN
	1    2350 3850
	1    0    0    -1  
$EndComp
Wire Wire Line
	2650 4000 2650 4400
Connection ~ 2650 4400
Wire Wire Line
	2650 4400 2700 4400
Wire Wire Line
	2350 3750 2350 3850
Wire Wire Line
	1850 3750 1850 3850
Wire Wire Line
	3450 3750 3800 3750
Wire Wire Line
	3450 3850 3800 3850
Text Label 3450 3750 0    50   ~ 0
SBWTCK
Text Label 3450 3850 0    50   ~ 0
SBWTDIO
$Comp
L Device:R_Small R?
U 1 1 5B8D47EE
P 2700 5500
F 0 "R?" V 2896 5500 50  0000 C CNN
F 1 "470" V 2805 5500 50  0000 C CNN
F 2 "Resistors_SMD:R_0402" H 2700 5500 50  0001 C CNN
F 3 "~" H 2700 5500 50  0001 C CNN
F 4 "791-RMC1/16S-471JTH" H 2700 5500 50  0001 C CNN "Mouser"
	1    2700 5500
	0    -1   -1   0   
$EndComp
$Comp
L Device:R_Small R?
U 1 1 5B8D48B1
P 2700 5600
F 0 "R?" V 2896 5600 50  0000 C CNN
F 1 "470" V 2805 5600 50  0000 C CNN
F 2 "Resistors_SMD:R_0402" H 2700 5600 50  0001 C CNN
F 3 "~" H 2700 5600 50  0001 C CNN
F 4 "791-RMC1/16S-471JTH" H 2700 5600 50  0001 C CNN "Mouser"
	1    2700 5600
	0    -1   1    0   
$EndComp
Wire Wire Line
	2100 5600 2600 5600
$Comp
L power:GND #PWR?
U 1 1 5B8E8F76
P 6150 2500
F 0 "#PWR?" H 6150 2250 50  0001 C CNN
F 1 "GND" H 6155 2327 50  0000 C CNN
F 2 "" H 6150 2500 50  0001 C CNN
F 3 "" H 6150 2500 50  0001 C CNN
	1    6150 2500
	1    0    0    -1  
$EndComp
Wire Wire Line
	6150 2400 6150 2500
Wire Wire Line
	6150 1900 6150 2000
Wire Wire Line
	5750 2200 5850 2200
Wire Wire Line
	5100 2200 5550 2200
Text Label 5100 2200 0    50   ~ 0
LED_EN
Text Label 2900 5200 0    50   ~ 0
LED_EN
Text Label 2900 4650 0    50   ~ 0
SCL
Text Label 2900 4750 0    50   ~ 0
SDA
$Comp
L Connector_Generic:Conn_01x03 J?
U 1 1 5B8F880E
P 1900 5600
F 0 "J?" H 1820 5917 50  0000 C CNN
F 1 "Conn_01x03" H 1820 5826 50  0000 C CNN
F 2 "" H 1900 5600 50  0001 C CNN
F 3 "~" H 1900 5600 50  0001 C CNN
	1    1900 5600
	-1   0    0    -1  
$EndComp
Wire Wire Line
	2100 5500 2600 5500
$Comp
L power:GND #PWR?
U 1 1 5B8FBC5B
P 2200 5800
F 0 "#PWR?" H 2200 5550 50  0001 C CNN
F 1 "GND" H 2205 5627 50  0000 C CNN
F 2 "" H 2200 5800 50  0001 C CNN
F 3 "" H 2200 5800 50  0001 C CNN
	1    2200 5800
	1    0    0    -1  
$EndComp
Wire Wire Line
	2200 5800 2200 5700
Wire Wire Line
	2200 5700 2100 5700
$Comp
L Device:C_Small C?
U 1 1 5B8FF17C
P 2850 5950
F 0 "C?" H 2758 5904 50  0000 R CNN
F 1 "0.33uF" H 2758 5995 50  0000 R CNN
F 2 "Capacitors_SMD:C_0402" H 2850 5950 50  0001 C CNN
F 3 "~" H 2850 5950 50  0001 C CNN
F 4 "710-885012105003" H 2850 5950 50  0001 C CNN "Mouser"
	1    2850 5950
	-1   0    0    1   
$EndComp
$Comp
L Device:C_Small C?
U 1 1 5B8FF1D8
P 2400 5950
F 0 "C?" H 2308 5904 50  0000 R CNN
F 1 "0.33uF" H 2308 5995 50  0000 R CNN
F 2 "Capacitors_SMD:C_0402" H 2400 5950 50  0001 C CNN
F 3 "~" H 2400 5950 50  0001 C CNN
F 4 "710-885012105003" H 2400 5950 50  0001 C CNN "Mouser"
	1    2400 5950
	-1   0    0    1   
$EndComp
Wire Wire Line
	2850 5850 2850 5700
Wire Wire Line
	2850 5700 3300 5700
Connection ~ 3300 5700
Wire Wire Line
	2400 5850 2400 5700
Wire Wire Line
	2400 5700 2850 5700
Connection ~ 2850 5700
$Comp
L power:GND #PWR?
U 1 1 5B90921F
P 2850 6150
F 0 "#PWR?" H 2850 5900 50  0001 C CNN
F 1 "GND" V 2855 6022 50  0000 R CNN
F 2 "" H 2850 6150 50  0001 C CNN
F 3 "" H 2850 6150 50  0001 C CNN
	1    2850 6150
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5B909266
P 2400 6150
F 0 "#PWR?" H 2400 5900 50  0001 C CNN
F 1 "GND" V 2405 6022 50  0000 R CNN
F 2 "" H 2400 6150 50  0001 C CNN
F 3 "" H 2400 6150 50  0001 C CNN
	1    2400 6150
	1    0    0    -1  
$EndComp
Wire Wire Line
	2400 6050 2400 6150
Wire Wire Line
	2850 6050 2850 6150
Text Label 2900 5100 0    50   ~ 0
BOOT_EN
Wire Wire Line
	2900 5100 3800 5100
Wire Wire Line
	2900 5200 3800 5200
Text Label 3450 3550 0    50   ~ 0
CAP
Wire Wire Line
	3450 3550 3800 3550
$Comp
L Connector_Generic:Conn_02x02_Odd_Even J?
U 1 1 5B91C477
P 3600 6950
F 0 "J?" H 3650 7167 50  0000 C CNN
F 1 "Conn_02x02_Odd_Even" H 3650 7076 50  0000 C CNN
F 2 "" H 3600 6950 50  0001 C CNN
F 3 "~" H 3600 6950 50  0001 C CNN
	1    3600 6950
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole MH?
U 1 1 5B91C86E
P 1200 6900
F 0 "MH?" H 1300 6946 50  0000 L CNN
F 1 "MountingHole" H 1300 6855 50  0000 L CNN
F 2 "" H 1200 6900 50  0001 C CNN
F 3 "~" H 1200 6900 50  0001 C CNN
	1    1200 6900
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole MH?
U 1 1 5B91C8C6
P 1200 7200
F 0 "MH?" H 1300 7246 50  0000 L CNN
F 1 "MountingHole" H 1300 7155 50  0000 L CNN
F 2 "" H 1200 7200 50  0001 C CNN
F 3 "~" H 1200 7200 50  0001 C CNN
	1    1200 7200
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5B91CC97
P 4000 7100
F 0 "#PWR?" H 4000 6850 50  0001 C CNN
F 1 "GND" H 4005 6927 50  0000 C CNN
F 2 "" H 4000 7100 50  0001 C CNN
F 3 "" H 4000 7100 50  0001 C CNN
	1    4000 7100
	1    0    0    -1  
$EndComp
Wire Wire Line
	4000 7100 4000 7050
Wire Wire Line
	4000 7050 3900 7050
Wire Wire Line
	3050 6950 3400 6950
Wire Wire Line
	3050 7050 3400 7050
Wire Wire Line
	4200 6950 3900 6950
Text Label 3050 7050 0    50   ~ 0
SBWTCK
Text Label 4200 6950 2    50   ~ 0
SBWTDIO
Text Label 3050 6950 0    50   ~ 0
+VBAT
Text Notes 3250 1400 0    50   ~ 0
TODO source
Text Label 5200 7100 0    50   ~ 0
SBWTDIO
$Comp
L Device:R_Small R?
U 1 1 5B92E01E
P 5100 6900
F 0 "R?" H 5159 6946 50  0000 L CNN
F 1 "47k" H 5159 6855 50  0000 L CNN
F 2 "Resistors_SMD:R_0603_HandSoldering" H 5100 6900 50  0001 C CNN
F 3 "~" H 5100 6900 50  0001 C CNN
F 4 "603-RC0603JR-0747KL" H 5100 6900 50  0001 C CNN "Mouser"
	1    5100 6900
	1    0    0    -1  
$EndComp
Wire Wire Line
	5100 7000 5100 7100
Wire Wire Line
	5100 7100 5200 7100
$Comp
L Device:C_Small C?
U 1 1 5B93219E
P 5100 7300
F 0 "C?" H 5192 7346 50  0000 L CNN
F 1 "1000pF 5%" H 5192 7255 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805_HandSoldering" H 5100 7300 50  0001 C CNN
F 3 "~" H 5100 7300 50  0001 C CNN
F 4 "710-885012207033" H 5100 7300 50  0001 C CNN "Mouser"
	1    5100 7300
	1    0    0    -1  
$EndComp
Wire Wire Line
	5100 7100 5100 7200
Connection ~ 5100 7100
Wire Wire Line
	5100 6700 5100 6800
Text Label 5100 6700 0    50   ~ 0
+VBAT
$Comp
L power:GND #PWR?
U 1 1 5B93A710
P 5100 7500
F 0 "#PWR?" H 5100 7250 50  0001 C CNN
F 1 "GND" H 5105 7327 50  0000 C CNN
F 2 "" H 5100 7500 50  0001 C CNN
F 3 "" H 5100 7500 50  0001 C CNN
	1    5100 7500
	1    0    0    -1  
$EndComp
Wire Wire Line
	5100 7400 5100 7500
Wire Wire Line
	2300 2250 2300 2400
Wire Wire Line
	2300 2400 2600 2400
Wire Wire Line
	2300 1650 2300 2050
Connection ~ 2300 1650
Wire Wire Line
	2300 1650 2400 1650
Wire Wire Line
	2600 2400 2600 2500
Connection ~ 2600 2400
$Comp
L Device:C_Small C?
U 1 1 5B95C75D
P 2000 1850
F 0 "C?" H 2092 1896 50  0000 L CNN
F 1 "4.7uF" H 2092 1805 50  0000 L CNN
F 2 "Capacitors_SMD:C_0603_HandSoldering" H 2000 1850 50  0001 C CNN
F 3 "~" H 2000 1850 50  0001 C CNN
F 4 "810-CGB3B1X5R1A475MC" H 2000 1850 50  0001 C CNN "Mouser"
	1    2000 1850
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5B95C8D6
P 2000 2050
F 0 "#PWR?" H 2000 1800 50  0001 C CNN
F 1 "GND" H 2005 1877 50  0000 C CNN
F 2 "" H 2000 2050 50  0001 C CNN
F 3 "" H 2000 2050 50  0001 C CNN
	1    2000 2050
	1    0    0    -1  
$EndComp
Wire Wire Line
	2000 1950 2000 2050
Wire Wire Line
	2000 1750 2000 1650
Wire Wire Line
	2000 1650 2300 1650
$Comp
L Device:C_Small C?
U 1 1 5B966D33
P 6400 1300
F 0 "C?" V 6171 1300 50  0000 C CNN
F 1 "4.7uF" V 6262 1300 50  0000 C CNN
F 2 "Capacitors_SMD:C_0603_HandSoldering" H 6400 1300 50  0001 C CNN
F 3 "~" H 6400 1300 50  0001 C CNN
F 4 "810-CGB3B1X5R1A475MC" H 6400 1300 50  0001 C CNN "Mouser"
	1    6400 1300
	0    1    1    0   
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5B966F19
P 6600 1300
F 0 "#PWR?" H 6600 1050 50  0001 C CNN
F 1 "GND" V 6605 1172 50  0000 R CNN
F 2 "" H 6600 1300 50  0001 C CNN
F 3 "" H 6600 1300 50  0001 C CNN
	1    6600 1300
	0    -1   -1   0   
$EndComp
Wire Wire Line
	6600 1300 6500 1300
Wire Wire Line
	6300 1300 6150 1300
Connection ~ 6150 1300
Wire Wire Line
	6150 1300 6150 1500
$Comp
L Device:C_Small C?
U 1 1 5B97280D
P 3150 1850
F 0 "C?" H 3242 1896 50  0000 L CNN
F 1 "4.7uF" H 3242 1805 50  0000 L CNN
F 2 "Capacitors_SMD:C_0603_HandSoldering" H 3150 1850 50  0001 C CNN
F 3 "~" H 3150 1850 50  0001 C CNN
F 4 "810-CGB3B1X5R1A475MC" H 3150 1850 50  0001 C CNN "Mouser"
	1    3150 1850
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small R?
U 1 1 5B979018
P 2300 2150
F 0 "R?" H 2359 2196 50  0000 L CNN
F 1 "47k" H 2359 2105 50  0000 L CNN
F 2 "Resistors_SMD:R_0603_HandSoldering" H 2300 2150 50  0001 C CNN
F 3 "~" H 2300 2150 50  0001 C CNN
F 4 "603-RC0603JR-0747KL" H 2300 2150 50  0001 C CNN "Mouser"
	1    2300 2150
	1    0    0    -1  
$EndComp
Text Notes 5300 1600 0    50   ~ 0
target: 2mA current
Text Notes 1650 5600 0    50   ~ 0
UART
Wire Wire Line
	7000 2650 7300 2650
Wire Wire Line
	7000 2950 7300 2950
Wire Wire Line
	6600 2700 6600 2750
Wire Wire Line
	6600 2750 7300 2750
Wire Wire Line
	6600 2500 6600 2300
Wire Wire Line
	6600 2300 8600 2300
Connection ~ 8600 2300
Wire Wire Line
	8600 2300 8600 2650
Text Label 7000 2650 0    50   ~ 0
SCL
Text Label 7000 2950 0    50   ~ 0
SDA
$Comp
L Device:R_Small R?
U 1 1 5B9909AB
P 2650 4650
F 0 "R?" V 2846 4650 50  0000 C CNN
F 1 "4.7k" V 2755 4650 50  0000 C CNN
F 2 "Resistors_SMD:R_0402" H 2650 4650 50  0001 C CNN
F 3 "~" H 2650 4650 50  0001 C CNN
F 4 "603-RT0402FRE074K7L" V 2650 4650 50  0001 C CNN "Mouser"
	1    2650 4650
	0    -1   -1   0   
$EndComp
$Comp
L Device:R_Small R?
U 1 1 5B990ADA
P 2650 4750
F 0 "R?" V 2846 4750 50  0000 C CNN
F 1 "4.7k" V 2755 4750 50  0000 C CNN
F 2 "Resistors_SMD:R_0402" H 2650 4750 50  0001 C CNN
F 3 "~" H 2650 4750 50  0001 C CNN
F 4 "603-RT0402FRE074K7L" H 2650 4750 50  0001 C CNN "Mouser"
	1    2650 4750
	0    1    1    0   
$EndComp
Wire Wire Line
	2750 4650 3550 4650
Wire Wire Line
	2750 4750 3600 4750
Wire Wire Line
	2400 4650 2550 4650
Wire Wire Line
	2400 4650 2400 4750
Wire Wire Line
	2400 4750 2550 4750
Text Label 2250 4650 2    50   ~ 0
+VBAT
Wire Wire Line
	2250 4650 2400 4650
Connection ~ 2400 4650
NoConn ~ 7300 2850
$Comp
L Device:C_Small C?
U 1 1 5B9B4109
P 9750 2000
F 0 "C?" H 9842 2046 50  0000 L CNN
F 1 "4.7uF" H 9842 1955 50  0000 L CNN
F 2 "Capacitors_SMD:C_0603_HandSoldering" H 9750 2000 50  0001 C CNN
F 3 "~" H 9750 2000 50  0001 C CNN
F 4 "810-CGB3B1X5R1A475MC" H 9750 2000 50  0001 C CNN "Mouser"
	1    9750 2000
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5B9B4311
P 9750 2200
F 0 "#PWR?" H 9750 1950 50  0001 C CNN
F 1 "GND" H 9755 2027 50  0000 C CNN
F 2 "" H 9750 2200 50  0001 C CNN
F 3 "" H 9750 2200 50  0001 C CNN
	1    9750 2200
	-1   0    0    -1  
$EndComp
Wire Wire Line
	9350 1850 9750 1850
Wire Wire Line
	9750 1850 9750 1900
Wire Wire Line
	9750 2100 9750 2200
NoConn ~ 8500 2850
NoConn ~ 8500 2950
Wire Wire Line
	7950 5550 8400 5550
Text Label 7950 5550 0    50   ~ 0
GYRO_RDY
$Comp
L power:GND #PWR?
U 1 1 5B9D40C5
P 8150 5250
F 0 "#PWR?" H 8150 5000 50  0001 C CNN
F 1 "GND" V 8155 5122 50  0000 R CNN
F 2 "" H 8150 5250 50  0001 C CNN
F 3 "" H 8150 5250 50  0001 C CNN
	1    8150 5250
	0    1    1    0   
$EndComp
Wire Wire Line
	8150 5250 8400 5250
Text Label 9700 5350 2    50   ~ 0
+VAUX
Text Label 9700 5250 2    50   ~ 0
SCL
Wire Wire Line
	9700 5250 9300 5250
Text Label 9700 5150 2    50   ~ 0
SDA
Wire Wire Line
	9700 5150 9300 5150
NoConn ~ 9300 5650
Wire Wire Line
	9300 5350 9700 5350
Text Notes 8800 2700 0    50   ~ 0
I2C address 0011000b
Text Notes 9300 4850 0    50   ~ 0
I2C address 1101000b
NoConn ~ 9300 5450
NoConn ~ 9300 5550
NoConn ~ 8400 5350
NoConn ~ 8400 5450
Text Label 2900 5000 0    50   ~ 0
GYRO_RDY
Wire Wire Line
	3550 5000 3800 5000
Wire Wire Line
	2900 5000 3350 5000
$Comp
L Device:R_Small R?
U 1 1 5BA30BFB
P 3450 5000
F 0 "R?" V 3646 5000 50  0000 C CNN
F 1 "1k" V 3555 5000 50  0000 C CNN
F 2 "Resistors_SMD:R_0603_HandSoldering" H 3450 5000 50  0001 C CNN
F 3 "~" H 3450 5000 50  0001 C CNN
F 4 "755-ESR03EZPJ102" H 3450 5000 50  0001 C CNN "Mouser"
	1    3450 5000
	0    -1   -1   0   
$EndComp
$Comp
L Device:R_Small R?
U 1 1 5BA54C9F
P 6600 2600
F 0 "R?" V 6796 2600 50  0000 C CNN
F 1 "4.7k" V 6705 2600 50  0000 C CNN
F 2 "Resistors_SMD:R_0402" H 6600 2600 50  0001 C CNN
F 3 "~" H 6600 2600 50  0001 C CNN
F 4 "603-RT0402FRE074K7L" H 6600 2600 50  0001 C CNN "Mouser"
	1    6600 2600
	-1   0    0    1   
$EndComp
$Comp
L Device:Q_NPN_BEC Q?
U 1 1 5BA64B46
P 6050 2200
F 0 "Q?" H 6241 2246 50  0000 L CNN
F 1 "Q_NPN_BEC" H 6241 2155 50  0000 L CNN
F 2 "TO_SOT_Packages_SMD:SOT-23_Handsoldering" H 6250 2300 50  0001 C CNN
F 3 "~" H 6050 2200 50  0001 C CNN
F 4 "863-BC847BLT1G" H 6050 2200 50  0001 C CNN "Mouser"
	1    6050 2200
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small R?
U 1 1 5BA65996
P 6150 1800
F 0 "R?" H 6209 1846 50  0000 L CNN
F 1 "1k" H 6209 1755 50  0000 L CNN
F 2 "Resistors_SMD:R_0603_HandSoldering" H 6150 1800 50  0001 C CNN
F 3 "~" H 6150 1800 50  0001 C CNN
F 4 "755-ESR03EZPJ102" H 6150 1800 50  0001 C CNN "Mouser"
	1    6150 1800
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small R?
U 1 1 5BA66121
P 5650 2200
F 0 "R?" V 5846 2200 50  0000 C CNN
F 1 "470" V 5755 2200 50  0000 C CNN
F 2 "Resistors_SMD:R_0402" H 5650 2200 50  0001 C CNN
F 3 "~" H 5650 2200 50  0001 C CNN
F 4 "791-RMC1/16S-471JTH" V 5650 2200 50  0001 C CNN "Mouser"
	1    5650 2200
	0    1    -1   0   
$EndComp
$Comp
L Device:Q_PMOS_DGS Q?
U 1 1 5BA6F00A
P 1500 1750
F 0 "Q?" V 1843 1750 50  0000 C CNN
F 1 "Q_PMOS_DGS" V 1752 1750 50  0000 C CNN
F 2 "" H 1700 1850 50  0001 C CNN
F 3 "~" H 1500 1750 50  0001 C CNN
	1    1500 1750
	0    -1   -1   0   
$EndComp
Wire Wire Line
	1700 1650 2000 1650
Connection ~ 2000 1650
Text Notes 1300 1450 0    50   ~ 0
TODO: make sure the pins are right!!
$Comp
L power:GND #PWR?
U 1 1 5BA89D83
P 1500 2050
F 0 "#PWR?" H 1500 1800 50  0001 C CNN
F 1 "GND" H 1505 1877 50  0000 C CNN
F 2 "" H 1500 2050 50  0001 C CNN
F 3 "" H 1500 2050 50  0001 C CNN
	1    1500 2050
	1    0    0    -1  
$EndComp
Wire Wire Line
	1500 1950 1500 2050
$EndSCHEMATC
