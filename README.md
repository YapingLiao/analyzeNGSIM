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