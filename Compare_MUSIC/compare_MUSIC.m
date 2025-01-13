NumSignals = 2;
EbN0dB = 0 : 2: 10;
LenSNR = length(EbN0dB);
Range = .8;
Size = 1e3;
Target = (rand(Size, NumSignals) - 1 / 2) * pi * Range;
Target = sort(Target, 2);
TargetEst = zeros(Size, NumSignals, LenSNR);
j = 0;
for i = 1 : Size
    if mod(i, 100) == 0
        disp([num2str(i), ' out of ', num2str(Size)])
    end
    for SNR = EbN0dB
        j = j + 1;
        AoA = Target(i, :).';
        AoA_Est = MyMUSIC(AoA, SNR);
        TargetEst(i, :, j) = sort(AoA_Est);
    end
    j = 0;
end
RMSE_MUSIC_80_2 = squeeze(rad2deg(sqrt(sum((repmat(Target, 1, 1, LenSNR) - TargetEst) .^ 2, [1, 2]) / (Size * NumSignals)))).';
save('RMSE_MUSIC_80_2', 'RMSE_MUSIC_80_2')
plot(RMSE_MUSIC_80_2)
