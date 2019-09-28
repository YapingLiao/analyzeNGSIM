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
dataFile = 'trajectories-0750am-0805am.txt';
extractLaneChangeDataIntoCSV(dataFile);%把所有存在车道转换的路径给出
end
 findOneLCAndShow1();%只找变道一次的，而且变道后持续4秒以上
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
