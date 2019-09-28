function mainFittingLCByTwoStageModel1
 

    ex1()  
end

function ex1()   
filename =sprintf('C:\\Users\\ll\\OneDrive\\paper3-code\\NGSIMDataAnalysis\\LCSamples\\OneLC%d.xlsx',2);
   
        [dat,txt,raw]= xlsread(filename);
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
        indT2 = find(mylcFlag ==1)-10;
        
        velX = diff(localX)/0.1;
        velY = diff(localY)/0.1;
        accX = diff(velX)/0.1;
        accY = diff(velY)/0.1;
        
       
        Trajs.localX = localX(indT2:indT2+150)-localX(indT2);
        Trajs.localY = localY(indT2:indT2+150)-localY(indT2);
        veh0.posX = 0;
        veh0.posY = 0;
        veh0.velX = velX(indT2);
        veh0.velY = velY(indT2);
        veh0.accX = accX(indT2);
        veh0.accY = accY(indT2);
%         veh0.velX = 0;
%         veh0.accX = 0;
%         veh0.accY = 0;
     

        
        nonlinfcn = @(x) mycon (x);
        desLateralPos1 = 1;
        latAccParam1_a =0.2;
        latAccParam1_b =1;
        
        desLateralPos2 = 3;
        latAccParam2_a =0.2;
        latAccParam2_b =1;
        action_delay = 0.4;
        lonAccParam1 =0;
       assertTime = 0;
        params.timeStep =0.1;
        params.actDelay =action_delay;
        params.leftOrRightLCFlag = localX(end)>localX(1);
        modelParams = [desLateralPos1 latAccParam1_a latAccParam1_b desLateralPos2  latAccParam2_a latAccParam2_b action_delay lonAccParam1 assertTime ];
        
        A = [];
        b = [];
        Aeq = [];
        beq = [];
        LB = [0.5   0.1   0.5      2     0.1  0.5      0    -0.1     0];
        UB = [2       10  15       4       10   15     4     0.2     3] ;
        fun = @(modelParams) objectFun1(modelParams,Trajs,veh0,params);
        poptions = psoptimset('display','iter');
        modelParams = patternsearch(fun,modelParams,A,b,Aeq,beq,LB,UB,nonlinfcn,poptions);
         modelParams = patternsearch(fun,modelParams,A,b,Aeq,beq,LB,UB,nonlinfcn,poptions);
%         soptions = saoptimset('display','iter')
%         modelParams = simulannealbnd(fun,modelParams,LB,UB,soptions);
%  options = saoptimset('display','iter');
% modelParams = ga(fun,9,[],[],[],[],LB,UB,nonlinfcn,[],options);
        modelParams 
        [rvl,predictX,predictY] = objectFun1(modelParams,Trajs,veh0,params);
        close all;
        figure(101)
        hold on
        plot(Trajs.localX,Trajs.localY,'b')
        plot(predictX,predictY,'r')
        hold off
       
        figure(102)
        hold on
        plot(Trajs.localX,'b')
        plot(predictX,'r')
        hold off
        
        figure(103)
        hold on
        plot(Trajs.localY,'b')
        plot(predictY,'r')
        hold off
end

function [rvl,predictX,predictY] = objectFun1(modeParams,Trajs,veh0,params)
%     modeParams
    desLateralPos1=modeParams(1);
    latAccParam1 =   modeParams(2:3);
    desLateralPos2 = modeParams(4); 
    latAccParam2 = modeParams(5:6);
    action_delay =modeParams(7);
     lonAccParam =modeParams(8);
    assertTime = modeParams(9);
    params.action_delay = action_delay;
    stepNum = length(Trajs.localX);
    predictX = zeros(stepNum,1);
    predictY = zeros(stepNum,1);
    veh = veh0;
    
    if params.leftOrRightLCFlag == 0
         desLateralPos1=-modeParams(1);
         desLateralPos2 =-modeParams(4);
    end
    phase1Time =0;
for i=2:stepNum
       
        
        if abs(veh.posX-veh0.posX)<abs(desLateralPos1)
                desLateralPos =  desLateralPos1;
                control.accX = latAccParam1(1)*(desLateralPos - veh.posX)-latAccParam1(2)*veh.velX;
                control.accY = lonAccParam*veh.velY;
                veh = oneStepSimple1(veh,control,params); 
                predictX(i) = veh.posX;
                predictY(i) = veh.posY; 
                phase1Time = i;
        end
        
        if abs(veh.posX-veh0.posX)>abs(desLateralPos1) 
            
            
            if (i-phase1Time)>assertTime/params.timeStep
                desLateralPos =  desLateralPos2;
                control.accX = latAccParam2(1)*(desLateralPos - veh.posX)-latAccParam2(2)*veh.velX;
                control.accY = lonAccParam*veh.velY;
                veh = oneStepSimple1(veh,control,params); 
                predictX(i) = veh.posX;
                predictY(i) = veh.posY;    
            else%加入判断时间assertTime
                desLateralPos =  desLateralPos1;
                control.accX = latAccParam1(1)*(desLateralPos - veh.posX)-latAccParam1(2)*veh.velX;
                control.accY = lonAccParam*veh.velY;
                veh = oneStepSimple1(veh,control,params); 
            end
        end
end
Xerr = (Trajs.localX - predictX);
Yerr = (Trajs.localY - predictY);
err1 = 20*Xerr.^2+Yerr.^2;
err2 = sqrt(sum(err1));
rvl = err2;
end

function veh = oneStepSimple1(veh,control,params)
timeStep = params.timeStep;
actionDelay = params.actDelay;


veh.posY =veh.posY+veh.velY*timeStep;
veh.posX =veh.posX+veh.velX*timeStep;

beta = timeStep/(timeStep+actionDelay);
accYReal = beta*control.accY+(1-beta)*veh.accY;
accXReal = beta*control.accX+(1-beta)*veh.accX;

veh.velY = max(0,veh.velY+accYReal*timeStep);
veh.velX = veh.velX+accXReal*timeStep;
 
veh.accY = accYReal;
veh.accX = accXReal;

end

function [c,ceq] = mycon(x)
c(1) = 1*x(2)-x(3);
c(2) = 1*x(5)-x(6);
c(3) = x(1)+1- x(4);
ceq = [];

end