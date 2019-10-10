%ֻ�ұ��һ�εģ����ұ�������4�����ϣ����ұ��ǰ�й��ɴ����ͣ������Ҳ�й��ɴ�
function findOneLCAndShow3(name)
%ֻ�ұ��һ�εģ����ұ�������4������
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
        %ֻ�ұ��һ�εģ����ұ��ǰ���������4�����ϣ�
        indT=find(abs(diff(laneID))>0);
        if length(indT) == 1
            lane1 = laneID(indT);
            lane2 = laneID(indT+1);
            indT1 = find(laneID==lane1);
            indT2 = find(laneID==lane2);
            if length(indT1)>30 && length(indT2)>30%���ǰ���������3������
              
                 indTT1 = max(indT1(1),indT-100);
                 indTT2 = min(indT+120,indT2(end));
                [mylcInd1 mylcInd2] = laneChangeStartPoint(dat);%�����ҵ������ʼ�ͽ�����
               if(mylcInd1==0 )
                   continue;
               end
               
               %%%�����ʼʱ������ת���ͳ�������֮��Ĺ��ɴ�
              TMP = diff(localX)*0.3048;
               %%%�����ʼʱ������ת���ͳ�������֮��Ĺ��ɴ�
              indTmp = [mylcInd1-1:-1:mylcInd1-10];
              indTmp2 =[mylcInd1-1:-1:max(1,mylcInd1-30)];
              meanTmp = mean(TMP(indTmp2));
              flag = mylcInd1-1;
              
              %����
             
              
              for j=indTmp
                  
                %����
                if sign(TMP(indT))>0 %����
                    flagTmp = TMP(j)>meanTmp;
                else %����
                    flagTmp = TMP(j)<meanTmp;
                end
              
                  if sign(TMP(j)) == sign(TMP(indT)) && flagTmp==1
                      flag = j;
                      continue;
                  else
                      break
                  end
              end
              flag =max(1, min(mylcInd1-5,flag));%����0.3��
              mylk2lcInd=flag;
              
              
               %%%�������ʱ������ת���ͳ�������֮��Ĺ��ɴ�
               indTmp = [mylcInd2-1:mylcInd2+30];
                
               indTmp2 =[mylcInd2-1:min(numel(TMP),mylcInd2+30)];
               meanTmp = mean(TMP(indTmp2));
                flag = mylcInd2-1;
                
                
              for j=indTmp
                  
                   %����
                    if sign(TMP(indT))>0 %����
                        flagTmp = TMP(j)>meanTmp;
                    else %����
                        flagTmp = TMP(j)<meanTmp;
                    end

                      if sign(TMP(j)) == sign(TMP(indT)) && flagTmp==1
                          flag = j;
                          continue;
                      else
                          break
                      end
              end
               
              flag =max(mylcInd2+3, flag);%����0.3��
              mylc2lkInd=flag;
               %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
               
                counter = counter+1;
                str2 = sprintf('.\\LCSamples\\OneLC4Type%d.csv',counter);
                mylcFlag = zeros(size(laneID));
                mylcFlag(mylcInd1:mylcInd2)=1;
                
                mylcFlag(mylk2lcInd:mylcInd1-1)=2;%��lk2lc���ɴ�
                
                mylcFlag(mylcInd2:mylc2lkInd)=3;%��lc2lk���ɴ�
                dat1 = [dat mylcFlag];
                tmp = dat1(indTT1:indTT2,:);
                csvwrite(str2,tmp); 
                close all;
                figure(101)
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
                title(i)
%                pause(5);
            else
                   disp('���ʱ�䲻��')
            end
        else
            str = ['������:' num2str(length(indT))];
            disp(str)
        end
    end
end

%% ����90%���Ŷȵĵ㣬�ҳ�����ת����ʼ�ͽ�����
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
              mylcInd1 = max(tmp1(tmp2(1)),indT-50);%����ת��ǰ���5�뿪ʼ
            
            
           
            tmp1 = indT:min(indT+120,numel(localX));
            mean1= mean(localX( tmp1));
            std1 = std(localX( tmp1));
            tr90 = mean1+0*std1;  
            tmp2 = find(localX(tmp1)>tr90);
            mylcInd2 = min(tmp1(tmp2(1)),indT+50);%����ת�������5�����
            
           
          
        end
        
        if lcXpoint1<=mean1
             tmp1 = max(1,indT-100):indT;
             mean1= mean(localX( tmp1));
             std1 = std(localX( tmp1));
             tr90 = mean1-0.5*std1;  
             tmp2 = find(localX(tmp1)<tr90);
               mylcInd1 = max(tmp1(tmp2(1)),indT-50);%����ת��ǰ���5�뿪ʼ
            
            
           
            tmp1 = indT:min(indT+120,numel(localX));
            mean1= mean(localX( tmp1));
            std1 = std(localX( tmp1));
            tr90 = mean1-0*std1;  
            tmp2 = find(localX(tmp1)<tr90);
            
           
             mylcInd2 = min(tmp1(tmp2(1)),indT+50);%����ת�������5�����
             
            
        end
           lcdist = abs(localX(mylcInd2)-localX(mylcInd1));
            if lcdist<2%ת�����벻������ʱ�������������г�ʱ��ȴ����
            str = ['������벻��:' num2str(lcdist )];
            disp(str)
             mylcInd1 =0;
             mylcInd2 =0;
            end
        
end