function [a, sen, spec, rec, pre, f] = computePerformanceStats(class_id, conMat)
    iClass=class_id;
    TP = conMat(iClass,iClass);
    FP = sum(conMat(:,iClass)) - conMat(iClass,iClass);
    FN = sum(conMat(iClass,:),2) - conMat(iClass,iClass);
    TN = sum(conMat(:)) - (TP+FN+FP);
    
    a = (TP+TN)/(TP+TN+FP+FN);
    sen = TP/(TP+FN);
    spec = TN/(TN+FP);
    rec = TP/(TP+FN); 
    pre = TP/(TP+FP);
    f = 2*pre*rec/(pre + rec);
end