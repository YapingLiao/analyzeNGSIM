%%
%%���ļ����ж���׼���õıȽϺõ�һ�γ���ת��������
function showRvl()
clear all;
close all
% load ngsimOneLC3Type.mat;
load ngsimOneLC4Type.mat;


XTest = XTrain1{2};
YTest = YTrain1{2};
XTest = XValidation1{3};
YTest = YValidation1{3};
YPred = classify(net,XTest);
acc = sum(YPred == YTest)./numel(YTest)

figure
plot(YPred,'.-')
hold on
plot(YTest)
hold off

xlabel("Time Step")
ylabel("Activity")
title("Predicted Activities")
legend(["Predicted" "Test Data"])
end