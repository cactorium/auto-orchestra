% Stability analysis for a JFET-bootstraped TIA
pkg load control;
s = tf('s');

Cb=10e-12+10e-12; % Cpd + Cin
Rf=4e+6;
Cf=2e-12;

GBW=3e+6;    % OPA189

Zeq=1/(Cb*s);
Hg = 1/(s/(2*pi*GBW));
Hlg = Zeq/(Zeq+Rf/(1+Rf*5e-12*s));  % Cf set here
margin(Hg*Hlg)
x=input("foo", "s");
Zf=Rf/(1+Rf*Cf*s);
bode(minreal(Hg*Zf/(-(Hg+1)*Zeq)+Zf))
x=input("foo", "s");
