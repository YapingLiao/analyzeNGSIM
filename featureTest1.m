
%%
clear all;
XTrain={};
YTrain ={};
counter = 0;
name{1} = '.\LCSamples\oneLC4Type*.csv';
X=[];
Y= [];
for k=1:1
    nameT = name{k};
    T = dir(nameT);
    for i=1:length(T)
        str=[T(i).folder '\' T(i).name];
        disp(str)
        dat= csvread(str);
        
        localX = dat(:,5)*0.3048;
         vehicleAcc = dat(:,13)*0.3048;
         
         spaceDis = dat(:,17)*0.3048;
         TMP =diff(spaceDis)/0.1;
         spaceDisVel =[TMP(1);TMP];
        headWay = dat(:,18);
         
        meanLocalX = mean(localX(1:30));
        std1 = std(localX(1:30));
        localX1 =  (localX-meanLocalX);
        
        Tmp = diff(localX1)/0.1;  
        Xvel = [Tmp(1);Tmp];
        meanXvel= mean(Xvel(1:30));
        std1 = std(Xvel(1:30));
        Xvel1=(Xvel-meanXvel);
        
        counter= counter+1;
        
         label = dat(:,19);
        Y =[Y; categorical(label)];
        TMP = [localX1 Xvel1 vehicleAcc spaceDis  headWay ];  
        X = [X;TMP];  
    end
end

save features.mat X Y;


%%

load features.mat X Y;
mdl = fscnca(X,Y,'Solver','sgd','Verbose',1,'IterationLimit',500);   

figure()
plot(mdl.FeatureWeights,'ro')
grid on
xlabel('Feature index')
ylabel('Feature weight')