function [ features ] = extract_hirarc_hist(dataset, train_index, test_index)
%

%% Transform Color Space
data_hsv = trans_colorspace(dataset.dataset.data, 'HSV');

%% Generate Dense Grid
grids = generate_grid([128,48], [1,1], [1,1]);

%% Extract Local Features
feature_map = extract_locfeat( data_hsv, grids , 'color');

%% Dictionary Learning and Coding
feature_code  = learn_dic_code( feature_map, train_index, test_index, [8, 8, 8],'histogram');

%% Pooing 
feature_pooling{1} = pool_feature(feature_code, [8, 8], [4, 4 ], 'averpooling');
feature_pooling{2} = pool_feature(feature_pooling{1}, [3, 5], [1, 3 ], 'maxpooling');
feature_pooling{3} = pool_feature(feature_pooling{2}, [3, 3], [2, 2 ], 'maxpooling');
feature_pooling{4} = pool_feature(feature_pooling{3}, [4, 1], [2, 1], 'maxpooling');
%% Concanating to Global Feature
features = [];
for i=1:dataset.dataset.size
    feat = [];
    for iter_p = 1:4
        temp_feat = [];
        for j=1:size(feature_pooling{iter_p}{i},1)
        for k=1:size(feature_pooling{iter_p}{i},2)
            for l=1:size(feature_pooling{iter_p}{i},3)
                temp_feat = [temp_feat; reshape(feature_pooling{iter_p}{i}(j,k,l,:),[size(feature_pooling{iter_p}{i},4) 1])];
            end
        end
        end
        temp_feat = temp_feat/ sqrt(temp_feat'*temp_feat);
        feat = [feat;temp_feat];
    end
%     feat = feat/sqrt(feat'*feat);
     features = [features,feat];
end

end

