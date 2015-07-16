function [ dataset,  train_index, test_index, features] = VIPeR_feat(iter)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%% read dataset
dataset = load('.\dataset\VIPeR.mat');

%% Divide into training and testing 
train_index = [];
for i=1:size(dataset.dataset.train(:,iter),1)
    train_index = [train_index, find(dataset.dataset.ind_id == dataset.dataset.train(i,iter))];
end
test_index = [];
for i=1:size(dataset.dataset.test(:,iter),1)
    test_index = [test_index, find(dataset.dataset.ind_id == dataset.dataset.test(i,iter))];
end
  
%% extract feat
% features_hist  = extract_hirarc_hist(dataset, train_index, test_index);
% save('.\mat\feat_final_hist.mat','features_hist');
% load('.\mat\feat_final_hist.mat');
% features_hist1 = features_hist;
% load('.\mat\feat_final_hist_nrgb.mat');
% 
features_lbp  = extract_hirarc_lbp(dataset, train_index, test_index);
save('.\mat\feat_final_lbp.mat','features_lbp');
% load('.\mat\feat_final_rgb_lbp_sump_300_50_0d01.mat');

% features_hog  = extract_hirarc_hog(dataset, train_index, test_index);
% save('.\mat\feat_final_hog.mat','features_hog');
% load('.\mat\feat_final_rgb_hog_sump_300_50_0d01.mat');

% features_dsift  = extract_hirarc_dsift(dataset, train_index, test_index);
% save('.\mat\feat_final_dsift.mat','features_dsift');
% load('.\mat\feat_final_dsift.mat');

% features_joint_hist  = extract_hirarc_joint_hist(dataset, train_index, test_index);
% save('.\mat\feat_final_joint_hist.mat','features_joint_hist');
% load('.\mat\feat_final_joint_hist.mat');
% 
% features_salient_cn = extract_hirarc_salient_cn(dataset, train_index, test_index);
% save('.\mat\feat_final_salient_cn.mat','features_salient_cn');
% load('.\mat\feat_final_salient_cn.mat');

% load('.\mat\feat_final_hist_hsv_1x1_pixel_exp_0d125_maxp_10752_300_50_0d01.mat');
% features{1} = features_hist;

% load('.\mat\feat_final_hist_hsv_1x1_pixel_exp_0d125_maxp_10752_300_50_0d01.mat');
features{1} = features_lbp;
% load('.\mat\feat_final_yuv_lbp_sump_300_50_0d01.mat');
% features{2} = features_lbp;
% load('.\mat\feat_final_yuv_hog_sump_300_50_0d01.mat');
% features{3} = features_hog;
% load('.\mat\feat_final_hist_rgb_1x1_pixel_exp_0d125_maxp_10752_300_50_0d01.mat');
% features{4} = features_hist;
% load('.\mat\feat_final_hsv_hog_sump_45663_300_50_0d01.mat');
% features{5} = features_hog;
% load('.\mat\feat_final_salient_RGBcn1_RGB_sump.mat');
% features{6} = features_salient_cn;
end

