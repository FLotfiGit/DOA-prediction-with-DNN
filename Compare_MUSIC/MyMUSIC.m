function AoA_Est = MyMUSIC(AoA, EbN0dB)
LenAoAs = length(AoA);
Type = 'PSK';
M = 2;
k = log2(M);
Mr = 4;
N = 1e5;
Bits = round(rand(N, LenAoAs)); % The first column is the desired signal, others are interferers
NSym = ceil(N / k);
dLambda = 1 / 2;
A = exp(-1j * 2 * pi * dLambda * sin(AoA) * (0 : (Mr - 1))) / sqrt(Mr);
Symbols = zeros(NSym, LenAoAs);
SymbolsBF = zeros(NSym, Mr);
for i = 1 : LenAoAs
    aRep = repmat(A(i, :), NSym, 1);
    Symbols(:, i) = MyModulater(Bits(:, i), M, Type);
    SymbolsRep = repmat(Symbols(:, i), 1, Mr);
    SymbolsBF = SymbolsBF + aRep .* SymbolsRep;
end
NoisySymbolsBF = MyAWGN(SymbolsBF, M, EbN0dB);
Rrr_Est = NoisySymbolsBF.' * conj(NoisySymbolsBF) / N;
[Q, Lambda] = eig(Rrr_Est);
LambdaVals = real(diag(Lambda));
[~, IndSort] = sort(LambdaVals);
V = Q(:, IndSort(1 : Mr - LenAoAs));
Theta = -pi / 2 : pi / 1000 : pi / 2;
LenTheta = length(Theta);
P = zeros(LenTheta, 1);
for iTheta = 1 : LenTheta
    aTheta = exp(-1j * 2 * pi * dLambda * sin(Theta(iTheta)) * (0 : (Mr - 1)).') / sqrt(Mr);
    P(iTheta) = abs(real((aTheta' * aTheta) / (aTheta' * (V * V') * aTheta)));
end
[PeakVal, AoA_Est_Raw] = findpeaks(P);
[~, IndSort] = sort(PeakVal, 'descend');
if length(IndSort) == LenAoAs
    AoA_Est_Raw = AoA_Est_Raw(IndSort(1 : LenAoAs));
    AoA_Est = Theta(AoA_Est_Raw);
else
    AoA_Est = AoA.'; % Ignoring the case of very close AoAs
end
end