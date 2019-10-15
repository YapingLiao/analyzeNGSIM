# analyzing NGSIM
步骤基于mainAnalyzeNGSIMForLC3文件    
1.直接读入NGSIM的txt文件（注意把RAR文件解压缩为TXT文件），用importData ,并把所有可能的变道路径，提取为单个CSV文件，基于extractLaneChangeDataIntoCSV    
2.读入单个CSV(类似LC1.CSV),分析是否为正常变道，是正常变道的将文件存为oneLC.csv.正常变道规则为  
A.只有一次变道，不存在多次变道  
B.变道点的前后时间不会超过5秒，也就是说变道这个过程不超过10秒    
C.变道路径X距离变化大于3米  
D.变道路径起始点和结束点的粗略为平均数加一点点方差，具体见findOneLCAndShow1中的代码
3.基于LSTM识别LC还是LK，LSTM的类别为序列到序列，文件为trainLSTM1  
#############################################################################  

4.将所有txt数据文件一次性读入文件中，并生成所有LC.csv文件。注意将1的代码进行了修改  
5.findOneLCAndShow2,trainLSTM2 ,实现了3类，LK2LC的过渡类别标记和训练  
6.findTwoLCAndShow2,实现找2个车道转换    
7.findOneLCAndShow3,trainLSTM3, 实现了4类,LK2LC,LC2LK,的过渡类别标记和训练  
8.findOneLCAndShow4,trainLSTM4, 实现了4类,LK2LC,LC2LK,的过渡类别标记和训练,并加入HEADWAY特征。其中trainLSTM3实现了多层LSTM  
9.featureTest1.m 实现特征选择算法  
10.analyzingByHuman1.m 用于人工观察数据  
11.findOneLCAndShow5,trainLSTM5, 在findOneLCAndShow4,trainLSTM4, 的基础上，转换为Seq2one的LSTM模型。  
12 findOneLCAndShow6,trainLSTM6, 只找变道一次的，而且变道后持续4秒以上，而且变道前有过渡带类型，3类，并且增加与前车HEADWAY;用另外一个模型，SEQ->ONE  

#############################################################################  
语义分割
1.入门看https://blog.csdn.net/qian2213762498/article/details/82788273  



