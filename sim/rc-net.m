pkg load control;
s=tf('s');
R1=1e+3;C1=3.3e-9;R2=10e+3;C2=33e-9;
Zeq=1/(s*C1+1/(1/(s*C2)+R2)); Va=Zeq/(Zeq+R1);Io=Va/(R2+1/(s*C2));
bode(Io)
input("foo", "s");
bode(Zeq+R1)
input("foo", "s");
