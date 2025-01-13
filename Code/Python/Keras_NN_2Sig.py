##################### ( 2 signals space ) #################################
from keras.models import Sequential
from keras.layers import Dense
from sklearn import metrics
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import scipy.io
import math

SNRdBSave = 0      #"Noisy"#"NoNoise"#
Range = 100
TrainingSize = round(6e4)
NumSignals = 2

Data_Features_Training = "Data_Cov_Features_Training_SNR_" + str(SNRdBSave) + "_Range_100_Size_60000_NumSignals_" + str(NumSignals)
Data_Target_Training = "Data_Cov_Target_Training_SNR_" + str(SNRdBSave) + "_Range_100_Size_60000_NumSignals_" + str(NumSignals)
Data_Features_Testing = "Data_Cov_Features_Testing_SNR_" + str(SNRdBSave) + "_Range_100_Size_10000_NumSignals_" + str(NumSignals)
Data_Target_Testing = "Data_Cov_Target_Testing_SNR_" + str(SNRdBSave) + "_Range_100_Size_10000_NumSignals_" + str(NumSignals)

X1 = pd.read_csv("/content/drive/MyDrive/Colab Notebooks/Training2_10_2/" + Data_Features_Training + ".csv", header = None)
Y1 = pd.read_csv("/content/drive/MyDrive/Colab Notebooks/Training2_10_2/" + Data_Target_Training + ".csv", header = None)
X2 = pd.read_csv("/content/drive/MyDrive/Colab Notebooks/Testing2_10_2/" + Data_Features_Testing + ".csv", header = None)
Y2 = pd.read_csv("/content/drive/MyDrive/Colab Notebooks/Testing2_10_2/" + Data_Target_Testing + ".csv", header = None)

LenX1 = X1.shape
LenY1 = Y1.shape

NumNeurons = [128, 64, 32]
NumLayers = len(NumNeurons)
NumEpochs = 100
BatchSize = 64
model = Sequential()

model.add(Dense(NumNeurons[0], activation = "tanh", input_dim = LenX1[1], kernel_initializer = "uniform"))
model.add(Dense(NumNeurons[1], activation = "tanh", input_dim = NumNeurons[0], kernel_initializer = "uniform"))
model.add(Dense(NumNeurons[2], activation = "tanh", input_dim = NumNeurons[1], kernel_initializer = "uniform"))
model.add(Dense(LenY1[1], activation = "linear", kernel_initializer = "uniform"))
model.compile(loss = 'mse', optimizer = 'adam')
hh = model.fit(X1, Y1, epochs = NumEpochs, batch_size = BatchSize, verbose = 0)
Y1_Predict = model.predict(X1)
Y2_Predict = model.predict(X2)
#############################
scipy.io.savemat('/content/drive/MyDrive/Colab Notebooks/Result_test/' + Data_Target_Testing + "_NumLayers_" + str(NumLayers) + '_Predict.mat', dict(Target_Predict = Y2_Predict))

##############################
print('done!')
######## Evaluation Metrics
#MSE = np.round(metrics.mean_squared_error(Y2*180/math.pi,Y2_Predict*180/math.pi) ,2)
MSE1 = np.round(np.sqrt(np.sum((Y2.iloc[:,0].values - Y2_Predict[:,0])**2)/len(Y2)) *180/math.pi,2)
MSE2 = np.round(np.sqrt(np.sum((Y2.iloc[:,1].values - Y2_Predict[:,1])**2)/len(Y2)) *180/math.pi,2)

r2_sc1 = np.round(metrics.r2_score(Y2.iloc[:,0].values,Y2_Predict[:,0]),2)
r2_sc2 = np.round(metrics.r2_score(Y2.iloc[:,1].values,Y2_Predict[:,1]),2)

print('Mean Squared Error',MSE1)
print('Mean Squared Error',MSE2)

print('r square',r2_sc1)
print('r square',r2_sc2)

##############################
plt.plot(hh.history['loss'])
#plt.plot(hh.history['acc'])
plt.title('Model loss')
plt.ylabel('loss')
plt.xlabel('epoch')
plt.grid()
plt.legend(['loss', 'accuracy'], loc='upper left')
plt.savefig('/content/drive/MyDrive/Colab Notebooks/loss.pdf')
plt.show()

plt.scatter(Y2.iloc[:,0].values*180/math.pi,Y2_Predict[:,0]*180/math.pi)
plt.scatter(Y2.iloc[:,1].values*180/math.pi,Y2_Predict[:,1]*180/math.pi)
plt.title('Prediction')
plt.ylabel('Predict value')
plt.xlabel('Actual value')
plt.grid()
plt.legend(['target 1', 'target 2'], loc='upper left')
plt.savefig('/content/drive/MyDrive/Colab Notebooks/sct.pdf')
plt.show()


#RMSE_vec= [17.47,17.05,16.51,15,37,15.78,15.14,15.1]
#RMSE_vec= [17.47,17.34,16.55,16,23,17.45,15.24,14.35]

#R_sq = [0.83,0.84,0.85,0.87,0.86,0.88,0.88]
#R_sq = [0.83,0.84,0.85,0.85,0.83,0.88,0.88]

 
