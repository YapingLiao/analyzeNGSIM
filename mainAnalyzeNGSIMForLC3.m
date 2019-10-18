function mainAnalyzeNGSIMForLC3
clc;
close all;
clear all;
ex1();%���γ���ת�������漰ǰ��
%ex2();%���γ���ת�����漰�ٽ�������
end

%%
function ex1()
%���γ���ת�������漰ǰ��
csvDataIsOk = 1;
if csvDataIsOk ==0
dataFile{1} = 'trajectories-0750am-0805am.txt';
dataFile{2} = 'trajectories-0805am-0820am.txt';
dataFile{3} = 'trajectories-0820am-0835am.txt';

extractLaneChangeDataIntoCSV(dataFile);%�����д��ڳ���ת����·������
end

if 0
 name = '.\\LCSamples\\LC*.csv';
 findOneLCAndShow1(name);%ֻ�ұ��һ�εģ����ұ�������4������
  trainLSTM1();%ֻѵ�����1�ε�
end

if 0
 name = '.\\LCSamples\\LC*.csv';
 findTwoLCAndShow1(name);%ֻ�ұ�����εģ����ұ�������4�����ϡ�%��ʱ�ޱȽϺõķ�����˼·����
end

if 0
 name = '.\\LCSamples\\LC*.csv';
 findOneLCAndShow2(name);%ֻ�ұ��һ�εģ����ұ�������4�����ϣ����ұ��ǰ�й��ɴ�����
 trainLSTM2();%ֻѵ�����1�ε�
end


if 0
 name = '.\\LCSamples\\LC*.csv';
 findOneLCAndShow3(name);%ֻ�ұ��һ�εģ����ұ�������4�����ϣ����ұ��ǰ�й��ɴ����ͣ������Ҳ�й��ɴ�
 trainLSTM3();%ֻѵ�����1�ε�
end
 %�����磺https://blog.csdn.net/weixin_43575157/article/details/83617949
 
if 0
 name = '.\\LCSamples\\LC*.csv';
 findOneLCAndShow4(name);%ֻ�ұ��һ�εģ����ұ�������4�����ϣ����ұ��ǰ�й��ɴ����ͣ������Ҳ�й��ɴ�������������ǰ������
 trainLSTM4();%ֻѵ�����1�ε�
end

if 0
 name = '.\\LCSamples\\LC*.csv';
 findOneLCAndShow5(name);%ֻ�ұ��һ�εģ����ұ�������4�����ϣ����ұ��ǰ�й��ɴ����ͣ������Ҳ�й��ɴ�������������ǰ������,������һ��ģ�ͣ�SEQ->ONE
 trainLSTM5();%ֻѵ�����1�ε�
end

if 0
 name = '.\\LCSamples\\LC*.csv';
 findOneLCAndShow6(name);%ֻ�ұ��һ�εģ����ұ�������4�����ϣ����ұ��ǰ�й��ɴ����ͣ�����������ǰ������,������һ��ģ�ͣ�SEQ->ONE
 trainLSTM6();%ֻѵ�����1�ε�
end

if 0
 name = '.\\LCSamples\\LC*.csv';
 findOneLCAndShow7(name);%ֻ�ұ��һ�εģ����ұ�������4�����ϣ����ұ��ǰ�й��ɴ����ͣ�����������ǰ������,������һ��ģ�ͣ�SEQ->ONE
 trainLSTM7();%ֻѵ�����1�ε�
end

if 1
 name = '.\\LCSamples\\LC*.csv';
 findOneLCAndShow8(name);%ֻ�ұ��һ�εģ����ұ�������4�����ϣ����ұ��ǰ�й��ɴ����ͣ�����������ǰ������,������һ��ģ�ͣ�SEQ->ONE
  trainLSTM8();%ֻѵ�����1�ε�
end
end



%%
function ex2()
%���γ���ת�����漰�ٽ�������

xlsFileName = 'US101-part1.xlsx';
extractLaneChangeDataIntoXLS2(xlsFileName);
% processData();
% processData2();
% showData();
% trainCNN();
end

function showData()

for i=1:180
        str = sprintf('.\\LCSamples\\OneLC%d.xlsx',i);
        [dat,txt,raw]= xlsread(str);
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
        mylcFlag = dat(:,19);
        
        
        indT=find(abs(diff(laneID))>0);
        indT2 = find(mylcFlag ==1);
        clf
        
       pause
    end
end
