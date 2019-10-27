%;ֻ�ұ��һ�εģ����ұ�������4�����ϣ�
%���ұ��ǰ�й��ɴ����ͣ�����������ǰ��HEADWAY
%������һ��ģ�ͣ�������תΪ4X19��ͼ��ֻ��3�࣬�����ȷ��
%ע�⣬����ת��������Ϊ
%mean1�Ӽ�0.1*std1��
function  trainLSTM9()

[XTrainT,YTrainT]=prepareData();
for i=1:numel(YTrainT)
    XTrain(:,:,1,i)=XTrainT{i};
end
YTrain= categorical(YTrainT);

num1 = floor(length(YTrain)/10*5);
num2 = randperm(length(YTrain));
num2 = 1:length(YTrain);
trainList = num2(1:num1);
validList = num2(num1+1:end);
XTrain1= XTrain(:,:,:,trainList);
YTrain1 = YTrain(trainList);
XValidation1= XTrain(:,:,:,validList);
YValidation1 = YTrain(validList);


numClasses = 3;
inputSize=[4 19 1];
%�ο���https://ww2.mathworks.cn/help/deeplearning/examples/sequence-to-sequence-classification-using-deep-learning.html



layers = [
    imageInputLayer(inputSize)
    convolution2dLayer(3,20)
    batchNormalizationLayer
    reluLayer
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer];
%�ο���https://ww2.mathworks.cn/help/deeplearning/examples/sequence-to-sequence-classification-using-deep-learning.html



% layers = [ ...
%     sequenceInputLayer(numFeatures)
%     bilstmLayer(numHiddenUnits,'OutputMode','last')
%     fullyConnectedLayer(numClasses)
%     softmaxLayer
%     classificationLayer]
% 
% numHiddenUnits2 = 200;
% numHiddenUnits3 = 50;
% numHiddenUnits4 = 25;
% layers = [ ...
%     sequenceInputLayer(numFeatures)
%     lstmLayer(numHiddenUnits2,'OutputMode','last')
%     dropoutLayer(0.2)
%     lstmLayer(numHiddenUnits3,'OutputMode','last')
%     dropoutLayer(0.2)
%     lstmLayer(numHiddenUnits4,'OutputMode','last')
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
    'MaxEpochs',50, ...
    'GradientThreshold',0.05, ...
    'Verbose',0, ...
    'Plots','training-progress',...
    'ValidationData',{XValidation1,YValidation1}, ...
    'ValidationFrequency',5,'ExecutionEnvironment','cpu',...
    'CheckpointPath','.\CkPts',...
 'Shuffle','every-epoch' ,'L2Regularization',0.01, 'ValidationPatience',50)

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
save ngsimOneLC3TypeSeq2OneImage.mat;
% showRvl2();
end

%%
%%���ļ����ж���׼���õıȽϺõ�һ�γ���ת��������
function [XTrainT,YTrainT]=prepareData()
XTrainT={};
YTrainT =[];
counter = 0;
name{1} = '.\LCSamples\oneLC3Type*.csv';

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
        
         for j=10:timeDur-10
            counter= counter+1;
        
            label = dat(j,19);
            YTrainT(counter) =label;
            XTrainT{counter} = [localX1(j-9:j+9)  Xvel1(j-9:j+9)  vehicleAcc(j-9:j+9)  headWay(j-9:j+9) ]';  
         end
    end
end
YTrainT = categorical(YTrainT');
end


