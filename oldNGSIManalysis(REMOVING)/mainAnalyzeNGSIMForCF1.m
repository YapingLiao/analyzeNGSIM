function mainAnalyzeNGSIM1
clc;
close all;
clear all;

[dat,txt,raw]= xlsread('G:\NGSIMData\US101_A1.xls');

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

vehicleIDList = unique(vehicleID);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure
% hist(vehicleAcc)
% figure
% tmp =  diff(vehicleVel,5)/0.4;
% ind1= tmp<-4;
% ind2 =  tmp>4;
% tmp(ind1) = -4;
% tmp(ind2) = 4;
% hist(tmp);
% 
% return;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
carFollowingTypes1 = {};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:numel(vehicleIDList)
    id = vehicleIDList(i);
    ind1 = find(vehicleID == id & vehicleTyp >1 & vehicleVel >10/3.6 );
    
    laneIDList = unique(laneID(ind1));
    preVehList =  unique(preVeh(ind1));
    if numel(laneIDList)>1 && numel(preVehList)>1 %don not lane change,leading vehicle dont change
        continue;
    end
    
    %     if preVeh(ind1(1)) == 0  &&  folVeh(ind1(1)) == 0%no leading vehicle and following vehicle
    %         continue;
    %     end
    %
    %
    %    if preVeh(ind1(1)) == 0  &&  folVeh(ind1(1)) == 1%no leading vehicle and following car exist
    %         continue;
    %    end
    
    if length(ind1) >0 && preVeh(ind1(1))>0  %having leading vehicle
        timeRange = frameId(ind1)/10;
        headWayCur = headWay(ind1);
        spaceDisCur = spaceDis(ind1);
        vehicleVelCur = vehicleVel(ind1);
        vehicleAccCur = vehicleAcc(ind1);
        tmp = numel(carFollowingTypes1);
        carFollowingTypes1{tmp+1} = ind1;
        continue;
        figure(1)
        subplot(2,1,1);
        plot(timeRange,vehicleVelCur);
        title('Velocity');
        subplot(2,1,2);
        plot(timeRange, vehicleAccCur);
        title('Acc');
%         subplot(3,1,3);
%         tmp = diff(vehicleAccCur,3)/0.3;
%         plot(timeRange,  [tmp;tmp(end);tmp(end);tmp(end)]);
%         title('diffVelo');
        
          figure(2)
        subplot(2,1,1);
        plot(timeRange,headWayCur);
        title('TimeHeadWay');
        
        subplot(2,1,2);
        plot(timeRange,spaceDisCur);
        title('spaceDisCur');
        
        
        pause;
    end
end
save myCFinfo.mat carFollowingTypes1;
numel(carFollowingTypes1)

allAcc= [];
allHeadway = [];
allSpaceDis = [];
allSpeed = [];

for i =1:numel(carFollowingTypes1)
 ind = carFollowingTypes1{i};
 allAcc =   [allAcc; vehicleAcc(ind)];
 allHeadway =   [allHeadway; headWay(ind)];
 allSpaceDis = [allSpaceDis;spaceDis(ind)];
 allSpeed = [allSpeed;vehicleVel(ind)]; 
end

cfdata = [allAcc allHeadway allSpaceDis allSpeed];
xlswrite('cfdaa.xls',cfdata)
