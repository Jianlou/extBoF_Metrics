clear all;
clc;
close all;


for i=1:5
    %% Features
    [ dataset,  train_index, test_index, features] = VIPeR_feat(i);

    %% Dimensionality Reduction
    for j=1:size(features,2)
            features_pca{j} = reduce_dim_pca( train_index, test_index, features{j}(:,:), 300);
    end
%     features_pca = features(:,:)';

   %% divide into train and test
    label_train = dataset.dataset.ind_id(train_index);
    for j=1:size(features,2)
        feature_train{j} = features_pca{j}(train_index, :)';
    end

    label_test = dataset.dataset.ind_id(test_index);
    for j=1:size(features,2)
        feature_test{j} = features_pca{j}(test_index, :)'; 
    end
   
    %% divide into gallery(one of all) and probe(others), single shot mode
    [gallery, probe] = divide_gal_prob(i,dataset.dataset,'VIPeR','test');
    
    %% Metric Learning
    switch 'AVG_Comb'
        case 'EU_DIST'
                dist = cal_eu_dist(features_pca{1}', gallery, probe);
        case 'LADF_DIST'
                whole_train = [feature_train{1};label_train];
                whole_test = [feature_test{1};label_test];
                dist = cal_ladf_dist(features_pca{1}',whole_train,whole_test,gallery, probe);
        case 'LDA_DIST'
                whole_train = [feature_train{1};label_train]';
                dist = cal_lda_dist(features_pca{1}, whole_train, gallery, probe, 35);
        case 'LFDA_DIST'
                whole_train = [feature_train{1};label_train]';
                dist = cal_lfda_dist(features_pca{1}, whole_train, gallery, probe, 35, 1);
        case 'KLFDA_DIST'
            for j=1:size(features,2)
                whole_train{j} = [feature_train{j};label_train]';
                dist_n{j} = cal_klfda_dist(features_pca{j}, whole_train{j}, gallery, probe, 50, 1, 0.01);
                dist_n{j} = dist_n{j}  - repmat(min(dist_n{j}),[size(dist_n{j},1) 1]);
                dist_n{j} = dist_n{j} ./ repmat(max(dist_n{j}),[size(dist_n{j},1) 1]);
            end
%             alpha1 = 1.0;
%             alpha2 = 0.3;
%             alpha3 =0.6;
%             alpha4 =0;
%             alpha5 = 0;
%             alpha6 =0.2;
%             dist = alpha1*dist_n{1} + alpha2*dist_n{2} + alpha3*dist_n{3};
            dist = alpha1*dist_n{1};
            
        case 'AVG_Comb'
            for j=1:size(features,2)
                whole_train{j} = [feature_train{j};label_train]';
            end
            dist = cal_avgcomb_dist(features_pca, whole_train, gallery, probe, 50, 1, 0.01);
            
    end
    %% Evaluate    
    
    [order_dist, order_idx] = sort(dist);
    CMC_temp = zeros(length(gallery.set),1);
    for j=1:length(probe.set)
        ture_match = find(gallery.id == probe.id(j));
        rank = find(order_idx(:,j) == ture_match);
        CMC_temp(rank) = CMC_temp(rank) + 1;
    end
    for j = length(gallery.set):-1:1
        CMC_temp(j) = sum(CMC_temp(1:j));
    end
    CMC_temp = CMC_temp/length(probe.set);
    CMC(:,i) = CMC_temp;
    CMC_mean = mean(CMC,2);
end


