%车道转换时获得周围车的状态
function processData2()
    counter = 0;
    xlsFileName = 'US101-part1.xlsx'
    [datAll,txt,raw]= xlsread(xlsFileName);
    vehicleIDAll = datAll(:,1);
    frameIdAll = datAll(:,2);
    laneIDAll = datAll(:,14);
    localXAll = datAll(:,5)*0.3048;
    localYAll = datAll(:,6)*0.3048;
    for i=180:180
        i
        str = sprintf('.\\LCSamples\\OneLC%d.csv',i);
        dat= csvread(str);
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
        mLCFlag = dat(:,19);
        ind = find(mLCFlag == 1);
        ind2=find(abs(diff(laneID))>0);
        destLane = laneID(end);
        oriLane = laneID(1);
        adjLaneFolvehLC = folVeh(ind2+1);
        adjLaneFronVehLC = preVeh(ind2+1);
     
        oriLaneFolVehLC = folVeh(ind2);
        oriLaneFrontVehLC = preVeh(ind2);
        
        [traj,indTraj1]= getTrajsLC(adjLaneFolvehLC ,destLane,frameId,ind2,datAll);
        trajs{1} = traj;
        [traj,indTraj2]= getTrajsLC( adjLaneFronVehLC ,destLane,frameId,ind2,datAll);
        trajs{2} = traj;
        [traj,indTraj3]= getTrajsLC(oriLaneFolVehLC,oriLane,frameId,ind2,datAll);
        trajs{3} = traj;
        [traj,indTraj4]= getTrajsLC( oriLaneFrontVehLC ,oriLane,frameId,ind2,datAll);  
        trajs{4} = traj;
         
        trajs{5} = [localX,localY, frameId];
        frameIDLC = checkLCFinishPoint(trajs);
        lcVehicleID =  vehicleID(1);
        lcInd1 = ind;
        lcInd2 = ind2;
%         ind2=find(abs(diff(laneID))>0);
        datName = str;
        str1 = sprintf('.\\LCSamples\\lcTrajs%d.mat',i);
        save(str1, 'trajs', 'adjLaneFolvehLC','adjLaneFronVehLC', 'oriLaneFolVehLC', 'oriLaneFrontVehLC','lcVehicleID','datName','lcInd1','lcInd2','vehicleVel','frameIDLC');
%         save TrajDat.mat trajs;
%         showTrajs()
%         close all;
        
        
    end
end

function [traj,indTraj]= getTrajsLC(vehID,destLane,frameId,lcIND,datAll)
           
        if vehID<=0
            traj = [];
            indTraj =[];
            return;
        end
        vehicleIDAll = datAll(:,1);
        frameIdAll = datAll(:,2);
        laneIDAll = datAll(:,14);
        localXAll = datAll(:,5)*0.3048;
        localYAll = datAll(:,6)*0.3048;
    
        tmpInd1 =  laneIDAll == destLane;
%         tmpInd2 =  frameIdAll>frameId(1) & frameIdAll<frameId(lcIND+50);
        tmpInd2 =  frameIdAll>frameId(1) & frameIdAll<frameId(end);

        tmpInd3 =vehicleIDAll==vehID;
        indTraj = tmpInd1&tmpInd2&tmpInd3;
        localYTmp =  localYAll( tmpInd1&tmpInd2&tmpInd3 );
        localXTmp =  localXAll( tmpInd1&tmpInd2&tmpInd3 );
        frameIdTmp =  frameIdAll( tmpInd1&tmpInd2&tmpInd3 );
        traj =[localXTmp localYTmp  frameIdTmp];

end

function showTrajs()

load  TrajDat.mat
names{1} = ['adjLaneFolvehLC'];
names{2}= ['adjLaneFronVehLC'];
names{3} = ['oriLaneFolVehLC'];
names{4}= ['oriLaneFrontVehLC'];
for i =1:4
    if isempty(trajs{i}) ==0
        XYDat =trajs{i};
          XYDat1 =trajs{5};
         figure(i)
         hold on
         plot(XYDat(:,1),XYDat(:,2),'b')
          plot(XYDat1(:,1),XYDat1(:,2),'r')
         hold off
         title(names{i})
         xlim([0 20]);
    end
    
end
end
