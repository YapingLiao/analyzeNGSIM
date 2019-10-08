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

lcInd = zeros(numel(vehicleID ),1);

for i = 2:numel(vehicleID)
    if laneID(i) ~= laneID(i-1) && vehicleID(i) == vehicleID(i-1) && vehicleTyp(i) >1 &&    folVeh(i)>0   
        lcInd(i-1) = 1;
    end       
    
end
ind = find(lcInd>0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for kk=18:length(ind)
choose = kk;
samps = [(ind(choose)-30):(ind(choose)+20)]';%lane change last with 5 seconds ,with relative indexs
indtmp = vehicleID(samps) == vehicleID(ind(choose));%just the same vehicle
samps= samps(indtmp);

[vehicleID(samps) vehicleVel(samps) vehicleAcc(samps) frameId(samps) folVeh(samps) laneID(samps)]


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
timeRange = [min(frameId(samps));max(frameId(samps))];%find the following car index and something
indNoZero = folVeh(samps)>0;
tmp1 = folVeh(samps);
tmp2 = tmp1(indNoZero);
folVehID = tmp2(1);

tmp= [ind(choose)-30:ind(choose)-2];
tmp3 = unique(folVeh(tmp));
if numel(tmp3) >1
    msgbox('跟车车辆出现车道转换');    
end


ind2 = (vehicleID == folVehID) & (vehicleTyp >1) & frameId>timeRange(1) & frameId<timeRange(end);%find the following car index and somethings,including the index after lane change

figure(1001)
subplot(1,2,1)
hold on
plot(frameId(samps)/10,vehicleVel(samps),'r.-');
plot(frameId(ind2)/10,vehicleVel(ind2),'bx-');
hold off
str = '本车速度和跟车速度,车ID：';
t1 = vehicleID(samps(1));
str2 = num2str(t1);
str = strcat(str,str2);
title(str);

subplot(1,2,2)
hold on
plot(localX(samps),localY(samps),'r.-');
plot(localX(ind2),localY(ind2),'bx-');
hold off
xlim([0 50])
str = '本车位置和跟车位置,车道转换和headway：';
t1 = laneID(samps);
str2 = num2str([t1(1) t1(end)]);
str = strcat(str,str2);
title(str);
figure(1002)
plot(headWay(ind2));
title('headway')
pause;

close all;
end

end