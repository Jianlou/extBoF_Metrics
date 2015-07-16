function [ dist ] = cal_lda_dist( features, whole_train, gallery, probe, dims)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
addpath('.\DimensionalityReduction\drtoolbox\techniques');

%   train
[mappedA, mapping] = lda(whole_train(:,1:end-1), whole_train(:,end), dims);
mapping.name = 'LDA';

faetures_lda = features * mapping.M;

dist = cal_eu_dist( faetures_lda', gallery, probe );

rmpath('.\DimensionalityReduction\drtoolbox\techniques');
end

