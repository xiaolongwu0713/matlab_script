function [tk_train, tk_test]  = Stratified_KFold(Label, k, repeatTs, classVector)

% Stratified implementation of k-fold cross validation.
% input:
%     Label: Label set, the number of labels of each class should be equal.
%     k: returns randomly generated indices for a k-fold cross-validation.
%     repeatTs: Repeat times of cross validation.
%     classVector: class vector.
% output:
%     tk_train: subset of train.
%     tk_test: subset of test.                @210312.

classInx = [];
Num = 1:length(Label);
for i = 1:length(classVector)
    classInx = cat(1, classInx, Num(Label == classVector(i)));
end

tk_train = [];tk_test = [];

for i = 1: repeatTs
    nd_train = [];nd_test = [];
    for ii = 1:length(classVector)
        t = crossvalind('Kfold', size(classInx, 2) , k);
        st_train = [];st_test = [];
        for iii = 1: k
            st_train(iii,:) = classInx(ii, t ~= iii);
            st_test(iii,:) = classInx(ii, t == iii);
        end
        nd_train = cat(2, nd_train, st_train);
        nd_test = cat(2, nd_test, st_test);
    end
    tk_train = cat(1, tk_train, nd_train);
    tk_test = cat(1, tk_test, nd_test);
end
