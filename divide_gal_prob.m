function [gallery, probe] = divide_gal_prob(iter,dataset, data_type, divide_type)
% input
% output

gallery.set = [];
probe.set = [];
switch divide_type
    case 'train'
        switch data_type
            case {'VIPeR','i-LIDS-VID','CUHK01'}
                % one pairs of cams
                cam_layout = randperm(2);
                for j=1:size(dataset.train(:,iter),1)
                    gal_ind_idx = find(dataset.ind_id == dataset.train(j,iter) & dataset.cam_id == cam_layout(1));
                    gal_ind_idx_idx = randperm(length(gal_ind_idx));
                    gal_ind_idx = gal_ind_idx(gal_ind_idx_idx);
                    gallery.set = [gallery.set,gal_ind_idx(1)];
                    prob_ind_idx = find(dataset.ind_id == dataset.train(j,iter) & dataset.cam_id == cam_layout(2));
                    probe.set = [probe.set,prob_ind_idx];
                end
                for j = 1:length(gallery.set)
                    gallery.id(j) = dataset.ind_id(gallery.set(j));
                end
                for j = 1:length(probe.set)
                    probe.id(j) = dataset.ind_id(probe.set(j));
                end
            case {'CUHK02','CUHK03'}
                % five pairs of cams
                cam_layout = [randperm(2),randperm(2)+2,randperm(2)+4,randperm(2)+6,randperm(2)+8];
                for j=1:size(dataset.train(:,iter),1)
                    gal_ind_idx = find(dataset.ind_id == dataset.train(j,iter) & (dataset.cam_id == cam_layout(1) ...
                        | dataset.cam_id == cam_layout(3) | dataset.cam_id == cam_layout(5) ...
                        | dataset.cam_id == cam_layout(7) | dataset.cam_id == cam_layout(9)));
                    gal_ind_idx_idx = randperm(length(gal_ind_idx));
                    gal_ind_idx = gal_ind_idx(gal_ind_idx_idx);
                    gallery.set = [gallery.set,gal_ind_idx(1)];
                    prob_ind_idx = find(dataset.ind_id == dataset.train(j,iter) & (dataset.cam_id == cam_layout(2) ...
                        | dataset.cam_id == cam_layout(4) | dataset.cam_id == cam_layout(6) ...
                        | dataset.cam_id == cam_layout(8) | dataset.cam_id == cam_layout(10)));
                    probe.set = [probe.set,prob_ind_idx];
                end
                for j = 1:length(gallery.set)
                    gallery.id(j) = dataset.ind_id(gallery.set(j));
                end
                for j = 1:length(probe.set)
                    probe.id(j) = dataset.ind_id(probe.set(j));
                end
            case 'PRID_2011'
                %
            otherwise
                %
                for j=1:size(dataset.train(:,iter),1)
                    train_ind_idx = find(dataset.ind_id == dataset.train(j,iter));
                    train_ind_idx_idx = randperm(length(train_ind_idx));
                    train_ind_idx = train_ind_idx(train_ind_idx_idx);
                    gallery.set = [gallery.set,train_ind_idx(1)];
                    probe.set = [probe.set,train_ind_idx(2:length(train_ind_idx))];
                end
                for j = 1:length(gallery.set)
                    gallery.id(j) = dataset.ind_id(gallery.set(j));
                end
                for j = 1:length(probe.set)
                    probe.id(j) = dataset.ind_id(probe.set(j));
                end
        end
    case 'test'
        switch data_type
            case {'VIPeR','i-LIDS-VID','CUHK01'}
                % one pairs of cams
                cam_layout = randperm(2);
                for j=1:size(dataset.test(:,iter),1)
                    gal_ind_idx = find(dataset.ind_id == dataset.test(j,iter) & dataset.cam_id == cam_layout(1));
                    gal_ind_idx_idx = randperm(length(gal_ind_idx));
                    gal_ind_idx = gal_ind_idx(gal_ind_idx_idx);
                    gallery.set = [gallery.set,gal_ind_idx(1)];
                    prob_ind_idx = find(dataset.ind_id == dataset.test(j,iter) & dataset.cam_id == cam_layout(2));
                    probe.set = [probe.set,prob_ind_idx];
                end
                for j = 1:length(gallery.set)
                    gallery.id(j) = dataset.ind_id(gallery.set(j));
                end
                for j = 1:length(probe.set)
                    probe.id(j) = dataset.ind_id(probe.set(j));
                end
            case {'CUHK02','CUHK03'}
                % five pairs of cams
                cam_layout = [randperm(2),randperm(2)+2,randperm(2)+4,randperm(2)+6,randperm(2)+8];
                for j=1:size(dataset.test(:,iter),1)
                    gal_ind_idx = find(dataset.ind_id == dataset.test(j,iter) & (dataset.cam_id == cam_layout(1) ...
                        | dataset.cam_id == cam_layout(3) | dataset.cam_id == cam_layout(5) ...
                        | dataset.cam_id == cam_layout(7) | dataset.cam_id == cam_layout(9)));
                    gal_ind_idx_idx = randperm(length(gal_ind_idx));
                    gal_ind_idx = gal_ind_idx(gal_ind_idx_idx);
                    gallery.set = [gallery.set,gal_ind_idx(1)];
                    prob_ind_idx = find(dataset.ind_id == dataset.test(j,iter) & (dataset.cam_id == cam_layout(2) ...
                        | dataset.cam_id == cam_layout(4) | dataset.cam_id == cam_layout(6) ...
                        | dataset.cam_id == cam_layout(8) | dataset.cam_id == cam_layout(10)));
                    probe.set = [probe.set,prob_ind_idx];
                end
                for j = 1:length(gallery.set)
                    gallery.id(j) = dataset.ind_id(gallery.set(j));
                end
                for j = 1:length(probe.set)
                    probe.id(j) = dataset.ind_id(probe.set(j));
                end
            case 'PRID_2011'
                %
            otherwise
                %
                for j=1:size(dataset.test(:,iter),1)
                    test_ind_idx = find(dataset.ind_id == dataset.test(j,iter));
                    test_ind_idx_idx = randperm(length(test_ind_idx));
                    test_ind_idx = test_ind_idx(test_ind_idx_idx);
                    gallery.set = [gallery.set,test_ind_idx(1)];
                    probe.set = [probe.set,test_ind_idx(2:length(test_ind_idx))];
                end
                for j = 1:length(gallery.set)
                    gallery.id(j) = dataset.ind_id(gallery.set(j));
                end
                for j = 1:length(probe.set)
                    probe.id(j) = dataset.ind_id(probe.set(j));
                end
        end
end




end

