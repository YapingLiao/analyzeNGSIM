%%
%%���ļ����ж���׼���õıȽϺõ�һ�γ���ת��������
function showRvl2()
clear all;
close all
% load ngsimOneLC3Type.mat;
load ngsimOneLC3TypeSeq2OneImage.mat;
YPred = classify(net,XValidation1);
cm = confusionchart(YValidation1,YPred );


XTest = XTrain1{1};
YTest = YTrain1{1};
XTest = XValidation1{3};
YTest = YValidation1{3};
YPred = classify(net,XTest);
acc = sum(YPred == YTest)./numel(YTest)


end