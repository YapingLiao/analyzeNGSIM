%ֻ�ұ��һ�εģ����ұ�������4�����ϣ����ұ��ǰ�й��ɴ����ͣ������Ҳ�й��ɴ�������������ǰ��HEADWAY;������һ��ģ�ͣ�SEQ->ONE
%�ο���https://www.mathworks.com/help/releases/R2019b/deeplearning/examples/classify-sequence-data-using-lstm-networks.html
function  trainLSTM5()

[XTrain,YTrain]=prepareData();
num1 = floor(length(XTrain)/10*5);
num2 = randperm(length(XTrain));
trainList = num2(1:num1);
validList = num2(num1+1:end);
XTrain1= XTrain(trainList);
YTrain1 = YTrain(trainList);
XValidation1= XTrain(validList);
YValidation1 = YTrain(validList);
numFeatures = 4;
numHiddenUnits = 100;
numClasses = 4;
%�ο���https://ww2.mathworks.cn/help/deeplearning/examples/sequence-to-sequence-classification-using-deep-learning.html



layers = [ ...
    sequenceInputLayer(numFeatures)
    bilstmLayer(numHiddenUnits,'OutputMode','last')
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer]

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
%     'MiniBatchSize',64, ...
%     'ValidationData',{XValidation1,YValidation1}, ...
%     'ValidationFrequency',5,'ExecutionEnvironment','cpu','MaxEpochs',300)

options = trainingOptions('adam', ...
    'MaxEpochs',100, ...
    'GradientThreshold',0.05, ...
    'Verbose',0, ...
    'Plots','training-progress',...
    'MiniBatchSize',64, ...
    'ValidationData',{XValidation1,YValidation1}, ...
    'ValidationFrequency',5,'ExecutionEnvironment','cpu',...
    'CheckpointPath','.\CkPts',...
 'Shuffle','every-epoch' ,'L2Regularization',0.01, 'ValidationPatience',500)

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
save ngsimOneLC4TypeSeq2One.mat;
% showRvl2();
end

%%
%%���ļ����ж���׼���õıȽϺõ�һ�γ���ת��������
function [XTrainT,YTrainT]=prepareData()
XTrainT={};
YTrainT =[];
counter = 0;
name{1} = '.\LCSamples\oneLC4Type*.csv';

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
        headWay = min(10,dat(:,18));
         
        meanLocalX = mean(localX(1:30));
        std1 = std(localX(1:30));
        localX1 =  (localX-meanLocalX);
        
        Tmp = diff(localX1)/0.1;  
        Xvel = [Tmp(1);Tmp];
        meanXvel= mean(Xvel(1:30));
        std1 = std(Xvel(1:30));
        Xvel1=(Xvel-meanXvel);
        %%��ȡ3s������
        timeDur = numel(localX);
        
         for j=20:timeDur
            counter= counter+1;
        
            label = dat(j,19);
            YTrainT(counter) =label;
            XTrainT{counter} = [localX1(j-19:j)  Xvel1(j-19:j)  vehicleAcc(j-19:j)  headWay(j-19:j) ]';  
         end
    end
end
YTrainT = categorical(YTrainT');
end


