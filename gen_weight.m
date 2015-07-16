function [ weight_map ] = gen_weight( img_size)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
H = img_size(1);
W = img_size(2);

for i = 1:H
    for j=1:W
        weight_map(i,j) = exp(-(j-W/2)^2/(W^2/8));
    end
end

for i = 1:H
    weight_map(i,:) = weight_map(i,:) /sum(weight_map(i,:) );
end

end

