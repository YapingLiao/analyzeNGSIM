%;%只找变道一次的，而且变道后持续4秒以上，而且变道前有过渡带类型，并且增加与前车HEADWAY;用另外一个模型，SEQ->Seq，只做4类，提高正确率。注意，车道转换结束点为
%mean1加减0.1*std1，提前了,以及第4类为异常类，例如HEADWAY跳变点，而不是lc2lk的变换点
function findOneLCAndShow8(name)
%只找变道一次的，而且变道后持续4秒以上
%T = dir('E:\oneDriveData\OneDrive\GITHUB\analyzeNGSIM\LCSamples\*.csv');
T = dir(name);
allData =[];
counter =0;
headwayList =[];%用于分析
vehicleVelList =[];%用于分析
spaceDisList =[]
    for i=1:length(T)
    
        str=[T(i).folder '\' T(i).name];
        disp(str)
        dat= csvread(str);
%         vehicleID = dat(:,1);
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
         folVeh = dat(:,16);
         spaceDis = dat(:,17)*0.3048;
        headWay = dat(:,18);
        
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
        %%只找变道一次的，而且变道前后变道后持续4秒以上，变道前有过渡带类型
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
               
               if(headWay(indT)<0.1)
                    continue;
               end
               
                if(headWay(indT)<0.1)
                    continue;
               end
               
               %%%变道开始时，车道转换和车道保持之间的过渡带
              TMP = diff(localX)*0.3048;
               %%%变道开始时，车道转换和车道保持之间的过渡带
              indTmp = [mylcInd1-1:-1:mylcInd1-10];
              indTmp2 =[mylcInd1-1:-1:max(1,mylcInd1-30)];
              meanTmp = mean(TMP(indTmp2));
              flag = mylcInd1-1;
              
              %向右
             
              
              for j=indTmp
                  
                %向右
                if sign(TMP(indT))>0 %向右
                    flagTmp = TMP(j)>meanTmp;
                else %向左
                    flagTmp = TMP(j)<meanTmp;
                end
              
                  if sign(TMP(j)) == sign(TMP(indT)) && flagTmp==1
                      flag = j;
                      continue;
                  else
                      break
                  end
              end
              flag =max(1, min(mylcInd1-5,flag));%至少0.3秒
              mylk2lcInd=flag;
              
              
              
               %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
               %%%看特征
            if 0   
               figure(10001),
               subplot(6,1,1)
              plot(localX(mylcInd1:mylcInd2),localY(mylcInd1:mylcInd2),'b.-');
              title('localXY')
              subplot(6,1,2)
              plot(frameId(mylcInd1:mylcInd2),headWay(mylcInd1:mylcInd2),'b.-');
               title('headWay')
               subplot(6,1,3)
              plot(frameId(mylcInd1:mylcInd2),spaceDis(mylcInd1:mylcInd2),'b.-');
               title('spaceDis') 
                subplot(6,1,4)
              plot(frameId(mylcInd1:mylcInd2),preVeh(mylcInd1:mylcInd2),'b.-');
               title('preVeh') 
                   subplot(6,1,5)
              plot(frameId(mylcInd1:mylcInd2),vehicleVel(mylcInd1:mylcInd2),'b.-');
               title('preVeh') 
                   subplot(6,1,6)
              plot(frameId(mylcInd1:mylcInd2),vehicleAcc(mylcInd1:mylcInd2),'b.-');
               title('preVeh') 
               
               figure(10002),
               subplot(6,1,1)
              plot(localX(mylk2lcInd:mylcInd2),localY(mylk2lcInd:mylcInd2),'b.-');
              title('localXY')
              subplot(6,1,2)
              plot(frameId(mylk2lcInd:mylcInd2),headWay(mylk2lcInd:mylcInd2),'b.-');
               title('headWay')
               subplot(6,1,3)
              plot(frameId(mylk2lcInd:mylcInd2),spaceDis(mylk2lcInd:mylcInd2),'b.-');
               title('spaceDis') 
                subplot(6,1,4)
              plot(frameId(mylk2lcInd:mylcInd2),preVeh(mylk2lcInd:mylcInd2),'b.-');
               title('preVeh') 
                   subplot(6,1,5)
              plot(frameId(mylk2lcInd:mylcInd2),vehicleVel(mylk2lcInd:mylcInd2),'b.-');
               title('vehicleVel') 
                   subplot(6,1,6)
              plot(frameId(mylk2lcInd:mylcInd2),vehicleAcc(mylk2lcInd:mylcInd2),'b.-');
               title('vehicleAcc') 
            end
               %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
               %%%生成数据，添加标记
                counter = counter+1;
                str2 = sprintf('.\\LCSamples\\OneLC3Type%d.csv',counter);
                mylcFlag = zeros(numel(laneID),1);
                mylcFlag(mylcInd1:mylcInd2)=1;
                 mylcFlag(mylk2lcInd:mylcInd1)=2;
%                  mylcFlag(indT+1)=3;%车道变换点，headway跳变
                 
             
             
%                 mylcFlag(indT+1) =3;%车道变换时HEAWAY出现跳变，出现异常，归类为3
             

                dat1 = [dat mylcFlag];
                tmp = dat1(indTT1:indTT2,:);
                
                csvwrite(str2,tmp); 
                allData = [allData;dat1];
                headwayList(counter,:)=[headWay(indT) headWay(indT-1) headWay(indT-2)];
                spaceDisList(counter,:)=[spaceDis(indT) spaceDis(indT-1) spaceDis(indT-2)];
                vehicleVelList(counter,:)=[vehicleVel(indT) vehicleVel(indT-1) vehicleVel(indT-2)];
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                if 0
                close all
                figure(101)
                subplot(3,1,1)
                hold on
                plot(localX,localY,'b.-');
                 plot(localX(mylcInd1:mylcInd2),localY(mylcInd1:mylcInd2),'r.-');
                 plot(localX(mylk2lcInd:mylcInd1-1),localY(mylk2lcInd:mylcInd1-1),'g.-');
                 hold off
                 xlim([0 30])
                title(i)
                subplot(3,1,2)
                plot(localX(mylcInd1:mylcInd2),localY(mylcInd1:mylcInd2),'b.-');
                xlim([0 30])
                  subplot(3,1,3)
                   plot(frameId(mylcInd1:mylcInd2),headWay(mylcInd1:mylcInd2),'b.-');
                
                end
                
%                 analyzingByHuman1(dat,mylk2lcInd,mylcInd1,mylcInd2,mylc2lkInd)
                
%                 pause(5);
            else
                   disp('变道时间不够')
            end
        else
            str = ['变道多次:' num2str(length(indT))];
            disp(str)
        end
    end
    str2 ='.\\LCSamples\\OneLC3TypeAllData.csv';
    csvwrite(str2,allData);
    
    figure,
    subplot(3,1,1)
    plot(headwayList(:,1))

    subplot(3,1,2)
    plot(headwayList(:,2))

    subplot(3,1,3)
    plot(headwayList(:,2))

    figure,
    subplot(3,1,1)
    hist(headwayList(:,1),100);

    subplot(3,1,2)
    hist(spaceDisList(:,1),100);

    subplot(3,1,3)
    hist(vehicleVelList(:,1),100);
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
        
        
        lcXpoint1 = localX(indT);
        mean1= mean(localX(indT1));
      
    
        
        if lcXpoint1>mean1%向右转
              tmp1 = max(1,indT-100):indT;
             mean1= mean(localX( tmp1));
             std1 = std(localX( tmp1));
             tr90 = mean1+0.5*std1;  
             tmp2 = find(localX(tmp1)>tr90);
              mylcInd1 = max(tmp1(tmp2(1)),indT-50);%车道转换前最多5秒开始
            
            
           
            tmp1 = indT:min(indT+120,numel(localX));
            mean1= mean(localX( tmp1));
            std1 = std(localX( tmp1));
            tr90 = mean1-0.1*std1;  
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
            tr90 = mean1+0.1*std1;  
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

