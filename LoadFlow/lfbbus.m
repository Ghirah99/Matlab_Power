%  This program obtains th Bus Admittance Matrix for power flow solution
%  Copyright (c) 1998 by H. Saadat


nl = linedata(:,1); nr = linedata(:,2);
X = linedata(:,4); 
nbr=length(linedata(:,1)); nbus = max(max(nl), max(nr));
B = X; y= ones(nbr,1)./B;        %branch admittance
for n = 1:nbr
if a(n) <= 0  a(n) = 1; else end
Bbus=zeros(nbus,nbus);     % initialize Ybus to zero
               % formation of the off diagonal elements
for k=1:nbr;
       Bbus(nl(k),nr(k))=Bbus(nl(k),nr(k))-y(k);
       Bbus(nr(k),nl(k))=Bbus(nl(k),nr(k));
    end
end
              % formation of the diagonal elements
for  n=1:nbus
     for k=1:nbr
         if nl(k)==n
         Bbus(n,n) = Bbus(n,n)+y(k);
         elseif nr(k)==n
         Bbus(n,n) = Bbus(n,n)+y(k);
         else, end
     end
end
clear Pgg
