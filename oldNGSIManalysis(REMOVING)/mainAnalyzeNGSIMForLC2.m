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
    if laneID(i) ~= laneID(i-1) && vehicleID(i) == vehicleID(i-1) && vehicleTyp(i) >1 
        lcInd(i-1) = 1;
    end       
    
end
ind = find(lcInd>0);
vehicleIDList = unique(vehicleID);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for kk=1:length(vehicleIDList)
    
  indTemp =  find(vehicleID == vehicleIDList(kk) );
  laneIDForThisVeh = lcInd(indTemp);
  laneChangeNums = sum(laneIDForThisVeh);
  
  if laneChangeNums>2
      showTrajAndSpeed(indTemp,localX,localY,vehicleAcc,vehicleVel);
      pause;
  end
  

end


end



function showTrajAndSpeed(ind,localX,localY,vehicleAcc,vehicleVel)

figure(101)
plot(localX(ind),localY(ind)-localY(ind(1)),'b.-');
figure(102)
subplot(2,1,1);
plot(vehicleVel(ind),'b.-');
subplot(2,1,2);
plot(vehicleAcc(ind),'b.-');

end