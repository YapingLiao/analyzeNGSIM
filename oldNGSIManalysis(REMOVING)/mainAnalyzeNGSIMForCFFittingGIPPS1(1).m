function mainAnalyzeNGSIMForCFFittingGIPPS1
clc;
close all;
clear all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load myCFinfo.mat
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
timeStep =0.1;
Vn_des = 40/3.6;
an_maxacc = 3;
bn_maxdacc = -8.5;
sn = 4;
tau = 1;
theta = 0.2;
x0 = [Vn_des an_maxacc bn_maxdacc sn tau theta];

A = [];
b = [];
Aeq = [];
beq = [];
LB = [20/3.6 1 -8 3.5   0.7 0];
UB = [60/3.6 4 -3 8.5   2.7 0];
nonlcon =  [];
myfun = @(params) fittingMode2(params,carFollowingTypes1,timeStep,frameId,headWay,spaceDis,vehicleVel,vehicleAcc,localY);


options = saoptimset('Display','iter','MaxIter',100);
[x fval] = simulannealbnd(myfun,x0,LB,UB,options)



options = psoptimset('Display','iter','MaxIter',30,'UseParallel',true);
x0 = x;
[x,fval] = patternsearch(myfun,x0,A,b,Aeq,beq,LB,UB,nonlcon,options)





showResults(x,carFollowingTypes1,timeStep,frameId,headWay,spaceDis,vehicleVel,vehicleAcc,localY);


end

function err =  fittingMode1(params,carFollowingTypes1,timeStep,frameId,headWay,spaceDis,vehicleVel,vehicleAcc,localY)
err = 0;
Vn_des = params(1);
an_maxacc = params(2);
bn_maxdacc = -2*an_maxacc;
b_maxdacc_lead = params(3);
sn = params(4);
tau = params(5);
theta = params(6);

for i = 1:numel(carFollowingTypes1)
    tmp = carFollowingTypes1{i};
    indFollow = tmp(:,1);
    indPre = tmp(:,2);
    ind1 = indFollow;
    timeRange = frameId(ind1)*timeStep;
    headWayCur = headWay(ind1);
    spaceDisCur = spaceDis(ind1);
    vehicleVelCur = vehicleVel(ind1);
    vehicleAccCur = vehicleAcc(ind1);
    
    vehlen = 3.5;
    leadVelCur = vehicleVel(indPre);
    leadAccAcc = vehicleAcc(indPre);
    timeRange2 = frameId(indPre)*timeStep;
    
    offset= round(tau/timeStep);
    for j = offset:length(ind1)
        space = spaceDisCur(j-offset+1);
        speed = vehicleVel(j-offset+1);
        %acc = vehicleAcc(j-offset+1);
        leadSpeed = leadVelCur(j-offset+1);
        
        speedtau =    vehicleVel(j);
        %acctau = vehicleAcc(j);
        
        vfree_tau = speed+2.5* an_maxacc*tau*(1-speed/Vn_des)*sqrt(0.025+speed/Vn_des);
        tmp = bn_maxdacc^2*tau^2-bn_maxdacc*(2*(space+ vehlen-sn)-tau*speed-leadSpeed*leadSpeed/b_maxdacc_lead);
        vsafe_tau = bn_maxdacc*tau+sqrt(tmp);
        v_tau = min(vfree_tau,vsafe_tau);
        % err =err+ abs(v_tau- speedtau)/(length(ind1)-offset);
        err =err+ abs(v_tau- speedtau)/sum(vehicleVelCur);
        
    end
    
end
end



function err =  fittingMode2(params,carFollowingTypes1,timeStep,frameId,headWay,spaceDis,vehicleVel,vehicleAcc,localY)
err = 0;
Vn_des = params(1);
an_maxacc = params(2);
bn_maxdacc = -2*an_maxacc;
b_maxdacc_lead = params(3);
sn = params(4);
tau = params(5);
theta = params(6);

