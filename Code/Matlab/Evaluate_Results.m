DataType = 'Testing';%'Training';%
NumSignals = 1;
if NumSignals == 1
    NumLayers = 2;
elseif NumSignals == 2
    NumLayers = 3;
end
EbN0dB = 0 : 2 : 10;%0;%inf;%
iSNRLen = length(EbN0dB);
% if isinf(EbN0dB)
%     TextSNR = 'NoNoise';
% elseif iSNRLen == 1
%     TextSNR = num2str(EbN0dB);
% else
%     TextSNR = 'Noisy';
% end
Range = 0.8; %1; %[1, 0.9];
iRangeLen = length(Range);
Size = 1e4;%[1e3, 1e4, 1e5];
iSizeLen = length(Size);
RMSE_NN = zeros(1, iSNRLen);
cdf_NN = zeros(10000, iSNRLen);
InputData = 'Cov';%'Rx';%
iFig = 0;
for iSNR = 1 : iSNRLen
    if isinf(EbN0dB)
        TextSNR = 'NoNoise';
    else
        TextSNR = num2str(EbN0dB(iSNR));
    end
    %for iSize = 1 : iSizeLen
        %for iRange = 1 : iRangeLen
            iFig = iFig + 1;
            Data_Target = ['Data_', InputData, '_Target_', DataType, '_SNR_', TextSNR, '_Range_', num2str(Range * 100),'_Size_', num2str(Size), '_NumSignals_', num2str(NumSignals)];
            load(['C:\MyFiles\UCCS_Courses\MachineLearning_SP2021\ML_project\AoA_prediction_withDNN\Code\Matlab\Datasets\Testing_10_300_rng80\', Data_Target, '.mat'])
            load(['C:\MyFiles\UCCS_Courses\MachineLearning_SP2021\ML_project\AoA_prediction_withDNN\Code\Matlab\Results\', Data_Target, '_300_NumLayers_', num2str(NumLayers), '_Predict.mat'])
            if exist('TargetAll', 'var') == 1
                Target = TargetAll;
            end
            aa=rad2deg(sqrt(mean((Target - Target_Predict) .^ 2)));
            cdf_NN(:,iSNR) = rad2deg(((Target - Target_Predict))) ;
            RMSE_NN(iSNR) = mean(aa);
            figure(306)
            subplot(3, 2, iFig)
            plot(rad2deg(Target), rad2deg(Target_Predict), '.')
            if ~isinf(EbN0dB(iSNR))
                TextSNR2 = ['SNR = ', TextSNR, ' dB'];
            else
                TextSNR2 = 'without Noise';
            end
            title({[TextSNR2,]}, 'Interpreter', 'latex')
            xlabel('Actual AoA', 'Interpreter', 'latex')
            ylabel('Predicted AoA', 'Interpreter', 'latex')
            grid on
        %end
    %end
end
%  RMSE_NN_2 = squeeze(RMSE_NN).';
% save('RMSE_NN_Rx100_2', 'RMSE_NN_Rx100_2')
%% RMSE plot ( 1- signal, NN, )

EbN0dB = 0 : 2 : 10;
figure(311);
% clf
% axes311 = axes('Parent', 311);
semilogy(EbN0dB, smooth(RMSE_NN,'lowess'), 'LineWidth', 2)
%  hold on
%  semilogy(EbN0dB, RMSE_NN_2/10, 'LineWidth', 2)

box on
grid on
xlabel('$E_b / N_0 ~[dB]$', 'Interpreter', 'latex')
ylabel('RMSE', 'Interpreter', 'latex')
%legend311 = legend(axes311, 'show');
%set(legend311, 'Location', 'northeast', 'FontSize', 11, 'Interpreter', 'latex')


