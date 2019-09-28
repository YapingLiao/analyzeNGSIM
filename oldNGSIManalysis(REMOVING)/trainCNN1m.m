function trainCNN()

X = [];
Y = [];
for i=1:180
    i
        str = sprintf('.\\LCSamples\\OneLC%d.xlsx',i);
        [dat,txt,raw]= xlsread(str);
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
        mylcFlag = dat(:,19); 
        indT=find(abs(diff(laneID))>0);
        indT2 = find(mylcFlag ==1);
        
        latPosAbsChange = abs(localX - localX(1));
        labVelAbsChange = abs(diff(localX - localX(1))/0.1);
        labVelAbsChange = [labVelAbsChange(1);labVelAbsChange];
        XT = [latPosAbsChange labVelAbsChange vehicleVel vehicleAcc];
        
        YT = zeros(size(latPosAbsChange));
        YT(indT2:end) =1;
        X =[X;XT];
        Y = [Y;YT];
    end
    xlswrite('lcTrainData1.xls',[X Y]);
    save lcTrainData1.mat X Y;
nnstart
end