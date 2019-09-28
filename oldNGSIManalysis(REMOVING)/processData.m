function processData()
    counter = 0;
    for i=1:543
        i
        str = sprintf('.\\LCSamples\\LC%d.xlsx',i);
        [dat,txt,raw]= xlsread(str);
%         vehicleID = dat(:,1);
%         frameId = dat(:,2);
%         localX = dat(:,5)*0.3048;
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
        if length(indT) == 1
            lane1 = laneID(indT);
            lane2 = laneID(indT+1);
            indT1 = find(laneID==lane1);
            indT2 = find(laneID==lane2);
            if length(indT1)>30 && length(indT2)>30 
                counter = counter+1;
                str2 = sprintf('.\\LCSamples\\OneLC%d.csv',counter);
                 indTT1 = max(indT1(1),indT-100);
                 indTT2 = min(indT+100,indT2(end));
                mylcInd = laneChangeStartPoint(dat);
%                 ind2=find(abs(diff(laneID))>0);
                
                mylcFlag = zeros(size(laneID));
                mylcFlag(mylcInd) =1;
                dat1 = [dat mylcFlag];
               tmp = dat1(indTT1:indTT2,:);
                csvwrite(str2,tmp); 
            end
        end
    end
end

%% ����������5��ǰ���ҳ�������볬��90%���Ŷȵĵ�
function mylcInd = laneChangeStartPoint(dat)
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
        std1 = std(localX(indT1));
        
        if lcXpoint1>mean1
            tr90 = mean1+1*std1;
            indT1 = max(1,indT-50):indT;
            indT2 = find(localX(indT1)>tr90);
            mylcInd = indT1(indT2(1));
        end
        
        if lcXpoint1<=mean1
            tr90 = mean1-1*std1;
            indT1 = max(1,indT-50):indT;
            indT2 = find(localX(indT1)<tr90);
            mylcInd = indT1(indT2(1));
        end
        
end