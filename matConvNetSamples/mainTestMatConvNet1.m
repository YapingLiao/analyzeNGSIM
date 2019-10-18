%quick start:http://www.vlfeat.org/matconvnet/quick/
function mainTestMatConvNet1

%只运行一次
if 1
untar('http://www.vlfeat.org/matconvnet/download/matconvnet-1.0-beta25.tar.gz') ;
cd matconvnet-1.0-beta25

%如果找不到cl.exe ，根据
%https://stackoverflow.com/questions/40226354/matconvnet-error-cl-exe-not-found，设定
%
%mex --setup 
run matlab/vl_compilenn ;
urlwrite(...
  'http://www.vlfeat.org/matconvnet/models/imagenet-vgg-f.mat', ...
  'imagenet-vgg-f.mat') ;
urlwrite(...
  'http://www.vlfeat.org/matconvnet/models/imagenet-googlenet-dag.mat', ...
  'imagenet-googlenet-dag.mat') ;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd matconvnet-1.0-beta25
net = load('imagenet-vgg-f.mat') ;
net = vl_simplenn_tidy(net) ;

% Obtain and preprocess an image.
im = imread('peppers.png') ;
im_T = single(im) ; % note: 255 range
im_T = imresize(im_T, net.meta.normalization.imageSize(1:2)) ;
im_T = im_T - net.meta.normalization.averageImage ;

% Run the CNN.
res = vl_simplenn(net, im_T) ;

% Show the classification result.
scores = squeeze(gather(res(end).x)) ;
[bestScore, best] = max(scores) ;
figure(1) ; clf ; imagesc(im) ;
title(sprintf('%s (%d), score %.3f',...
   net.meta.classes.description{best}, best, bestScore)) ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
net = dagnn.DagNN.loadobj(load('imagenet-googlenet-dag.mat')) ;
net.mode = 'test' ;

% load and preprocess an image
im = imread('peppers.png') ;
im_ = single(im) ; % note: 0-255 range
im_ = imresize(im_, net.meta.normalization.imageSize(1:2)) ;
im_ = bsxfun(@minus, im_, net.meta.normalization.averageImage) ;

% run the CNN
net.eval({'data', im_}) ;

% obtain the CNN otuput
scores = net.vars(net.getVarIndex('prob')).value ;
scores = squeeze(gather(scores)) ;

% show the classification results
[bestScore, best] = max(scores) ;
figure(1) ; clf ; imagesc(im) ;
title(sprintf('%s (%d), score %.3f',...
net.meta.classes.description{best}, best, bestScore)) ;
end