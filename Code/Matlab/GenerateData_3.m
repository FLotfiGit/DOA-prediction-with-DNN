
DataType = 'Testing';%'Training';%
EbN0dB =0; %0 : 2 : 10;%inf;%
iSNRLen = length(EbN0dB);
TextSNR = num2str(EbN0dB);

Range = 0.8; % [1, 0.9, 0.8];
iRangeLen = length(Range);
Size = 1e4; % 6e4;%
Elements = 10; % 4
NumSignals = 2; % 1
CovSampSize = 100;
dLambda = 0.5;  % distance between elements
dLambdaVec = dLambda * (0 : Elements - 1);
disp(['Generating ', DataType, ' Data with ', num2str(Size * iSNRLen), ' Samples'])
TargetAll = zeros(Size * iSNRLen, NumSignals);
FeatureVectorsCovAll = zeros(Size * iSNRLen, Elements*Elements * 3);
RandIndVec = randperm(Size * iSNRLen).';
for iSNR = 1 : iSNRLen
    disp(['SNR: ', num2str(EbN0dB(iSNR)), ' dB'])
    Target = (rand(Size, NumSignals) - 1 / 2) * pi * Range;
    Target = sort(Target, 2);
    TargetAll(Size * (iSNR - 1) + 1 : Size * iSNR, :) = Target;
    
    %%% Covariance Data %%%
    FeatureVectorsCov = zeros(Size, Elements * Elements * 3);
    for i = 1 : Size
        A = repmat(exp(1j * 2 * pi * sin(Target(i, 1)) * dLambdaVec).', 1, CovSampSize) .* repmat(sign(randn(1, CovSampSize)), Elements, 1);
        for ii = 2 : NumSignals
            A = A + repmat((exp(1j * 2 * pi * sin(Target(i, ii)) * dLambdaVec)).', 1, CovSampSize);
        end
        Features = A + sqrt(1 / 2 / db2pow(EbN0dB(iSNR))) * (randn(Elements, CovSampSize) + 1j * randn(Elements, CovSampSize));
        CovMat = 1 / CovSampSize / Elements * (Features * Features');
        
        %%%%%  ~~~~~~~~~~ for 4 elements ~~~~~~~~~~  %%%%%
        % FeatureVectorsCov(i, :) = [real(CovMat(1, 2)), imag(CovMat(1, 2)), real(CovMat(1, 3)), imag(CovMat(1, 3)), real(CovMat(1, 4)), imag(CovMat(1, 4)), ...
        %     real(CovMat(2, 3)), imag(CovMat(2, 3)), real(CovMat(2, 4)), imag(CovMat(2, 4)), real(CovMat(3, 4)), imag(CovMat(3, 4))];
        %%%%%  ~~~~~~~~~~ for 10 elements ~~~~~~~~~~ %%%%%
        FeatureVectorsCov(i,1:3:end) = real(CovMat(:));
        FeatureVectorsCov(i,2:3:end) = imag(CovMat(:));
        FeatureVectorsCov(i,3:3:end) = angle(CovMat(:));
    end
    FeatureVectorsCovAll(Size * (iSNR - 1) + 1 : Size * iSNR, :) = FeatureVectorsCov;
end
TargetAll = TargetAll(RandIndVec, :);
FeatureVectorsCovAll = FeatureVectorsCovAll(RandIndVec, :);

FileName1 = ['Data_Cov_Target_', DataType, '_SNR_', TextSNR,'_Range_', num2str(Range * 100), '_Size_', num2str(Size), '_NumSignals_', num2str(NumSignals)];
FileName2 = ['Data_Cov_Features_', DataType, '_SNR_', TextSNR,'_Range_', num2str(Range * 100), '_Size_', num2str(Size), '_NumSignals_', num2str(NumSignals)];
csvwrite(['Datasets/', DataType, '_10_300_rng80/', FileName1, '.csv'], TargetAll)
csvwrite(['Datasets/', DataType, '_10_300_rng80/', FileName2, '.csv'], FeatureVectorsCovAll)
save(['Datasets/', DataType, '_10_300_rng80/', FileName1], 'TargetAll')
save(['Datasets/', DataType, '_10_300_rng80/', FileName2], 'FeatureVectorsCovAll')
