# analyzing NGSIM
步骤基于mainAnalyzeNGSIMForLC3文件    
1.直接读入NGSIM的txt文件（注意把RAR文件解压缩为TXT文件），用importData ,并把所有可能的变道路径，提取为单个CSV文件，基于extractLaneChangeDataIntoCSV    
2.读入单个CSV(类似LC1.CSV),分析是否为正常变道，正常变道规则为  
A.只有一次变道，不存在多次变道  
B.变道点的前后时间不会超过5秒，也就是说变道这个过程不超过10秒    
C.变道路径X距离变化大于3米  
D.变道路径起始点和结束点的粗略为平均数加一点点方差，具体见findOneLCAndShow1中的代码
