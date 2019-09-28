function analyzingNGSIMLaneChangeScene1
%%分析场景信息，尤其是临近车道后车信息
index = 1:180;
featureAdj = zeros(180,8);

for i = index
    i
    str1 = sprintf('.\\LCSamples\\lcTrajs%d.mat',i);
    load(str1);
    names{1} = ['adjLaneFolvehLC'];
    names{2}= ['adjLaneFronVehLC'];
    names{3} = ['oriLaneFolVehLC'];
    names{4}= ['oriLaneFrontVehLC'];
    XYDat =trajs{1};
    XYDat1 =trajs{5};
    if adjLaneFolvehLC>0 && size(XYDat,1)>lcInd2
       
        
        folFrameID = XYDat(:,3);
        objFrameID = XYDat1(:,3);
        objLCFrameID1 = XYDat1(lcInd1,3); 
        folLCFrameID1 = find(folFrameID==objLCFrameID1);
        objLCFrameID2 = XYDat1(lcInd2,3);
        folLCFrameID2 =  find(folFrameID==objLCFrameID2);
        
        gapY1 = abs(XYDat1(lcInd1,2)-XYDat(folLCFrameID1,2));
        gapY2 = abs(XYDat1(lcInd2,2)-XYDat(folLCFrameID2,2));
        
        
  
        
        ind =[ 1:length(XYDat1(:,2))]';
%         vq1 = interp1(ind,XYDat1(:,2),ind, 'spline');
%         pobj = polyfit(ind,XYDat1(:,2),38);
%         fitval=polyval(pobj,ind);
%         A=fitval - XYDat1(:,2);

        ind1 =[ 1:length(XYDat1(:,2))]';
        fitobj= fit(ind1,XYDat1(:,2),'smoothingspline','SmoothingParam',0.01);
        fitval = feval(fitobj,ind1);
        objlocalXTmp = fitval;
        objVehVelYTmp = diff(fitval)/0.1;
        objVehVelYTmp =  [ objVehVelYTmp(1); objVehVelYTmp];
        
         ind2 =[ 1:length(XYDat(:,2))]';
        fitobj= fit(ind2,XYDat(:,2),'smoothingspline','SmoothingParam',0.01);
        fitval = feval(fitobj,ind2);
        follocalXTmp = fitval;
        folVehVelYTmp = diff(fitval)/0.1;
        folVehVelYTmp =  [ folVehVelYTmp(1); folVehVelYTmp];;

        
%         objVehVelY = diff( XYDat1(:,2))/0.1;
%         objVehVelY = [objVehVelY(1);objVehVelY];
%         objVehVelX = diff( XYDat1(:,1))/0.1;
%         objVehVelX = [objVehVelX(1);objVehVelX];
%         objVehVel = sqrt(objVehVelX.^2+objVehVelY.^2);
%         
%         
%         folVehVelY = diff( XYDat(:,2))/0.1;
%         folVehVelY = [folVehVelY(1);folVehVelY];
%         
%         velDiffY = objVehVelY(lcInd1)-folVehVelY(lcInd1);
%         figure(104),plot(ind,objVehVelYTmp,'r.',ind,objVehVelY,'bs')
        
        objVehVelY =  objVehVelYTmp;
        folVehVelY = folVehVelYTmp;
        close all
         figure(1)
         hold on
         plot(XYDat(:,1),XYDat(:,2),'b')
         plot(XYDat1(:,1),XYDat1(:,2),'r')
         hold off
         xlim([0 20]);
         
           figure(2)
         hold on
         plot(folFrameID,folVehVelY,'b')
         plot(objFrameID,objVehVelY,'r')
%         plot( objFrameID,objVehVel,'y')
            figure(3)
         hold on
         plot(folFrameID,XYDat(:,1),'b')
         plot(objFrameID,XYDat1(:,1),'r')
          plot(objFrameID(lcInd1),XYDat1(lcInd1,1),'kh');
          plot(objFrameID(lcInd2),XYDat1(lcInd2,1),'ks')
%         plot( objFrameID,objVehVel,'y')
         hold off
         
           figure(4)
         hold on
         plot(folFrameID,XYDat(:,2),'b')
         plot(objFrameID,XYDat1(:,2),'r')
          plot(objFrameID(lcInd1),XYDat1(lcInd1,2),'kh');
          plot(objFrameID(lcInd2),XYDat1(lcInd2,2),'ks')
%         plot( objFrameID,objVehVel,'y')
         hold off
         if isempty(folLCFrameID1)== 0
             gapY =  objlocalXTmp(lcInd1:lcInd2)-follocalXTmp(folLCFrameID1:folLCFrameID2);
             gapVelY = objVehVelY (lcInd1:lcInd2)-folVehVelY(folLCFrameID1:folLCFrameID2);
              figure(5)
              subplot(3,1,1)
              plot(objFrameID(lcInd1):objFrameID(lcInd2),gapVelY,'rs-')
              title('gapVelY')
                subplot(3,1,2)
              plot(objFrameID(lcInd1):objFrameID(lcInd2),gapY,'rs-')
              title('gapY')
               subplot(3,1,3)
              hold on
         plot(folFrameID,XYDat(:,1),'b')
         plot(objFrameID,XYDat1(:,1),'r')
          plot(objFrameID(lcInd1),XYDat1(lcInd1,1),'kh');
          plot(objFrameID(lcInd2),XYDat1(lcInd2,1),'ks')
%         plot( objFrameID,objVehVel,'y')
         hold off
     
            f1 =  [gapY1 objVehVelY(lcInd1) folVehVelY( folLCFrameID1) gapVelY(1)   gapY2 objVehVelY(lcInd2) folVehVelY(folLCFrameID2) gapVelY(end) ];
         
             featureAdj(i,:) =f1;
             if gapY1<8
                 gapY1;
             end
             
             
         end
    end

end
save  features.mat featureAdj
%%
close all
load   features.mat
figure(1);
hist(featureAdj(:,5),30)
figure(2)
hist(featureAdj(:,8),30)
figure(3);
plot(featureAdj(:,5),featureAdj(:,8),'.')

figure(11);
hist(featureAdj(:,1),30)
figure(21)
hist(featureAdj(:,4),30)
figure(31);
plot(featureAdj(:,1),featureAdj(:,4),'.')
    
    
end
%%如果间距大，间距速度比较大，大大部分平顺的车道转换，小部分二阶段
%%如果间距一般大，间距速度大于0，大部分平顺的车道转换，小部分二阶段
%%如果间距大，间距速度小于0，那样二阶段车道转换（第一阶段明显的车道转换），或者迅速车道转换
%%如果间距小，间距速度小于0，那样二阶段车道转换（第一阶段明显的车道转换），或者迅速车道转换，拟合结果优劣，危险优劣
