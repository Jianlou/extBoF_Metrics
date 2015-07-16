function [ grids] = generate_grid(img_size, patch_size, step_size)
%

patch_rn = (img_size(1) - patch_size(1))/step_size(1) +1 ;
patch_cln = (img_size(2) - patch_size(2))/step_size(2) +1 ;

for i=1:patch_rn
    for j=1:patch_cln
        grids(i,j).row = 1 + (i-1)*step_size(1);
        grids(i,j).column = 1 + (j-1)*step_size(2);
        grids(i,j).width = patch_size(2);
        grids(i,j).height = patch_size(1);
    end
end

end

