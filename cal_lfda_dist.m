function [dist] = cal_lfda_dist( features, whole_train, gallery, probe, dims, kNN)

addpath('.\LFDA');

[T,Z]=LFDA(whole_train(:,1:end-1)', whole_train(:,end), dims ,'orthonormalized',kNN);

features_lfda = features * T;

dist = cal_eu_dist( features_lfda', gallery, probe );

rmpath('.\LFDA');
end