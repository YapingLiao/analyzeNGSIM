function  trainLSTM()

[XTrain,YTrain]=prepareData();
num1 = floor(length(XTrain)/10*5);
num2 = randperm(length(XTrain));
trainList = num2(1:num1);
validList = num2(num1+1:end);
XTrain1= XTrain(trainList);
YTrain1 = YTrain(trainList);
XValidation1= XTrain(validList);
YValidation1 = YTrain(validList);
numFeatures = 3;
numHiddenUnits = 600;
numClasses = 2;
%参考：https://ww2.mathworks.cn/help/deeplearning/examples/sequence-to-sequence-classification-using-deep-learning.html

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
    'MaxEpochs',300, ...
    'GradientThreshold',0.1, ...
    'Verbose',0, ...
    'Plots','training-progress',...
    'MiniBatchSize',64, ...
    'ValidationData',{XValidation1,YValidation1}, ...
    'ValidationFrequency',5,'ExecutionEnvironment','cpu')

net = trainNetwork(XTrain1,YTrain1,layers,options);
save ngsimOneLCTwoType.mat;
showRvl();
end

%%
%%从文件夹中读入准备好的比较好的一次车道转换的数据
function [XTrain,YTrain]=prepareData()
XTrain={};
YTrain ={};
counter = 0;
name{1} = '.\LCSamples\oneLC*.csv';
% name{2} = '.\US101-LC-0805am-0820am\oneLC*.csv';
% name{3} = '.\US101-LC-0820am-0835am\oneLC*.csv';
for k=1:1
    nameT = name{k};
    T = dir(nameT);
    for i=1:length(T)
        str=[T(i).folder '\' T(i).name];
        disp(str)
        dat= csvread(str);
        
        localX = dat(:,5)*0.3048;
         vehicleAcc = dat(:,13)*0.3048;
         
        meanLocalX = mean(localX(1:30));
        std1 = std(localX(1:30));
        localX1 =  (localX-meanLocalX)/std1;
        
        Tmp = diff(localX1)/0.1;  
        Xvel = [Tmp(1);Tmp];
        meanXvel= mean(Xvel(1:30));
        std1 = std(Xvel(1:30));
        Xvel1=(Xvel-meanXvel)/std1;
        
        counter= counter+1;
        
         label = dat(:,19);
         YTrain{counter} = categorical(label');
         XTrain{counter} = [localX1 Xvel1 vehicleAcc]';  
    end
end
    
end


%%
%%从文件夹中读入准备好的比较好的一次车道转换的数据
function showRvl()
load ngsimOneLCTwoType.mat
XTest = XTrain1{10};
YTest = YTrain1{10};
XTest = XValidation1{40};
YTest = YValidation1{40};

YPred = classify(net,XTest);
acc = sum(YPred == YTest)./numel(YTest)

figure
plot(YPred,'.-')
hold on
plot(YTest)
hold off

xlabel("Time Step")
ylabel("Activity")
title("Predicted Activities")
legend(["Predicted" "Test Data"])
end