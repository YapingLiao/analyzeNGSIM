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
13 findOneLCAndShow67,trainLSTM7, 只找变道一次的，而且变道后持续4秒以上，而且变道前有过渡带类型，4类，并且增加与前车HEADWAY;用另外一个模型，SEQ->SEQ
及第4类为异常类，例如HEADWAY跳变点，而不是lc2lk的变换点。  
14 findOneLCAndShow8,根据headway删除一些不好的数据   
15 trainLSTM8, SEQ->SEQ，改为3类使用小的'MiniBatchSiz，而且训练数据改为单精度    
16 findOneLCAndShow8, 进一步将lc2lk的阈值改为mean1加减0.5*std1; 



注意
1.注意trainLSTM7,validList = num2(num1+1:num1+2),很小，因为会出现数组太大的错误  
2.注意当出现数组很大是缩小MiniBatchSize',（'MiniBatchSize',8）类似在trainLSTM8
#############################################################################  
语义分割
1.入门看https://blog.csdn.net/qian2213762498/article/details/82788273  


#############################################################################  
MATCONVNET
1.入门看：  
https://www.cnblogs.com/xiaotongtt/p/8322198.html  
https://blog.csdn.net/anysky___/article/details/51356158

2.FCN 分割图像程序  
https://github.com/DUTFangXiang/ExtractFCNFeature  
https://github.com/onnx/models#object_detection  
https://github.com/tensorflow/models/tree/master/research/deeplab  
3 安装各种例子（除了MATLAB） （https://github.com/search?l=MATLAB&p=1&q=semantic+segmentation&type=Repositories） 、
https://github.com/nightrome/matconvnet-calvin  
https://github.com/HyeonwooNoh/DeconvNet   


