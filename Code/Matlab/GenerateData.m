
DataType = 'Training';%'Testing';%
EbN0dB =10; %0 : 2 : 10;%inf;%
iSNRLen = length(EbN0dB);
TextSNR = num2str(EbN0dB);

Range = 0.8; % [1, 0.9, 0.8];
iRangeLen = length(Range);
Size = 6e4; % 6e4;%
Elements = 10; % 4
NumSignals = 1; % 1
CovSampSize = 100;
dLambda = 0.5;  % distance between elements
dLambdaVec = dLambda * (0 : Elements - 1);
disp(['Generating ', DataType, ' Data with ', num2str(Size * iSNRLen), ' Samples'])
TargetAll = zeros(Size * iSNRLen, NumSignals);
FeatureVectorsCovAll = zeros(Size * iSNRLen, nchoosek(Elements, 2) * 2);
RandIndVec = randperm(Size * iSNRLen).';
for iSNR = 1 : iSNRLen
    disp(['SNR: ', num2str(EbN0dB(iSNR)), ' dB'])
    Target = (rand(Size, NumSignals) - 1 / 2) * pi * Range;
    Target = sort(Target, 2);
    TargetAll(Size * (iSNR - 1) + 1 : Size * iSNR, :) = Target;
    
    %%% Covariance Data %%%
    FeatureVectorsCov = zeros(Size, nchoosek(Elements, 2) * 2);
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
        FeatureVectorsCov(i,:) = [real(CovMat(1, 2)), imag(CovMat(1, 2)), real(CovMat(1, 3)), imag(CovMat(1, 3)), real(CovMat(1, 4)), imag(CovMat(1, 4)), ...
            real(CovMat(1, 5)), imag(CovMat(1, 5)), real(CovMat(1, 6)), imag(CovMat(1, 6)), real(CovMat(1, 7)), imag(CovMat(1, 7)),...
            real(CovMat(1, 8)), imag(CovMat(1, 8)), real(CovMat(1, 9)), imag(CovMat(1, 9)), real(CovMat(1, 10)), imag(CovMat(1, 10)),...
            real(CovMat(2, 3)), imag(CovMat(2, 3)), real(CovMat(2, 4)), imag(CovMat(2, 4)),real(CovMat(2, 5)), imag(CovMat(2, 5)),...
            real(CovMat(2, 6)), imag(CovMat(2, 6)), real(CovMat(2, 7)), imag(CovMat(2, 7)),real(CovMat(2, 8)), imag(CovMat(2, 8)),...
            real(CovMat(2, 9)), imag(CovMat(2, 9)), real(CovMat(2, 10)), imag(CovMat(2, 10)),...
            real(CovMat(3, 4)), imag(CovMat(3, 4)),real(CovMat(3, 5)), imag(CovMat(3, 5)),...
            real(CovMat(3, 6)), imag(CovMat(3, 6)), real(CovMat(3, 7)), imag(CovMat(3, 7)),real(CovMat(3, 8)), imag(CovMat(3, 8)),...
            real(CovMat(3, 9)), imag(CovMat(3, 9)), real(CovMat(3, 10)), imag(CovMat(3, 10)),...
            real(CovMat(4, 5)), imag(CovMat(4, 5)),...
            real(CovMat(4, 6)), imag(CovMat(4, 6)), real(CovMat(4, 7)), imag(CovMat(4, 7)),real(CovMat(4, 8)), imag(CovMat(4, 8)),...
            real(CovMat(4, 9)), imag(CovMat(4, 9)), real(CovMat(4, 10)), imag(CovMat(4, 10)),...
            real(CovMat(5, 6)), imag(CovMat(5, 6)), real(CovMat(5, 7)), imag(CovMat(5, 7)),real(CovMat(5, 8)), imag(CovMat(5, 8)),...
            real(CovMat(5, 9)), imag(CovMat(5, 9)), real(CovMat(5, 10)), imag(CovMat(5, 10)),...
            real(CovMat(6, 7)), imag(CovMat(6, 7)),real(CovMat(6, 8)), imag(CovMat(6, 8)),...
            real(CovMat(6, 9)), imag(CovMat(6, 9)), real(CovMat(6, 10)), imag(CovMat(6, 10)),...
            real(CovMat(7, 8)), imag(CovMat(7, 8)),...
            real(CovMat(7, 9)), imag(CovMat(7, 9)), real(CovMat(7, 10)), imag(CovMat(7, 10)),...
            real(CovMat(8, 9)), imag(CovMat(8, 9)), real(CovMat(8, 10)), imag(CovMat(8, 10)),...
            real(CovMat(8, 10)), imag(CovMat(9, 10))];
    end
    FeatureVectorsCovAll(Size * (iSNR - 1) + 1 : Size * iSNR, :) = FeatureVectorsCov;
end
TargetAll = TargetAll(RandIndVec, :);
FeatureVectorsCovAll = FeatureVectorsCovAll(RandIndVec, :);

FileName1 = ['Data_Cov_Target_', DataType, '_SNR_', TextSNR,'_Range_', num2str(Range * 100), '_Size_', num2str(Size), '_NumSignals_', num2str(NumSignals)];
FileName2 = ['Data_Cov_Features_', DataType, '_SNR_', TextSNR,'_Range_', num2str(Range * 100), '_Size_', num2str(Size), '_NumSignals_', num2str(NumSignals)];
csvwrite(['Datasets/', DataType, '_10_rngcmp/', FileName1, '.csv'], TargetAll)
csvwrite(['Datasets/', DataType, '_10_rngcmp/', FileName2, '.csv'], FeatureVectorsCovAll)
save(['Datasets/', DataType, '_10_rngcmp/', FileName1], 'TargetAll')
save(['Datasets/', DataType, '_10_rngcmp/', FileName2], 'FeatureVectorsCovAll')
