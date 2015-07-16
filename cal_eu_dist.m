function [ dist ] = cal_eu_dist( features, gallery, probe )
%input
%output

gallery.feature = features(:,gallery.set);
probe.feature = features(:,probe.set);

%(x_i)^t*(x_i)
gallery_i2 = repmat(diag(gallery.feature'*gallery.feature),[1 length(probe.set)]);
%(y_j)^t*(y_j)
probe_j2 = repmat(diag(probe.feature'*probe.feature)',[length(gallery.set) 1]);
%(x_i)^t(y_j)
galery_probe_ij = gallery.feature'*probe.feature;
dist = sqrt(gallery_i2 + probe_j2 - 2*galery_probe_ij);


end

