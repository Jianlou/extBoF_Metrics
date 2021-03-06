function [ features ] = extract_hirarc_dsift(dataset, train_index, test_index)
%

%% Transform Color Space
data = trans_colorspace(dataset.dataset.data, 'GRAY');

%% Generate Dense Grid
grids = generate_grid([128,48], [16,16], [8,8]);

%% Extract Local Features
feature_map = extract_locfeat( data, grids , 'dsift_desc');

%% Dictionary Learning and Coding
% feature_code  = learn_dic_code( feature_map, train_index, test_index, [8, 8, 8],'histogram');
feature_code = feature_map;

%% Pooing 
feature_pooling{1} = pool_feature(feature_code, [1, 1], [1, 1 ], 'averpooling');%30*10
feature_pooling{2} = pool_feature(feature_pooling{1}, [2, 4], [1, 3 ], 'averpooling');%29*3
feature_pooling{3} = pool_feature(feature_pooling{2}, [3, 3], [2, 2 ], 'averpooling');%14*1
feature_pooling{4} = pool_feature(feature_pooling{3}, [4, 1], [2, 1], 'averpooling');%6*1
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
        normalization = sqrt(temp_feat'*temp_feat);
        normalization(find(normalization == 0)) = 1;
        temp_feat = temp_feat/ normalization;
        feat = [feat;temp_feat];
    end
     features = [features,feat];
end

end

