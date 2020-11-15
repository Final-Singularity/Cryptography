%% Defining the parameters

%K = '01001010111101111000';
%Kdec = bin2dec(K);
K0 = '0100';
K1 = '1010';
K2 = '1111';
K3 = '0111';
K4 = '1000';
K = append(K0,K1,K2,K3,K4);
IV0 = '0101';
IV1 = '1110';
IV2 = '1111';
IV3 = '1001';
IV4 = '0000';
IV = append(IV0,IV1,IV2,IV3,IV4);

%% 160 Word Generation

W = zeros(160,1);

W(1) = bin2dec(K0);
W(2) = bin2dec(K1);
W(3) = bin2dec(K2);
W(4) = bin2dec(K3);
W(5) = bin2dec(K4);
W(6) = bin2dec(K0);
W(7) = bin2dec(K1);
W(8) = bin2dec(K2);
W(9) = bin2dec(K3);
W(10) = bin2dec(K4);
W(11) = bin2dec(IV0);
W(12) = bin2dec(IV1);
W(13) = bin2dec(IV2);
W(14) = bin2dec(IV3);
W(15) = bin2dec(IV4);
W(16) = bin2dec(IV0);
W(17) = bin2dec(IV1);
W(18) = bin2dec(IV2);
W(19) = bin2dec(IV3);
W(20) = bin2dec(IV4);


for i=21:160
    temp = bin2dec(f2(dec2bin(W(i-2)))) + W(i-7) + bin2dec(f1(dec2bin(W(i-15)))) + W(i-16) + i;
    W(i) = mod(temp,16);
end
    

%% Table initialization

P = zeros(64,1);
Q = zeros(64,1);

for i=1:64
   P(i) = W(31+i);
   Q(i) = W(95+i);
end


%% Update and output equation

S = zeros(10,1);

for j=0:127
   i = 1+mod(j,64);
   
   if( mod(j,128) < 64)
   temp = mod(P(i) + bin2dec(g1(dec2bin(P(1+mod(i-3,64))),dec2bin(P(1+mod(i-10,64))),dec2bin(P(1+mod(i-63,64))))),16);
   P(i) = bitxor(temp,h1(dec2bin(P(1+mod(i-12,64))),Q));
   else
   temp = mod(Q(i) + bin2dec(g2(dec2bin(Q(1+mod(i-3,64))),dec2bin(Q(1+mod(i-10,64))),dec2bin(Q(1+mod(i-63,64))))),16);
   Q(i) = bitxor(temp,h2(dec2bin(Q(1+mod(i-12,64))),P));    
   end

end

keystr = '';

for i=1:10
    temp = mod(P(i) + bin2dec(g1(dec2bin(P(1+mod(i-3,64))),dec2bin(P(1+mod(i-10,64))),dec2bin(P(1+mod(i-63,64))))),16);
    S(i) = bitxor(temp,h1(dec2bin(P(1+mod(i-12,64))),Q));
     if(length(dec2bin(S(i)))==1)
     word = append('0','0','0',dec2bin(S(i)));
     else if (length(dec2bin(S(i)))==2)
     word = append('0','0',dec2bin(S(i)));  
     else if (length(dec2bin(S(i)))==3)
             word = append('0',dec2bin(S(i)));
         else
             word = dec2bin(S(i));
         end
     end
     end
     
     keystr = append(keystr,word);
     
end

input = '0100001001010101010100100100111001010100';
cipher = dec2bin(bitxor(bin2dec(input),bin2dec(keystr)));

C0 = cipher(1:8);
C1 = cipher(9:16);
C2 = cipher(17:24);
C3 = cipher(25:32);
C4 = cipher(33:40);

output = dec2bin(bitxor(bin2dec(cipher),bin2dec(keystr)));
%% Functions

function y = rshift(x,n)
y0 = bitshift(bin2dec(x),-1*n);
y = dec2bin(mod(y0,16));
end

function y = lshift(x,n)
y0 = bitshift(bin2dec(x), n);
y = dec2bin(mod(y0,16));
end

function y = rrot(x,n)
y0 = mod(bitshift(bin2dec(x), -1*n),16);
y1 = mod(bitshift(bin2dec(x), 4-n),16);
y = dec2bin(bitxor(y0,y1));
end

function y = lrot(x,n)
y0 = mod(bitshift(bin2dec(x), n),16);
y1 = mod(bitshift(bin2dec(x), -1*(4-n)),16);
y = dec2bin(bitxor(y0,y1));
end

function y = f1(x)
y0 = bitxor(bitxor(bin2dec(rrot(x,3)),bin2dec(rrot(x,2))),bin2dec(rshift(x,3)));
y = dec2bin(mod(y0,16));
end

function y = f2(x)
y0 = bitxor(bitxor(bin2dec(rrot(x,1)),bin2dec(rrot(x,3))),bin2dec(rshift(x,2)));
y = dec2bin(mod(y0,16));
end

function y = g1(x,y,z)
y0 = bitxor(bin2dec(rrot(x,2)),bin2dec(rrot(z,3))) + bin2dec(rshift(y,0));
y = dec2bin(mod(y0,16));
end

function y = g2(x,y,z)
y0 = bitxor(bin2dec(lrot(x,2)),bin2dec(lrot(z,3))) + bin2dec(lshift(y,0));
y = dec2bin(mod(y0,16));
end

function y = h1(x,Q)
if(length(x)==1)
    t = append('0','0','0',x);
else if (length(x)==2)
    t = append('0','0',x);  
    else if (length(x)==3)
            t = append('0',x);
        else
            t = x;
        end
    end
end
y0 = Q(1+bin2dec(t(3:4))) + Q(32 + 1 + bin2dec(t(1:2)));
y = mod(y0,16);
end

function y = h2(x,P)
if(length(x)==1)
    t = append('0','0','0',x);
else if (length(x)==2)
    t = append('0','0',x);  
    else if (length(x)==3)
            t = append('0',x);
        else
            t = x;
        end
    end
end
y0 = P(1+bin2dec(t(3:4))) + P(32 + 1 + bin2dec(t(1:2)));
y = mod(y0,16);
end




