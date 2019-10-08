function extractLaneChangeDataIntoCSV(FileName)
clc;
close all;
counter = 0;
LCSamps = [];
for i=1:length(FileName)
% xlsFileName = 'US101-part1.xlsx'
    dat= importdata(FileName{i});

    vehicleID = dat(:,1);
    frameId = dat(:,2);
    localX = dat(:,5)*0.3048;
    localY = dat(:,6)*0.3048;
    vehicleLen = dat(:,9)*0.3048;
    vehicleWid = dat(:,10)*0.3048;
    vehicleTyp = dat(:,11);
    vehicleVel = dat(:,12)*0.3048;
    vehicleAcc = dat(:,13)*0.3048;
    laneID = dat(:,14);
    preVeh = dat(:,15);
    folVeh = dat(:,16);
    spaceDis = dat(:,17)*0.3048;
    headWay = dat(:,18);

    lcInd = zeros(numel(vehicleID ),1);

    for i = 2:numel(vehicleID)
        if laneID(i) ~= laneID(i-1) && vehicleID(i) == vehicleID(i-1) && vehicleTyp(i) >1
            lcInd(i-1) = 1;
        end
    end
    ind = find(lcInd>0);
    vehicleIDList = unique(vehicleID(ind));


    for k=1:length(vehicleIDList)
        vehIDNow = vehicleIDList(k);
        indT = find(vehicleID==vehIDNow);

        counter=counter+1;
        str = sprintf('.\\LCSamples\\LC%d.csv',counter);
        csvwrite(str,dat(indT,:)); 
        LCSamps = [LCSamps;dat(indT,:)];

    end

    
end
csvwrite('.\\LCSamples\\allLCData.csv',LCSamps);
end

