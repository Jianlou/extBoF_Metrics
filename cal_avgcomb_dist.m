function [dist] = cal_avgcomb_dist( features, whole_train, gallery, probe, dims, kNN, reg)

addpath('.\KLFDA');

for j=1:size(features,2)
    X{j} = whole_train{j}(:,1:end-1)';
end
Y = whole_train{1}(:,end);


sigma = 100;
for j=1:size(features,2)
    Xi2 = repmat(diag(X{j}'*X{j}), [1 size(X{j}, 2)]);
    Xj2 = repmat(diag(X{j}'*X{j})', [size(X{j}, 2) 1]);
    distance = Xi2 + Xj2 - 2*X{j}'*X{j};
    X_kernel{j} = exp(-distance./(2*sigma^2));
end
alpha1 = 1.0;
alpha2 = 0.3;
alpha3 =0.6;
X_kernel_sum = alpha1*X_kernel{1} +alpha2*X_kernel{2} + alpha3*X_kernel{3};

[T,Z]=KLFDA(X_kernel_sum, Y, dims ,'orthonormalized',kNN, reg);

for j=1:size(features,2)
    Xi2 = repmat(diag(X{j}'*X{j}), [1 size(features{j}, 1)]);
    Xj2 = repmat(diag(features{j}*features{j}')', [size(X{j}, 2) 1]);
    distance = Xi2 + Xj2 - 2*X{j}'*features{j}';
    X_kernel_new{j} = exp(-distance./(2*sigma^2));
end

X_kernel_new_sum = alpha1*X_kernel_new{1} + alpha2*X_kernel_new{2} + alpha3*X_kernel_new{3};

features_klfda = X_kernel_new_sum' * T;

dist = cal_eu_dist( features_klfda', gallery, probe );

rmpath('.\KLFDA');
end