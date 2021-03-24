function PemoQ = psmt2pemoq(PSMt)

a = -0.22;
b = 0.98;
c = -4.13;
d = 16.4;
x0 = 0.864;

if PSMt < x0
    PemoQ = max(-4, a/(PSMt-b)+c);
else
    PemoQ = d*PSMt-d;
end
