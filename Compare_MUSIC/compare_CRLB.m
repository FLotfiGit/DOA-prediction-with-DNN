EbN0dB = 0 : 2 : 10;
iSNRLen = length(EbN0dB);
Range = 0.8;%1;%0.9;%
Size = 1e4;
Sigma2 = 1 ./ db2pow(EbN0dB);
Mr = 10;
dLambda = 0.5;
NumSignals = 2;
MaxDiffDeg = 0.1; % [rad]
Target = (rand(Size, NumSignals) - 1 / 2) * pi * Range;
Ind1 = (abs(diff(Target, 1, 2)) < MaxDiffDeg) | (abs(diff(Target, 1, 2)) > pi - MaxDiffDeg);
Target(Ind1, :) = [];
Size = size(Target, 1);
MrVec = (0 : Mr - 1).';
b = 2 * pi * dLambda;
CRLB_Vec = zeros(Size, iSNRLen);
for i = 1 : Size
    SinTheta = sin(Target(i, :));
    CosTheta = cos(Target(i, :));
    A = exp(1j * b * MrVec * SinTheta);
    Adot = (1j * b * MrVec * CosTheta) .* A;
    H = Adot' * (eye(Mr) - A * (A' * A) ^ (-1) * A') * Adot;
    for j = 1 : iSNRLen
        R = A * A' + Sigma2(j) * eye(Mr);
        B = Sigma2(j) / (2 * Size) * real(H .* (A' * R ^ (-1) * A).') ^ (-1);
        CRLB_Vec(i, j) = mean(diag(B));
    end
end
RMSE_CRLB_80_2 = rad2deg(mean(sqrt(CRLB_Vec), 1));
% RMSE_CRLB_90 = rad2deg(mean(sqrt(6 * Sigma2 ./ (Size * Mr * (Mr ^ 2 - 1) * b ^ 2 * cos(Target) .^ 2)), 1));
save('RMSE_CRLB_80_2', 'RMSE_CRLB_80_2')
plot(RMSE_CRLB_80_2)