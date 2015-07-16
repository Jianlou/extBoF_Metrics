function [dist] = cal_klfda_dist( features, whole_train, gallery, probe, dims, kNN, reg)

addpath('.\KLFDA');

X = whole_train(:,1:end-1)';
Y = whole_train(:,end);

switch 'RBF_Guassian_kernel'
    case 'Linear_kernel'
            X_kernel = X'*X;
    case 'RBF_Guassian_kernel'
            sigma = 100;
            Xi2 = repmat(diag(X'*X), [1 size(X, 2)]);
            Xj2 = repmat(diag(X'*X)', [size(X, 2) 1]);
            distance = Xi2 + Xj2 - 2*X'*X;
            X_kernel = exp(-distance./(2*sigma^2));
    case 'RBF_CHI2_kernel'
            for i=1:size(X,2)
                X_i = repmat(X(:,i), [1 size(X,2)]);
                Xsub_i = (X - X_i ).^2;
                Xsum_i = (X + X_i );
                Xsum_i(find(Xsum_i==0)) = 1;
                X_kernel(:, i) = 1 - sum(2*Xsub_i./Xsum_i,1);
            end
%             X_kernel = exp(-X_kernel);

end

[T,Z]=KLFDA(X_kernel, Y, dims ,'orthonormalized',kNN, reg);


switch 'RBF_Guassian_kernel'
    case 'Linear_kernel'
            X_kernel_new = X'*features';
    case 'RBF_Guassian_kernel'
            sigma = 100;
            Xi2 = repmat(diag(X'*X), [1 size(features, 1)]);
            Xj2 = repmat(diag(features*features')', [size(X, 2) 1]);
            distance = Xi2 + Xj2 - 2*X'*features';
            X_kernel_new = exp(-distance./(2*sigma^2));
    case 'RBF_CHI2_kernel'
             F = features';
            for i=1:size(F,2)
                F_i = repmat(F(:,i), [1 size(X,2)]);
                Xsub_i = (F_i - X).^2;
                Xsum_i = (F_i +X);
                Xsum_i(find(Xsum_i==0)) = 1;
                X_kernel_new(:,i) = 1 - sum(2*Xsub_i./Xsum_i,1);
            end
%             X_kernel_new = exp(-X_kernel_new);

end

features_klfda = X_kernel_new' * T;

dist = cal_eu_dist( features_klfda', gallery, probe );

rmpath('.\KLFDA');
end