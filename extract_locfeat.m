function [ feature_map ] = extract_locfeat( dataset, grids , feat_type)
%
%

switch feat_type
    case 'color'
        for n=1:size(dataset,4)
            img = dataset(:,:,:,n);
        % optimized
        feature_map{n} = img;
        end
    case 'lbp_desc'
%         mapping = getmapping(8,'u2'); 
        for n=1:size(dataset,4)
            img = dataset(:,:,:,n);
        % optimized
            for i=1:size(img,3)
                temp(:,:,i,:) = double(vl_lbp(single(img(:,:,i)), grids(1,1).width));
            end
            feature_map{n} = reshape(temp,[size(temp,1), size(temp,2), size(temp,3), size(temp,4)]);
        end
    case 'hog_desc'
        for n=1:size(dataset,4)
            img = dataset(:,:,:,n);
        % optimized
            for i=1:size(img,3)
                temp(:,:,i,:) = double(vl_hog(single(img(:,:,i)), grids(1,1).width));
            end
            feature_map{n} = reshape(temp,[size(temp,1), size(temp,2), size(temp,3), size(temp,4)]);
        end
        
    case 'dsift_desc'
        for n=1:size(dataset,4)
            img = dataset(:,:,:,n);
        % optimized
            for i=1:size(img,3)
                [f, d] = vl_dsift(single(img(:,:,i)), 'step', 4);
                for j=1:size(d,2)
                    temp((f(2,j) - 5.5)/4+1, (f(1,j) - 5.5)/4+1, i, :) = double(d(:,j));
                end
            end
            feature_map{n} = reshape(temp,[size(temp,1), size(temp,2), size(temp,3), size(temp,4)]);
        end
end

% pixel value
    function  [ feature_desc ] = pixelvalue_desc(patch)
        feature_desc = patch;
    end
end

