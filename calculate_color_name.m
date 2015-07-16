function [color_name] = calculate_color_name(color_indexes, color_cube, color_codebook, color_space, kNN)

z_set = color_codebook;
alpha1 = 1;
alpha2 = 1;

for i = 1:color_indexes(1)
    for j = 1:color_indexes(2)
        for k=1:color_indexes(3)
            temp(1,:) = ((1/color_indexes(1))*(i-1)): 1/(color_indexes(1)*color_cube(1)) : ((1/color_indexes(1))*i);
            temp(2,:) = ((1/color_indexes(2))*(j-1)): 1/(color_indexes(2)*color_cube(2)) : ((1/color_indexes(2))*j);
            temp(3,:) = ((1/color_indexes(3))*(k-1)): 1/(color_indexes(3)*color_cube(3)) : ((1/color_indexes(3))*k);
            d_w_set = temp(:,1:(size(temp,2)-1));
            for l = 1:color_cube(1)
                for m = 1:color_cube(2)
                    for n = 1:color_cube(3)
                        w_set(:,(l-1)*color_cube(2)*color_cube(3) + (m-1)*color_cube(2) + n) =  [d_w_set(1,l);d_w_set(2,m);d_w_set(3,n)];
                    end
                end
            end
            w_set_u = w_set - repmat(mean(w_set, 2), [1 size(w_set,2)]);
            exp_w_d = exp(-alpha1 * diag(w_set_u'*w_set_u));
            temp_normalization = sum(exp_w_d);
            temp_normalization(find(temp_normalization == 0)) = 1;
            prob_w_d = exp_w_d/temp_normalization;
            
            for l = 1:size(z_set,2)
                temp_z_w_set = repmat(z_set(:,l), [1 size(w_set, 2)]) - w_set;
%                 z_w_set(l,:,:) = temp_z_w_set;
                dist_z_w_set(l, :) = diag(temp_z_w_set' * temp_z_w_set);
            end
            [sort_result, sort_index] = sort(dist_z_w_set);
            mask_kNN = zeros(size(dist_z_w_set));
            for l=1:size(dist_z_w_set,2)
                mask_kNN(sort_index(1:kNN,l),l) = 1;
            end
            
            dist_z_w_set = dist_z_w_set.*mask_kNN;
            temp_normalization = (repmat(sum(dist_z_w_set,1), [size(dist_z_w_set,1) 1]) - dist_z_w_set)/(kNN-1);
            temp_normalization(find(temp_normalization == 0)) = 1;
            exp_z_w = exp(-alpha2*dist_z_w_set./temp_normalization);
            exp_z_w = mask_kNN.* exp_z_w;
            temp_normalization = repmat(sum(exp_z_w,1), [size(exp_z_w,1) 1]);
            temp_normalization(find(temp_normalization==0)) = 1;
            exp_z_w = exp_z_w ./ temp_normalization;
            
            prob_z_d(i,j,k,:) = exp_z_w * prob_w_d;
        end
    end
end
color_name = prob_z_d;
fine_name = [color_space '_color_name_alp_1.mat'];
save(fine_name,'color_name');

end