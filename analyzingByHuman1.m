%%人工分析各种特征，显示图像
function analyzingByHuman1(dat,mylk2lcInd,mylcInd1,mylcInd2,mylc2lkInd)
close all;       
frameId = dat(:,2);
        localX = dat(:,5)*0.3048;
        localY = dat(:,6)*0.3048;
        %         vehicleLen = dat(:,9)*0.3048;
        %         vehicleWid = dat(:,10)*0.3048;
        %         vehicleTyp = dat(:,11);
        vehicleVel = dat(:,12)*0.3048;
        vehicleAcc = dat(:,13)*0.3048;
        laneID = dat(:,14);
        preVeh = dat(:,15);
        spaceDis = dat(:,17)*0.3048;
        headWay = dat(:,18);
          spaceDis = dat(:,17)*0.3048;
          ind = spaceDis==0;
          spaceDis(ind)=median(spaceDis);
         TMP =diff(spaceDis)/0.1;
         spaceDisVel =[TMP(1);TMP];
         
         
        figure(102)
        subplot(3,1,1)
        hold on
        plot(localX,localY,'b.-');
        plot(localX(mylcInd1:mylcInd2),localY(mylcInd1:mylcInd2),'r.-');
        plot(localX(mylk2lcInd:mylcInd1-1),localY(mylk2lcInd:mylcInd1-1),'g.-');
        hold off
        xlim([0 30])

        subplot(3,1,2)
        plot(localX(mylcInd1:mylcInd2),localY(mylcInd1:mylcInd2),'b.-');
        xlim([0 30])

        subplot(3,1,3)
        hold on
        plot(localX(mylcInd1:mylcInd2),localY(mylcInd1:mylcInd2),'b.-');
        plot(localX(mylk2lcInd:mylcInd1-1),localY(mylk2lcInd:mylcInd1-1),'g.-');
        plot(localX(mylcInd2:mylc2lkInd),localY(mylcInd2:mylc2lkInd),'r.-');
        hold off
        xlim([0 30])
        
        figure(103)
        subplot(4,1,1)
        hold on
        plot(frameId,headWay,'b.-');
        plot(frameId(mylcInd1:mylcInd2),headWay(mylcInd1:mylcInd2),'r.-');
        plot(frameId(mylk2lcInd:mylcInd1-1),headWay(mylk2lcInd:mylcInd1-1),'g.-');
        hold off
        title('headWay')

        subplot(4,1,2)
        hold on
        plot(frameId,spaceDis,'b.-');
        plot(frameId(mylcInd1:mylcInd2),spaceDis(mylcInd1:mylcInd2),'r.-');
        plot(frameId(mylk2lcInd:mylcInd1-1),spaceDis(mylk2lcInd:mylcInd1-1),'g.-');
   hold off
title('spaceDis')
        subplot(4,1,3)
        hold on
        plot(frameId,vehicleAcc,'b.-');
        plot(frameId(mylcInd1:mylcInd2),vehicleAcc(mylcInd1:mylcInd2),'r.-');
        plot(frameId(mylk2lcInd:mylcInd1-1),vehicleAcc(mylk2lcInd:mylcInd1-1),'g.-');
        hold off
        title('vehicleAcc')
        
      subplot(4,1,4)
        hold on
        plot(frameId,spaceDisVel,'b.-');
        plot(frameId(mylcInd1:mylcInd2),spaceDisVel(mylcInd1:mylcInd2),'r.-');
        plot(frameId(mylk2lcInd:mylcInd1-1),spaceDisVel(mylk2lcInd:mylcInd1-1),'g.-');
   hold off
title('spaceDisVel')
     
               
end