%;%ֻ�ұ��һ�εģ����ұ�������4�����ϣ����ұ��ǰ�й��ɴ����ͣ�����������ǰ��HEADWAY;������һ��ģ�ͣ�SEQ->Seq��ֻ��4�࣬�����ȷ�ʡ�ע�⣬����ת��������Ϊ
%mean1�Ӽ�0.1*std1����ǰ��,�Լ���4��Ϊ�쳣�࣬����HEADWAY����㣬������lc2lk�ı任��
function  trainLSTM8()

[XTrain,YTrain]=prepareData();
num1 = floor(length(XTrain)/10*5);
num2 = randperm(length(XTrain));%����RAND
num2 = 1:length(XTrain);
trainList = num2(1:num1);
validList = num2(num1+1:end);
XTrain1= XTrain(trainList);
YTrain1 = YTrain(trainList);
XValidation1= XTrain(validList);
YValidation1 = YTrain(validList);
numFeatures = 4;
numHiddenUnits = 50;
numClasses = 4;
%�ο���https://ww2.mathworks.cn/help/deeplearning/examples/sequence-to-sequence-classification-using-deep-learning.html

% layers = [ ...
%     sequenceInputLayer(numFeatures)
%     lstmLayer(numHiddenUnits,'OutputMode','sequence')
%     dropoutLayer(0.2)
%     lstmLayer(numHiddenUnits,'OutputMode','sequence')
%     fullyConnectedLayer(numClasses)
%     softmaxLayer
%     classificationLayer];

layers = [ ...
    sequenceInputLayer(numFeatures)
     lstmLayer(numHiddenUnits,'OutputMode','sequence')
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer];
% 
% numHiddenUnits2 = 200;
% numHiddenUnits3 = 50;
% numHiddenUnits4 = 25;
% layers = [ ...
%     sequenceInputLayer(numFeatures)
%     lstmLayer(numHiddenUnits2,'OutputMode','sequence')
%     dropoutLayer(0.2)
%     lstmLayer(numHiddenUnits3,'OutputMode','sequence')
%     dropoutLayer(0.2)
%     lstmLayer(numHiddenUnits4,'OutputMode','sequence')
%     dropoutLayer(0.2)
%     fullyConnectedLayer(numClasses)
%     softmaxLayer
%     classificationLayer];

% options = trainingOptions('sgdm', ...
%     'LearnRateSchedule','piecewise', ...
%     'LearnRateDropFactor',0.2, ...
%     'LearnRateDropPeriod',5, ...
%     'Verbose',0, ...
%     'Plots','training-progress',...
%     'ExecutionEnvironment','cpu','MaxEpochs',300);

% options = trainingOptions('adam', ...
%     'MaxEpochs',200, ...
%     'GradientThreshold',0.05, ...
%     'Verbose',0, ...
%     'Plots','training-progress',...
%     'MiniBatchSize',64, ...
%     'ValidationData',{XValidation1,YValidation1}, ...
%     'ValidationFrequency',5,'ExecutionEnvironment','cpu',...
%     'CheckpointPath','.\CkPts',...
%  'Shuffle','every-epoch' ,'L2Regularization',0.01, 'ValidationPatience',500)
% 
% options = trainingOptions('adam', ...
%     'MaxEpochs',60, ...
%     'GradientThreshold',2, ...
%     'Verbose',0, ...
%     'Plots','training-progress');%good

options = trainingOptions('adam', ...
    'MaxEpochs',200, ...
    'MiniBatchSize',8, ...
    'GradientThreshold',0.2, ...
    'ValidationData',{XValidation1,YValidation1}, ...
    'ValidationFrequency',50,'ExecutionEnvironment','cpu',...
    'Verbose',0, ...
    'Plots','training-progress');%good

% options = trainingOptions('adam', ...
%     'MaxEpochs',250, ...
%     'GradientThreshold',1, ...
%     'InitialLearnRate',0.005, ...
%     'LearnRateSchedule','piecewise', ...
%     'LearnRateDropPeriod',125, ...
%     'LearnRateDropFactor',0.2, ...
%     'Verbose',0, ...
%     'Plots','training-progress');
net = trainNetwork(XTrain1,YTrain1,layers,options);
save ngsimOneLC4Type.mat;
% showRvl();
end

%%
%%���ļ����ж���׼���õıȽϺõ�һ�γ���ת��������
function [XTrain,YTrain]=prepareData()
XTrainT={};
YTrainT ={};
counter = 0;
name{1} = '.\LCSamples\oneLC4Type*.csv';
%%
%%�������

for k=1:1
    nameT = name{k};
    T = dir(nameT);
    for i=1:length(T)
        str=[T(i).folder '\' T(i).name];
        disp(str)
        dat= csvread(str);
        
        localX = dat(:,5)*0.3048;
         vehicleAcc = dat(:,13)*0.3048;
         
         spaceDis = dat(:,17)*0.3048;
         TMP =diff(spaceDis)/0.1;
         spaceDisVel =[TMP(1);TMP];
        headWay = dat(:,18);
         
        meanLocalX = mean(localX(1:30));
        std1 = std(localX(1:30));
        localX1 =  (localX-meanLocalX);
        
        Tmp = diff(localX1)/0.1;  
        Xvel = [Tmp(1);Tmp];
        meanXvel= mean(Xvel(1:30));
        std1 = std(Xvel(1:30));
        Xvel1=(Xvel-meanXvel);
        
        counter= counter+1;
%         https://www.mathworks.com/help/releases/R2019b/deeplearning/examples/sequence-to-sequence-classification-using-deep-learning.html
         label = dat(:,19);
         labelT=strings(numel(label),1);
         ind = label==0;
         labelT(ind,:)='lk';
          ind = label==1;
         labelT(ind,:)='lc';
          ind = label==2;
         labelT(ind,:)='lk2lc';
          ind = label==3;
         labelT(ind,:)='abnorm';
         
         YTrainT{counter,1} = categorical(labelT');
         XTrainT{counter,1} = [localX1 Xvel1 vehicleAcc headWay ]';  
        
    end
end
YTrain = YTrainT;
XTrain = XTrainT;
end



