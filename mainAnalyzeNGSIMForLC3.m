function mainAnalyzeNGSIMForLC3
clc;
close all;
clear all;
ex1();%单次车道转换，不涉及前后车
%ex2();%单次车道转换，涉及临近车道后车
end

%%
function ex1()
%单次车道转换，不涉及前后车
csvDataIsOk = 1;
if csvDataIsOk ==0
dataFile{1} = 'trajectories-0750am-0805am.txt';
dataFile{2} = 'trajectories-0805am-0820am.txt';
dataFile{3} = 'trajectories-0820am-0835am.txt';

extractLaneChangeDataIntoCSV(dataFile);%把所有存在车道转换的路径给出
end

if 0
 name = '.\\LCSamples\\LC*.csv';
 findOneLCAndShow1(name);%只找变道一次的，而且变道后持续4秒以上
  trainLSTM1();%只训练变道1次的
end

if 0
 name = '.\\LCSamples\\LC*.csv';
 findTwoLCAndShow1(name);%只找变道二次的，而且变道后持续4秒以上。%暂时无比较好的方法和思路分析
end

if 0
 name = '.\\LCSamples\\LC*.csv';
 findOneLCAndShow2(name);%只找变道一次的，而且变道后持续4秒以上，而且变道前有过渡带类型
 trainLSTM2();%只训练变道1次的
end


if 0
 name = '.\\LCSamples\\LC*.csv';
 findOneLCAndShow3(name);%只找变道一次的，而且变道后持续4秒以上，而且变道前有过渡带类型，变道后也有过渡带
 trainLSTM3();%只训练变道1次的
end
 %神经网络：https://blog.csdn.net/weixin_43575157/article/details/83617949
 
if 0
 name = '.\\LCSamples\\LC*.csv';
 findOneLCAndShow4(name);%只找变道一次的，而且变道后持续4秒以上，而且变道前有过渡带类型，变道后也有过渡带，并且增加与前车距离
 trainLSTM4();%只训练变道1次的
end

if 0
 name = '.\\LCSamples\\LC*.csv';
 findOneLCAndShow5(name);%只找变道一次的，而且变道后持续4秒以上，而且变道前有过渡带类型，变道后也有过渡带，并且增加与前车距离,用另外一个模型，SEQ->ONE
 trainLSTM5();%只训练变道1次的
end

if 0
 name = '.\\LCSamples\\LC*.csv';
 findOneLCAndShow6(name);%只找变道一次的，而且变道后持续4秒以上，而且变道前有过渡带类型，并且增加与前车距离,用另外一个模型，SEQ->ONE
 trainLSTM6();%只训练变道1次的
end

if 0
 name = '.\\LCSamples\\LC*.csv';
 findOneLCAndShow7(name);%只找变道一次的，而且变道后持续4秒以上，而且变道前有过渡带类型，并且增加与前车距离,用另外一个模型，SEQ->ONE
 trainLSTM7();%只训练变道1次的
end

if 1
 name = '.\\LCSamples\\LC*.csv';
 findOneLCAndShow8(name);%只找变道一次的，而且变道后持续4秒以上，而且变道前有过渡带类型，并且增加与前车距离,用另外一个模型，SEQ->ONE
  trainLSTM8();%只训练变道1次的
end
end



%%
function ex2()
%单次车道转换，涉及临近车道后车

xlsFileName = 'US101-part1.xlsx';
extractLaneChangeDataIntoXLS2(xlsFileName);
% processData();
% processData2();
% showData();
% trainCNN();
end

function showData()

for i=1:180
        str = sprintf('.\\LCSamples\\OneLC%d.xlsx',i);
        [dat,txt,raw]= xlsread(str);
%         vehicleID = dat(:,1);
%         frameId = dat(:,2);
        localX = dat(:,5)*0.3048;
        localY = dat(:,6)*0.3048;
%         vehicleLen = dat(:,9)*0.3048;
%         vehicleWid = dat(:,10)*0.3048;
%         vehicleTyp = dat(:,11);
        vehicleVel = dat(:,12)*0.3048;
%         vehicleAcc = dat(:,13)*0.3048;
        laneID = dat(:,14);
%         preVeh = dat(:,15);
%         folVeh = dat(:,16);
%         spaceDis = dat(:,17)*0.3048;
%         headWay = dat(:,18);
        mylcFlag = dat(:,19);
        
        
        indT=find(abs(diff(laneID))>0);
        indT2 = find(mylcFlag ==1);
        clf
        
       pause
    end
end
