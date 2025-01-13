%% Load 1-Signal Data
% load('SavedRMSE\RMSE_CRLB_90.mat')
% load('SavedRMSE\RMSE_CRLB_100.mat')
% load('SavedRMSE\RMSE_MUSIC_90.mat')
% load('SavedRMSE\RMSE_MUSIC_100.mat')
% load('SavedRMSE\RMSE_NN_Cov90.mat')
% load('SavedRMSE\RMSE_NN_Cov100.mat')
% load('SavedRMSE\RMSE_NN_Rx90.mat')
% load('SavedRMSE\RMSE_NN_Rx100.mat')
%% Load 2-Signal Data
load('RMSE_CRLB_80_2.mat')
% load('SavedRMSE\RMSE_CRLB_90_2.mat')
% load('SavedRMSE\RMSE_CRLB_100_2.mat')
load('RMSE_MUSIC_80_2.mat')
% load('SavedRMSE\RMSE_MUSIC_90_2.mat')
% load('SavedRMSE\RMSE_MUSIC_100_2.mat')
% load('SavedRMSE\RMSE_NN_Cov80_2.mat')
% load('SavedRMSE\RMSE_NN_Cov90_2.mat')
% load('SavedRMSE\RMSE_NN_Cov100_2.mat')
load('RMSE_NN_Rx80_2.mat')
% load('SavedRMSE\RMSE_NN_Rx90_2.mat')
% load('SavedRMSE\RMSE_NN_Rx100_2.mat')
%% Plots
EbN0dB = 0 : 2 : 10;
%{
h = figure(311);
clf
axes311 = axes('Parent', 311);
semilogy(EbN0dB, RMSE_CRLB_90, 'LineWidth', 2)
hold on
box on
grid on
semilogy(EbN0dB, RMSE_MUSIC_90, 'LineWidth', 2, 'LineStyle', '--')
semilogy(EbN0dB, RMSE_NN_Cov90, 'LineWidth', 2, 'LineStyle', ':')
semilogy(EbN0dB, RMSE_NN_Rx90, 'LineWidth', 2, 'LineStyle', '-.')
title('Comparison of different DOA techniques with CRLB (Range = $90\%$ and 1 signal)', 'Interpreter', 'latex')
xlabel('$E_b / N_0 ~[dB]$', 'Interpreter', 'latex')
ylabel('RMSE', 'Interpreter', 'latex')
legend('CRLB', 'MUSIC', 'DNN, Cov', 'DNN, Rx')
legend311 = legend(axes311, 'show');
set(legend311, 'Location', 'northeast', 'FontSize', 11, 'Interpreter', 'latex')
savefig(h, 'P3_06_RMSE90')
saveas(h, 'P3_06_RMSE90', 'epsc')

h = figure(312);
clf
axes312 = axes('Parent', 312);
semilogy(EbN0dB, RMSE_CRLB_100, 'LineWidth', 2)
hold on
box on
grid on
semilogy(EbN0dB, RMSE_MUSIC_100, 'LineWidth', 2, 'LineStyle', '--')
semilogy(EbN0dB, RMSE_NN_Cov100, 'LineWidth', 2, 'LineStyle', ':')
semilogy(EbN0dB, RMSE_NN_Rx100, 'LineWidth', 2, 'LineStyle', '-.')
title('Comparison of different DOA techniques with CRLB (Range = $100\%$ and 1 signal)', 'Interpreter', 'latex')
xlabel('$E_b / N_0 ~[dB]$', 'Interpreter', 'latex')
ylabel('RMSE', 'Interpreter', 'latex')
legend('CRLB', 'MUSIC', 'DNN, Cov', 'DNN, Rx')
legend312 = legend(axes312, 'show');
set(legend312, 'Location', 'northeast', 'FontSize', 11, 'Interpreter', 'latex')
savefig(h, 'P3_07_RMSE100')
saveas(h, 'P3_07_RMSE100', 'epsc')
%}
h = figure(313);
clf
axes313 = axes('Parent', 313);
semilogy(EbN0dB, RMSE_CRLB_80_2, 'LineWidth', 2)
hold on
box on
grid on
semilogy(EbN0dB, RMSE_MUSIC_80_2./2, 'LineWidth', 2, 'LineStyle', '--')
%semilogy(EbN0dB, RMSE_NN_Cov80_2, 'LineWidth', 2, 'LineStyle', ':')
semilogy(EbN0dB, RMSE_NN_Rx80_2, 'LineWidth', 2, 'LineStyle', '-.')
% title('Comparison of different DOA techniques with CRLB (Range = $80\%$ and 2 signals)', 'Interpreter', 'latex')
xlabel('$E_b / N_0 ~[dB]$', 'Interpreter', 'latex')
ylabel('RMSE', 'Interpreter', 'latex')
legend('CRLB', 'MUSIC', 'DNN') %, 'DNN, Rx')
legend313 = legend(axes313, 'show');
set(legend313, 'Location', 'northeast', 'FontSize', 11, 'Interpreter', 'latex')

%{
h = figure(314);
clf
axes314 = axes('Parent', 314);
semilogy(EbN0dB, RMSE_CRLB_90_2, 'LineWidth', 2)
hold on
box on
grid on
semilogy(EbN0dB, RMSE_MUSIC_90_2, 'LineWidth', 2, 'LineStyle', '--')
semilogy(EbN0dB, RMSE_NN_Cov90_2, 'LineWidth', 2, 'LineStyle', ':')
semilogy(EbN0dB, RMSE_NN_Rx90_2, 'LineWidth', 2, 'LineStyle', '-.')
title('Comparison of different DOA techniques with CRLB (Range = $90\%$ and 2 signals)', 'Interpreter', 'latex')
xlabel('$E_b / N_0 ~[dB]$', 'Interpreter', 'latex')
ylabel('RMSE', 'Interpreter', 'latex')
legend('CRLB', 'MUSIC', 'DNN, Cov', 'DNN, Rx')
legend314 = legend(axes314, 'show');
set(legend314, 'Location', 'northeast', 'FontSize', 11, 'Interpreter', 'latex')
savefig(h, 'P3_15_RMSE90_2')
saveas(h, 'P3_15_RMSE90_2', 'epsc')

h = figure(315);
clf
axes315 = axes('Parent', 315);
semilogy(EbN0dB, RMSE_CRLB_100_2, 'LineWidth', 2)
hold on
box on
grid on
semilogy(EbN0dB, RMSE_MUSIC_100_2, 'LineWidth', 2, 'LineStyle', '--')
semilogy(EbN0dB, RMSE_NN_Cov100_2, 'LineWidth', 2, 'LineStyle', ':')
semilogy(EbN0dB, RMSE_NN_Rx100_2, 'LineWidth', 2, 'LineStyle', '-.')
title('Comparison of different DOA techniques with CRLB (Range = $100\%$ and 2 signals)', 'Interpreter', 'latex')
xlabel('$E_b / N_0 ~[dB]$', 'Interpreter', 'latex')
ylabel('RMSE', 'Interpreter', 'latex')
legend('CRLB', 'MUSIC', 'DNN, Cov', 'DNN, Rx')
legend315 = legend(axes315, 'show');
set(legend315, 'Location', 'northeast', 'FontSize', 11, 'Interpreter', 'latex')
savefig(h, 'P3_16_RMSE100_2')
saveas(h, 'P3_16_RMSE100_2', 'epsc')
%}