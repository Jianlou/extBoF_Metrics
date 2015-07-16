function [ features_pca ] = reduce_dim_pca( train_index, test_index, features, dim)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
addpath('.\DimensionalityReduction\drtoolbox\');
addpath('.\DimensionalityReduction\drtoolbox\techniques\');
addpath('.\DimensionalityReduction\drtoolbox\gui\');

features_train = features(:,train_index);
features_test = features(:,test_index);

mean_feat_hist = mean(features_train,2);
features_train = features_train - repmat(mean_feat_hist,[1 size(features_train,2)]);
std2_feat_hist = std(features_train, 0, 2);
std2_feat_hist(find(std2_feat_hist == 0)) = 1;
features_train = features_train ./ repmat(std2_feat_hist, [1 size(features_train,2)]);

[feature_train_pca, map_hist] = compute_mapping(features_train','PCA',dim);

features_test = features_test - repmat(mean_feat_hist,[1 size(features_test,2)]);
features_test = features_test ./ repmat(std2_feat_hist, [1 size(features_test,2)]);
feature_test_pca = features_test' * map_hist.M;

rmpath('.\DimensionalityReduction\drtoolbox\');
rmpath('.\DimensionalityReduction\drtoolbox\techniques\');
rmpath('.\DimensionalityReduction\drtoolbox\gui\');

features_pca(train_index, :) = feature_train_pca;
features_pca(test_index, :) = feature_test_pca;
end

