# analyzing NGSIM
�������mainAnalyzeNGSIMForLC3�ļ�    
1.ֱ�Ӷ���NGSIM��txt�ļ���ע���RAR�ļ���ѹ��ΪTXT�ļ�������importData ,�������п��ܵı��·������ȡΪ����CSV�ļ�������extractLaneChangeDataIntoCSV    
2.���뵥��CSV(����LC1.CSV),�����Ƿ�Ϊ�������������������Ľ��ļ���ΪoneLC.csv.�����������Ϊ  
A.ֻ��һ�α���������ڶ�α��  
B.������ǰ��ʱ�䲻�ᳬ��5�룬Ҳ����˵���������̲�����10��    
C.���·��X����仯����3��  
D.���·����ʼ��ͽ�����Ĵ���Ϊƽ������һ��㷽������findOneLCAndShow1�еĴ���
3.����LSTMʶ��LC����LK��LSTM�����Ϊ���е����У��ļ�ΪtrainLSTM1  
#############################################################################  

4.������txt�����ļ�һ���Զ����ļ��У�����������LC.csv�ļ���ע�⽫1�Ĵ���������޸�  
5.findOneLCAndShow2,trainLSTM2 ,ʵ����3�࣬LK2LC�Ĺ�������Ǻ�ѵ��  
6.findTwoLCAndShow2,ʵ����2������ת��    
7.findOneLCAndShow3,trainLSTM3, ʵ����4��,LK2LC,LC2LK,�Ĺ�������Ǻ�ѵ��  
8.findOneLCAndShow4,trainLSTM4, ʵ����4��,LK2LC,LC2LK,�Ĺ�������Ǻ�ѵ��,������HEADWAY����������trainLSTM3ʵ���˶��LSTM  
9.featureTest1.m ʵ������ѡ���㷨  
10.analyzingByHuman1.m �����˹��۲�����  
11.findOneLCAndShow5,trainLSTM5, ��findOneLCAndShow4,trainLSTM4, �Ļ����ϣ�ת��ΪSeq2one��LSTMģ�͡�  
12 findOneLCAndShow6,trainLSTM6, ֻ�ұ��һ�εģ����ұ�������4�����ϣ����ұ��ǰ�й��ɴ����ͣ�3�࣬����������ǰ��HEADWAY;������һ��ģ�ͣ�SEQ->ONE  
13 findOneLCAndShow67,trainLSTM7, ֻ�ұ��һ�εģ����ұ�������4�����ϣ����ұ��ǰ�й��ɴ����ͣ�4�࣬����������ǰ��HEADWAY;������һ��ģ�ͣ�SEQ->SEQ
����4��Ϊ�쳣�࣬����HEADWAY����㣬������lc2lk�ı任�㡣  
14 findOneLCAndShow8,����headwayɾ��һЩ���õ�����   
15 trainLSTM8, SEQ->SEQ����Ϊ3��ʹ��С��'MiniBatchSiz������ѵ�����ݸ�Ϊ������    
16 findOneLCAndShow8, ��һ����lc2lk����ֵ��Ϊmean1�Ӽ�0.5*std1; 



ע��
1.ע��trainLSTM7,validList = num2(num1+1:num1+2),��С����Ϊ���������̫��Ĵ���  
2.ע�⵱��������ܴ�����СMiniBatchSize',��'MiniBatchSize',8��������trainLSTM8
#############################################################################  
����ָ�
1.���ſ�https://blog.csdn.net/qian2213762498/article/details/82788273  


#############################################################################  
MATCONVNET
1.���ſ���  
https://www.cnblogs.com/xiaotongtt/p/8322198.html  
https://blog.csdn.net/anysky___/article/details/51356158

2.FCN �ָ�ͼ�����  
https://github.com/DUTFangXiang/ExtractFCNFeature  
https://github.com/onnx/models#object_detection  
https://github.com/tensorflow/models/tree/master/research/deeplab  
3 ��װ�������ӣ�����MATLAB�� ��https://github.com/search?l=MATLAB&p=1&q=semantic+segmentation&type=Repositories�� ��
https://github.com/nightrome/matconvnet-calvin  
https://github.com/HyeonwooNoh/DeconvNet   


