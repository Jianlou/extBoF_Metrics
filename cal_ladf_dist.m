function [ dist ] = cal_ladf_dist(features, whole_train, whole_test, gallery, probe)
% input
% output

feature_train = whole_train(1:(size(whole_train,1)-1),:);
label_train = whole_train(size(whole_train,1),:);

addpath('./LADF/');
addpath('./LADF/code/');

[A, B, b] = svmml_learn_full_final(feature_train', label_train', 480, 0, 0, 20000, 1, []);

f1 = 0.5*repmat(diag(features'*A*features),[1,size(features,2)]);
f2 = 0.5*repmat(diag(features'*A*features)',[size(features,2),1]);
f3 = features'*B*features;
all_dist = f1+f2-f3+b;

dist = all_dist(gallery.set,probe.set);

rmpath('./LADF/');
rmpath('./LADF/code/');


end

