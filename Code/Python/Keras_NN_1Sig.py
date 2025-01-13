##################### ( 1 signal space ) #################################
from keras.models import Sequential
from keras.layers import Dense
from sklearn import metrics
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import scipy.io
import math

SNRdBSave = 10      #"Noisy"#"NoNoise"#
Range = 100
TrainingSize = round(6e4)
NumSignals = 1

Data_Features_Training = "Data_Cov_Features_Training_SNR_" + str(SNRdBSave) + "_Range_100_Size_10000_NumSignals_" + str(NumSignals)
Data_Target_Training = "Data_Cov_Target_Training_SNR_" + str(SNRdBSave) + "_Range_100_Size_10000_NumSignals_" + str(NumSignals)
Data_Features_Testing = "Data_Cov_Features_Testing_SNR_" + str(SNRdBSave) + "_Range_100_Size_10000_NumSignals_" + str(NumSignals)
Data_Target_Testing = "Data_Cov_Target_Testing_SNR_" + str(SNRdBSave) + "_Range_100_Size_10000_NumSignals_" + str(NumSignals)

######## dataset for test 
X1 = pd.read_csv("/content/drive/MyDrive/Colab Notebooks/Training_4/" + Data_Features_Training + ".csv", header = None)
Y1 = pd.read_csv("/content/drive/MyDrive/Colab Notebooks/Training_4/" + Data_Target_Training + ".csv", header = None)
X2 = pd.read_csv("/content/drive/MyDrive/Colab Notebooks/Testing_4/" + Data_Features_Testing + ".csv", header = None)
Y2 = pd.read_csv("/content/drive/MyDrive/Colab Notebooks/Testing_4/" + Data_Target_Testing + ".csv", header = None)

######## dataset for rang 100 & 10 element antenna & 60000 training ##############################
#X1 = pd.read_csv("/content/drive/MyDrive/Colab Notebooks/Training_10_rng1_2/" + Data_Features_Training + ".csv", header = None)
#Y1 = pd.read_csv("/content/drive/MyDrive/Colab Notebooks/Training_10_rng1_2/" + Data_Target_Training + ".csv", header = None)
#X2 = pd.read_csv("/content/drive/MyDrive/Colab Notebooks/Testing_10_rng1/" + Data_Features_Testing + ".csv", header = None)
#Y2 = pd.read_csv("/content/drive/MyDrive/Colab Notebooks/Testing_10_rng1/" + Data_Target_Testing + ".csv", header = None)

LenX1 = X1.shape
LenY1 = Y1.shape

NumNeurons = [64, 32]
NumLayers = len(NumNeurons)
NumEpochs = 100
BatchSize = 64
model = Sequential()

model.add(Dense(NumNeurons[0], activation = "tanh", input_dim = LenX1[1], kernel_initializer = "uniform"))
model.add(Dense(NumNeurons[1], activation = "tanh", input_dim = NumNeurons[0], kernel_initializer = "uniform"))
#model.add(Dense(NumNeurons[2], activation = "tanh", input_dim = NumNeurons[1], kernel_initializer = "uniform"))
model.add(Dense(LenY1[1], activation = "linear", kernel_initializer = "uniform"))
model.compile(loss = 'mse', optimizer = 'adam')
hh = model.fit(X1, Y1, epochs = NumEpochs, batch_size = BatchSize, verbose = 0)
Y1_Predict = model.predict(X1)
Y2_Predict = model.predict(X2)
#############################
#scipy.io.savemat('/content/drive/MyDrive/Colab Notebooks/Result_test/' + Data_Target_Testing + "_NumLayers_" + str(NumLayers) + '_Predict.mat', dict(Target_Predict = Y2_Predict))

##############################
print('done!')
######## Evaluation Metrics
#MSE = np.round(metrics.mean_squared_error(Y2*180/math.pi,Y2_Predict*180/math.pi) ,2)
MSE = np.round(np.sqrt(np.sum((Y2 - Y2_Predict)**2)/len(Y2)) *180/math.pi,2)
r2_sc = np.round(metrics.r2_score(Y2,Y2_Predict),2)
print('Mean Squared Error',MSE)
print('r square',r2_sc)
##############################
plt.plot(hh.history['loss'])
#plt.plot(hh.history['acc'])
plt.title('Model loss')
plt.ylabel('loss')
plt.xlabel('epoch')
plt.grid()
plt.legend(['loss', 'accuracy'], loc='upper left')
#plt.savefig('/content/drive/MyDrive/Colab Notebooks/loss_80.pdf')
plt.show()

#plt.scatter(Y1,Y1_Predict)
plt.scatter(Y2*180/math.pi,Y2_Predict*180/math.pi)
plt.title('Prediction')
plt.ylabel('Predict value')
plt.xlabel('Actual value')
plt.grid()
#plt.legend(['train', 'test'], loc='upper left')
#plt.savefig('/content/drive/MyDrive/Colab Notebooks/sct_80.pdf')
plt.show()


#RMSE_vec= [20.31,19.6,17.44,16.81,16.49,14.62]
#90% [1.02,0.98,0.88,0.65,0.57,0.4]
#80% [0.56,0.53,0.56,0.38,0.37,0.4]
# 4element [27.61,25.77, 24.78,23.26,22.55,20.92]


#R_sq = [0.85,0.86,0.89,0.9,0.9,0.92]
#90% [1] 
#4element [0.71,0.75,0.77,0.8,0.81,0.84]