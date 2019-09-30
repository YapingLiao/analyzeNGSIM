function findOneLCAndShow1(name)
%只找变道一次的，而且变道后持续4秒以上
%T = dir('E:\oneDriveData\OneDrive\GITHUB\analyzeNGSIM\LCSamples\*.csv');
T = dir(name);
counter =0;
    for i=1:length(T)
    
        str=[T(i).folder '\' T(i).name];
        disp(str)
        dat= csvread(str);
%         vehicleID = dat(:,1);
%         frameId = dat(:,2);
         localX = dat(:,5)*0.3048;
         localY = dat(:,6)*0.3048;
%         vehicleLen = dat(:,9)*0.3048;
%         vehicleWid = dat(:,10)*0.3048;
%         vehicleTyp = dat(:,11);
         vehicleVel = dat(:,12)*0.3048;
%         vehicleAcc = dat(:,13)*0.3048;
        laneID = dat(:,14);
%         preVeh = dat(:,15);
%         folVeh = dat(:,16);
%         spaceDis = dat(:,17)*0.3048;
%         headWay = dat(:,18);
        %只找变道一次的，而且变道前后变道后持续4秒以上，
        indT=find(abs(diff(laneID))>0);
        if length(indT) == 1
            lane1 = laneID(indT);
            lane2 = laneID(indT+1);
            indT1 = find(laneID==lane1);
            indT2 = find(laneID==lane2);
            if length(indT1)>30 && length(indT2)>30%变道前后变道后持续3秒以上
              
                 indTT1 = max(indT1(1),indT-100);
                 indTT2 = min(indT+120,indT2(end));
                [mylcInd1,mylcInd2] = laneChangeStartPoint(dat);%粗略找到变道开始和结束点
               if(mylcInd1==0 )
                   continue;
               end
                counter = counter+1;
                str2 = sprintf('.\\LCSamples\\OneLC%d.csv',counter);
                mylcFlag = zeros(size(laneID));
                mylcFlag(mylcInd1:mylcInd2)=1;
                dat1 = [dat mylcFlag];
                tmp = dat1(indTT1:indTT2,:);
                csvwrite(str2,tmp); 
                close all;
                figure(101)
                subplot(2,1,1)
                hold on
                plot(localX,localY,'b.-');
                 plot(localX(mylcInd1:mylcInd2),localY(mylcInd1:mylcInd2),'r.-');
                 hold off
                 xlim([0 30])
                
                subplot(2,1,2)
                plot(localX(mylcInd1:mylcInd2),localY(mylcInd1:mylcInd2),'b.-');
                xlim([0 30])
                title(i)
%                 pause(1);
            else
                   disp('变道时间不够')
            end
        else
            str = ['变道多次:' num2str(length(indT))];
            disp(str)
        end
    end
end

%% 根据90%置信度的点，找出车道转换开始和结束点
function [mylcInd1,mylcInd2] = laneChangeStartPoint(dat)
%         vehicleID = dat(:,1);
%         frameId = dat(:,2);
        localX = dat(:,5)*0.3048;
%         localY = dat(:,6)*0.3048;
%         vehicleLen = dat(:,9)*0.3048;
%         vehicleWid = dat(:,10)*0.3048;
%         vehicleTyp = dat(:,11);
%         vehicleVel = dat(:,12)*0.3048;
%         vehicleAcc = dat(:,13)*0.3048;
        laneID = dat(:,14);
%         preVeh = dat(:,15);
%         folVeh = dat(:,16);
%         spaceDis = dat(:,17)*0.3048;
%         headWay = dat(:,18);
        
        indT=find(abs(diff(laneID))>0);
        lane1 = laneID(indT);
        lane2 = laneID(indT+1);
        indT1 = find(laneID==lane1);
        indT2 = find(laneID==lane2);
        
        lcXpoint1 = localX(indT);
        mean1= mean(localX(indT1));
        mean2= mean(localX(indT2));
    
        
        if lcXpoint1>mean1
              tmp1 = max(1,indT-100):indT;
             mean1= mean(localX( tmp1));
             std1 = std(localX( tmp1));
             tr90 = mean1+0.5*std1;  
             tmp2 = find(localX(tmp1)>tr90);
              mylcInd1 = max(tmp1(tmp2(1)),indT-50);%车道转换前最多5秒开始
            
            
           
            tmp1 = indT:min(indT+120,numel(localX));
            mean1= mean(localX( tmp1));
            std1 = std(localX( tmp1));
            tr90 = mean1+0.1*std1;  
            tmp2 = find(localX(tmp1)>tr90);
            mylcInd2 = min(tmp1(tmp2(1)),indT+50);%车道转换后最多5秒结束
            
           
          
        end
        
        if lcXpoint1<=mean1
             tmp1 = max(1,indT-100):indT;
             mean1= mean(localX( tmp1));
             std1 = std(localX( tmp1));
             tr90 = mean1-0.5*std1;  
             tmp2 = find(localX(tmp1)<tr90);
               mylcInd1 = max(tmp1(tmp2(1)),indT-50);%车道转换前最多5秒开始
            
            
           
            tmp1 = indT:min(indT+120,numel(localX));
            mean1= mean(localX( tmp1));
            std1 = std(localX( tmp1));
            tr90 = mean1-0.1*std1;  
            tmp2 = find(localX(tmp1)<tr90);
            
           
             mylcInd2 = min(tmp1(tmp2(1)),indT+50);%车道转换后最多5秒结束
             
            
        end
           lcdist = abs(localX(mylcInd2)-localX(mylcInd1));
            if lcdist<2%转换距离不够，暂时不处理变道过程有长时间等待情况
            str = ['变道距离不够:' num2str(lcdist )];
            disp(str)
             mylcInd1 =0;
             mylcInd2 =0;
            end
        
end