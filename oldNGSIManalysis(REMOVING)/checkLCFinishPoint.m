function frameIDLC = checkLCFinishPoint(trajs)
tmp = trajs{5};
objlocalX = tmp(:,1);
objlocalY = tmp(:,2);
objframeId = tmp(:,3);
objframeIdTmp = unique(objframeId);
if length(objframeId) ~= length(objframeIdTmp)
    frameIDLC = -1;
    return;
end

tmp = trajs{1};
adjFollocalX= tmp(:,1);
adjFollocalY= tmp(:,2);
adjFolframeId = tmp(:,3);
adjFolframeIdTmp = unique(adjFolframeId);

if isempty(adjFolframeId) == 1
    frameIDLC = -1;
    return;
end

stfrmId = max(objframeId(1),adjFolframeId(1));
enfrmId = min(objframeId(end),adjFolframeId(end));
indObj1 = find(objframeId == stfrmId);
indObj2 = find(objframeId == enfrmId );

indAdj1 = find(adjFolframeId == stfrmId);
indAdj2 = find(adjFolframeId == enfrmId );

xlist1 = objlocalX(indObj1:indObj2);
xlist2 = adjFollocalX(indAdj1:indAdj2);

if length(xlist1) ~= length(xlist2)
     frameIDLC = -1;
    return;
end
frmList = objframeId(indObj1:indObj2);
distance  = abs(xlist1-xlist2);
ind2 = find(distance<1.7);



frameIDLC = frmList(ind2(1)) ;

end