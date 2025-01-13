function Symbols = MyModulater(Bits, M, Type)
Bits = Bits(:);
k = log2(M);
GrayedBits = cell(k, 1);
GrayedBitsDigits = cell(k, 1);
GrayedBits{1} = [0; 1];
GrayedBitsDigits{1} = [0; 1];
for i = 2 : k
    GrayedBits{i} = [zeros(2 ^ (i - 1), 1), GrayedBits{i - 1}; ones(2 ^ (i - 1), 1), flipud(GrayedBits{i - 1})];
    GrayedBitsDigits{i} = sum(GrayedBits{i} .* repmat(2 .^ (i - 1 : -1 : 0), size(GrayedBits{i}, 1), 1), 2);
end
% GrayedBitsM = GrayedBits{k};
GrayedBitsDigitsM = GrayedBitsDigits{k};
switch Type
    case 'PSK'
        iVec = 0 : M - 1;
        AlphabetMPSK = exp(1j * 2 * pi / M * iVec);
        Es = 1;
        SymbolsDigitsMat = buffer(Bits, k);
        Bin2DecConversion = repmat(2 .^ (k - 1 : -1 : 0).', 1, size(SymbolsDigitsMat, 2));
        SymbolsDigits = sum(Bin2DecConversion .* SymbolsDigitsMat, 1);
        SymbolsDigitsGray = mod(find(GrayedBitsDigitsM == SymbolsDigits) - 1, M) + 1;
        Symbols = AlphabetMPSK(SymbolsDigitsGray).' / sqrt(Es);
    case 'QAM'
        AlphabetMQAM = -sqrt(M) + 1 : 2 : sqrt(M) - 1;
        A2 = AlphabetMQAM .^ 2;
        Es = sum(sum(repmat(A2, sqrt(M), 1) + repmat(A2.', 1, sqrt(M)))) / M;
        SymbolsDigitsMat = buffer(Bits, k);
        Bin2DecConversion = repmat(2 .^ (k / 2 - 1 : -1 : 0).', 1, size(SymbolsDigitsMat, 2));
        SymbolsDigitsReal = sum(Bin2DecConversion .* SymbolsDigitsMat(1 : k / 2, :), 1);
        SymbolsDigitsImag = sum(Bin2DecConversion .* SymbolsDigitsMat(k / 2 + 1 : k, :), 1);
        SymbolsDigitsGrayReal = mod(find(GrayedBitsDigitsM == SymbolsDigitsReal) - 1, M) + 1;
        SymbolsDigitsGrayImag = mod(find(GrayedBitsDigitsM == SymbolsDigitsImag) - 1, M) + 1;
        Symbols = (AlphabetMQAM(SymbolsDigitsGrayReal).' + 1j * AlphabetMQAM(SymbolsDigitsGrayImag).') / sqrt(Es);
    otherwise
        disp('Please choose between "PSK" and "QAM".')
end