%      for i = 1:numel(carFollowingTypes1)
for i = 1:40
    tmp = carFollowingTypes1{i};
    indFollow = tmp(:,1);
    indPre = tmp(:,2);
    ind1 = indFollow;
    timeRange = frameId(ind1)*timeStep;
    headWayCur = headWay(ind1);
    spaceDisCur = spaceDis(ind1);
    vehicleVelCur = vehicleVel(ind1);
    vehicleAccCur = vehicleAcc(ind1);
    vehYPos = localY(ind1);
    
    vehlen = 3.5;
    leadVelCur = vehicleVel(indPre);
    timeRange2 = frameId(indPre)*timeStep;
    leadYPos = localY(indPre);
    
    %%%%%%%%%%predicting future speed and pos
    offset= round(tau/timeStep);
    vlist = zeros(length(ind1),1);%the object vehicle speed and position
    plist = zeros(length(ind1),1);
    for j = 1:offset
        vlist(j) = vehicleVelCur(j);
        plist(j) = vehYPos(j);
    end
    
    for j = (offset+1):length(ind1)
        speed = vlist(j-offset);
        vPos =plist(j-offset);
        
        leadSpeed = leadVelCur(j-offset);
        leadPos =  leadYPos(j-offset);
        posDiff =leadPos - vPos;
        
        vfree_tau = speed+2.5* an_maxacc*tau*(1-speed/Vn_des)*sqrt(0.025+speed/Vn_des);
        tmp = bn_maxdacc^2*tau^2-bn_maxdacc*(2*(posDiff-sn)-tau*speed-leadSpeed*leadSpeed/b_maxdacc_lead);
        vsafe_tau = bn_maxdacc*tau+sqrt(tmp);
        v_tau = min(vfree_tau,vsafe_tau);
        vlist(j) = v_tau;
        plist(j) = plist(j-1)+vlist(j-1)*timeStep;
    end
    vErr = abs(vlist-vehicleVelCur)/length(ind1);
    pErr =  abs(plist -vehYPos)/length(ind1);
    err = err+sum(vErr)+sum(pErr);
    
end
end

function showResults(params,carFollowingTypes1,timeStep,frameId,headWay,spaceDis,vehicleVel,vehicleAcc,localY)
Vn_des = params(1);
an_maxacc = params(2);
bn_maxdacc = -2*an_maxacc;
b_maxdacc_lead = params(3);
sn = params(4);
tau = params(5);
theta = params(6);

for i = 7
    tmp = carFollowingTypes1{i};
    indFollow = tmp(:,1);
    indPre = tmp(:,2);
    ind1 = indFollow;
    timeRange = frameId(ind1)*timeStep;
    headWayCur = headWay(ind1);
    spaceDisCur = spaceDis(ind1);
    vehicleVelCur = vehicleVel(ind1);
    vehicleAccCur = vehicleAcc(ind1);
    vehYPos = localY(ind1);
    
    vehlen = 3.5;
    leadVelCur = vehicleVel(indPre);
    timeRange2 = frameId(indPre)*timeStep;
    leadYPos = localY(indPre);
    
    %%%%%%%%%%predicting future speed and pos
    offset= round(tau/timeStep);
    vlist = zeros(length(ind1),1);%the object vehicle speed and position
    plist = zeros(length(ind1),1);
    for j = 1:offset
        vlist(j) = vehicleVelCur(j);
        plist(j) = vehYPos(j);
    end
    
    for j = (offset+1):length(ind1)
        speed = vlist(j-offset);
        vPos =plist(j-offset);
        
        leadSpeed = leadVelCur(j-offset);
        leadPos =  leadYPos(j-offset);
        posDiff =leadPos - vPos;
        
        vfree_tau = speed+2.5* an_maxacc*tau*(1-speed/Vn_des)*sqrt(0.025+speed/Vn_des);
        tmp = bn_maxdacc^2*tau^2-bn_maxdacc*(2*(posDiff-sn)-tau*speed-leadSpeed*leadSpeed/b_maxdacc_lead);
        vsafe_tau = bn_maxdacc*tau+sqrt(tmp);
        v_tau = min(vfree_tau,vsafe_tau);
        vlist(j) = v_tau;
        plist(j) = plist(j-1)+vlist(j-1)*timeStep;
    end
    
    
end

figure
plot(1:length(ind1),[vlist vehicleVelCur]');
title('vlist,vehicleVelCur')
figure
plot(1:length(ind1),[plist vehYPos]');
title('plist vehYPos')


figure
plot(1:length(ind1),[plist-vehYPos]');
title('plist-vehYPos')


errP =  plist-vehYPos;
errV = vlist-vehicleVelCur;

fprintf('mean and std position,%.2f,%.2f\n',mean(errP),std(errP))
fprintf('mean and std velocity,%.2f,%.2f\n',mean(errV),std(errV))

prob = pdf('norm',errV,mean(errV),std(errV));
figure,plot(prob);

end
