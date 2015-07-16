function [ feature_pooling ] = pool_feature( feaures, pool_region, pool_stepsize, pool_type )
%
%
feature_pooling = {};
rn = (size(feaures{1},1) - pool_region(1))/pool_stepsize(1) + 1;
cln = (size(feaures{1},2) - pool_region(2))/pool_stepsize(2) + 1;

grids = generate_grid([size(feaures{1},1), size(feaures{1},2)], pool_region,pool_stepsize);
weight_maps = gen_weight([size(feaures{1},1), size(feaures{1},2)]);

switch pool_type
    case 'averpooling'
        for n=1:size(feaures,2)
            temp_feat = feaures{n};
            for i=1:rn
                for j=1:cln
                    grid = grids(i,j);
                    region = temp_feat(grid.row:(grid.row+grid.height-1), grid.column:(grid.column+grid.width-1), :,:);
                    temp_sum = zeros(size(region,3),size(region,4));
                    for k1=1:size(region,1)
                        for k2=1:size(region,2)
                            temp_sum = temp_sum + reshape(region(k1,k2,:,:),[size(region,3),size(region,4)]);
                        end
                    end
                    normalization = repmat(sum(abs(temp_sum),2),[1 size(temp_sum,2)]);
                    normalization(find(normalization==0)) = 1;
                    temp_sum = temp_sum./normalization;
                    temp_pooling(i,j,:,:) = temp_sum(:,:);     
                end
            end
            feature_pooling{n} = temp_pooling;
        end
        
    case 'maxpooling'
        for n=1:size(feaures,2)
            temp_feat = feaures{n};
            for i=1:rn
                for j=1:cln
                    grid = grids(i,j);
                    region = temp_feat(grid.row:(grid.row+grid.height-1), grid.column:(grid.column+grid.width-1), :,:);
                    temp_max = zeros(size(region,1)*size(region,2),size(region,3),size(region,4));
                    temp_count = 0;
                    for k1=1:size(region,1)
                        for k2=1:size(region,2)
                            temp_count = temp_count +1;
                            temp_max(temp_count, :,:) = reshape(region(k1,k2,:,:),[size(region,3),size(region,4)]);
                        end
                    end
                    maxp = reshape(max(temp_max , [], 1), [size(region,3),size(region,4)]);
                    normalization = repmat(sum(abs(maxp),2),[1 size(maxp,2)]);
                    normalization(find(normalization == 0)) = 1;
                    maxp = maxp./normalization;
                    temp_pooling(i,j,:,:) = maxp(:,:);     
                end
            end
            feature_pooling{n} = temp_pooling;
        end
        
    case 'averpooling2'
        for n=1:size(feaures,2)
            temp_feat = feaures{n};
            for i=1:rn
                for j=1:cln
                    grid = grids(i,j);
                    region = temp_feat(grid.row:(grid.row+grid.height-1), grid.column:(grid.column+grid.width-1));
                    temp_sum = zeros(1, 512);
                    for k1=1:size(region,1)
                        for k2=1:size(region,2)
                            temp_sum(region(k1,k2)) = temp_sum(region(k1,k2)) + 1;
                        end
                    end
                    normalization = repmat(sum(abs(temp_sum),2),[1 size(temp_sum,2)]);
                    normalization(find(normalization == 0)) = 1;
                    temp_sum = temp_sum./normalization;
                    temp_pooling(i,j,:,:) = temp_sum(:,:);     
                end
            end
            feature_pooling{n} = temp_pooling;
        end
    case 'averpooling3'
        for n=1:size(feaures,2)
            temp_feat = feaures{n};
            for i=1:rn
                for j=1:cln
                    grid = grids(i,j);
                    region = temp_feat(grid.row:(grid.row+grid.height-1), grid.column:(grid.column+grid.width-1), :,:);
                    weight_map = weight_maps(grid.row:(grid.row+grid.height-1), grid.column:(grid.column+grid.width-1));
                    temp_sum = zeros(size(region,3),size(region,4));
                    for k1=1:size(region,1)
                        for k2=1:size(region,2)
                            temp_sum = temp_sum + weight_map(k1,k2)*reshape(region(k1,k2,:,:),[size(region,3),size(region,4)]);
                        end
                    end
                    normalization = repmat(sum(abs(temp_sum),2),[1 size(temp_sum,2)]);
                    normalization(find(normalization == 0)) = 1;
                    temp_sum = temp_sum./normalization;
                    temp_pooling(i,j,:,:) = temp_sum(:,:);     
                end
            end
            feature_pooling{n} = temp_pooling;
        end
        
end

end

