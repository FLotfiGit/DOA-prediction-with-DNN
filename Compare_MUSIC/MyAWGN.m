function NoisySymbols = MyAWGN(Symbols, M, EbN0dB)
[N, Mr] = size(Symbols);
k = log2(M);
EbN0 = db2pow(EbN0dB);
EsN0 = k * EbN0;
EsN0Mag = sqrt(EsN0);
Noise = (randn(N, Mr) + 1j * randn(N, Mr)) / sqrt(2);
NoisySymbols = Symbols + Noise ./ EsN0Mag;