% Stability analysis for a JFET-bootstraped TIA
pkg load control;
s = tf('s');

Cds=100e-12;
Ra=1e+3;        % Rds || Rb, approx. Rb
gm=2.5e-3;
Cb=50e-12+4e-12; % Cpd + Cgs
Rf=1e+6;
Cf=0.2e-12;

GBW=3e+6;    % OPA189

Za = Ra/(1+Ra*Cds*s);
Zeq1=Za + Za*gm/(s*Cb) + 1/(s*Cb);
Zeq=1/(1/Zeq1+(7.2e-12+2e-12)*s);   % Cin + Cgd
Hg = 1/(s/(2*pi*GBW));
Hlg = Zeq/(Zeq+Rf/(1+Rf*5e-12*s));  % Cf set here
%margin(Hg*Hlg)
Zf=Rf/(1+Rf*Cf*s);
bode(minreal(Hg*Zf/(-(Hg+1)*Zeq)+Zf))
input("foo")
