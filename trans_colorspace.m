function [ target_data ] = trans_colorspace( source_data, target_type )
% Transform original data to target color space
% target_data = 'normRGB' or 'RetinexHSV'


switch target_type
    case 'normRGB'
       for i=1:size(source_data,4)
           target_data(:,:,:,i)  = normalize_RGB(source_data(:,:,:,i));
       end
    case 'RetinexHSV'
        addpath('.\bin');
        for i=1:size(source_data,4)
            renx_rgb= Retinex(source_data(:,:,:,i));
            target_data(:,:,:,i) = rgb2hsv(renx_rgb);
        end
        rmpath('.\bin'); 
    case 'HSV'
        for i=1:size(source_data,4)
            renx_rgb= source_data(:,:,:,i);
            target_data(:,:,:,i) = rgb2hsv(renx_rgb);
        end
    case 'RGB'
        for i=1:size(source_data,4)
            renx_rgb= source_data(:,:,:,i);
            target_data(:,:,:,i) = im2double(renx_rgb);
        end
    case 'GRAY'
        for i=1:size(source_data,4)
            renx_rgb=source_data(:,:,:,i);
            target_data(:,:,:,i) = rgb2gray(renx_rgb);
        end
    case 'RetinexRGB'
        addpath('.\bin');
        for i=1:size(source_data,4)
            renx_rgb= uint8(Retinex(source_data(:,:,:,i)));
            target_data(:,:,:,i) = im2double(renx_rgb);
        end
        rmpath('.\bin'); 
    case 'YUV'
        for i=1:size(source_data,4)
            img_rgb= source_data(:,:,:,i);
            target_data(:,:,:,i) = rgb2yuv(img_rgb);
        end
    case 'LAB'
        for i=1:size(source_data,4)
            img_rgb= source_data(:,:,:,i);
            img_lab = rgb2lab(img_rgb);
            img_lab(:,:,1) = img_lab(:,:,1) /100;
            img_lab(:,:,2) = (img_lab(:,:,2)+128) /255;
            img_lab(:,:,3) = (img_lab(:,:,3)+128) /255;
            target_data(:,:,:,i) = img_lab;
        end
end   


    function [nrgb_img] = normalize_RGB(rgb_img)
    % transform RGB to notmalized RGB
    double_rgb = im2double(rgb_img);
    sum_img = double_rgb(:,:,1) + double_rgb(:,:,2) + double_rgb(:,:,3);
    sum_img(find(sum_img==0)) = 1;
        for j=1:3
            nrgb_img(:,:,j) = double_rgb(:,:,j)./sum_img;
        end
    end

    function [yuv_img] = rgb2yuv(img_ori)
        rgb_img = im2double(img_ori);
        yuv_img(:,:,1) = 0.299*rgb_img(:,:,1) + 0.587*rgb_img(:,:,2) + 0.114*rgb_img(:,:,3);
        yuv_img(:,:,2) = (-0.147*rgb_img(:,:,1) -0.289*rgb_img(:,:,2) + 0.436*rgb_img(:,:,3) + 0.436)/0.872;
        yuv_img(:,:,3) =(0.615*rgb_img(:,:,1) - 0.515*rgb_img(:,:,2) - 0.100*rgb_img(:,:,3) + 0.615)/1.23;
    end

end



