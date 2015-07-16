function [ feature_code ] = learn_dic_code( feature_map, train, test, codeword_num, type)
%
%

featmap_train = feature_map(1,train);
featmap_test = feature_map(1,test);
featcode_train = {};
featcode_test = {};

switch type
    case 'histogram'       
        % generate codebook
        for m=1:size(codeword_num,2)
            codebook{m} = (1/codeword_num(m)) * [0:(codeword_num(m)-1)] + (1/codeword_num(m)) * (1/2);
        end
        
        % encode local feature        
        %optimized
        code_book_mex = {};
        for m=1:size(codeword_num,2)
            for i=1:codeword_num(m)
                code_book_mex{m}(:,:,i) = codebook{1}(i) * ones(size(feature_map{1},1), size(feature_map{1},2));
            end
        end
        
         for n=1:size(featmap_train, 2)
             for m=1:size(codeword_num,2)
                temp_map = repmat(featmap_train{n}(:,:,m,:), [1 1 codeword_num(m)]);
                diff = abs(code_book_mex{m} - temp_map);
                for i=1:size(featmap_train{n},1)
                    for j=1:size(featmap_train{n},2)
                    single_diff = reshape(diff(i,j,:), [codeword_num(m) 1]);
                    
%                     a = find(single_diff == min(single_diff));
%                     single_diff = 0*single_diff;
%                     single_diff(a(1)) = 1;
                    %0.125
                    single_diff = exp(-single_diff/0.125);    
%                     single_diff = exp(-single_diff);   
%                     [sort_diff, index_diff] = sort(single_diff,'descend');
%                     mask_diff = zeros(size(single_diff));
%                     mask_diff(index_diff(1:3)) = 1;
%                     single_diff = single_diff.* mask_diff;
                    
                    single_diff = single_diff/sum(abs(single_diff));
                    temp_featcode(i,j,m,:) = single_diff;
                    end       
                end
             end
              featcode_train{n} = temp_featcode;
         end

          for n=1:size(featmap_test, 2)
             for m=1:size(codeword_num,2)
                temp_map = repmat(featmap_test{n}(:,:,m,:), [1 1 codeword_num(m)]);
                diff = abs(code_book_mex{m} - temp_map);
                for i=1:size(featmap_test{n},1)
                    for j=1:size(featmap_test{n},2)
                    single_diff = reshape(diff(i,j,:), [codeword_num(m) 1]);
                    
%                     a = find(single_diff == min(single_diff));
%                     single_diff = 0*single_diff;
%                     single_diff(a(1)) = 1;
                    single_diff = exp(-single_diff/0.125);
%                     single_diff = exp(-single_diff);   
%                     [sort_diff, index_diff] = sort(single_diff,'descend');
%                     mask_diff = zeros(size(single_diff));
%                     mask_diff(index_diff(1:3)) = 1;
%                     single_diff = single_diff.* mask_diff;
                    
                    single_diff = single_diff/sum(abs(single_diff));
                    temp_featcode(i,j,m,:) = single_diff;
                    end       
                end
             end       
              featcode_test{n} = temp_featcode;
         end
        
    case 'joint_hist'
         % generate codebook
        temp_count = 0;
        for i=1:codeword_num(1)
            for j=1:codeword_num(2)
                for k=1:codeword_num(3)
                    temp_count = temp_count +1;
                    codebook{1}(1,temp_count) = (i - 1/2)/codeword_num(1);
                    codebook{1}(2,temp_count) = (j - 1/2)/codeword_num(2);
                    codebook{1}(3,temp_count) = (k - 1/2)/codeword_num(2);
                end
            end
        end
        
        % encode local feature
         for n=1:size(featmap_train, 2)
             temp_map = featmap_train{n};           
             for i = 1:size(codebook{1},2)        
                 codeword(1,1,:) = codebook{1}(:,i);              
                 code_book_mex = repmat(codeword,[size(temp_map,1) size(temp_map,2) 1]);   
                 temp_diff = (temp_map - code_book_mex).^2;
                 diff(:,:,i) = sqrt(sum(temp_diff, 3));
             end  
             for i=1:size(featmap_train{n},1)
                for j=1:size(featmap_train{n},2)
                single_diff = reshape(diff(i,j,:), [codeword_num(1)*codeword_num(2)*codeword_num(3) 1]);
                a = find(single_diff == min(single_diff));
%                 single_diff = 0*single_diff;
%                 single_diff(a(1)) = 1;
                temp_featcode(i,j,1,:) = a(1);
                end       
            end
             featcode_train{n} = temp_featcode;
         end
         
         for n=1:size(featmap_test, 2)
             temp_map = featmap_test{n};           
             for i = 1:size(codebook{1},2)        
                 codeword(1,1,:) = codebook{1}(:,i);              
                 code_book_mex = repmat(codeword,[size(temp_map,1) size(temp_map,2) 1]);   
                 temp_diff = (temp_map - code_book_mex).^2;
                 diff(:,:,i) = sqrt(sum(temp_diff, 3));
             end  
             for i=1:size(featmap_test{n},1)
                for j=1:size(featmap_test{n},2)
                single_diff = reshape(diff(i,j,:), [codeword_num(1)*codeword_num(2)*codeword_num(3) 1]);
                a = find(single_diff == min(single_diff));
%                 single_diff = 0*single_diff;
%                 single_diff(a(1)) = 1;
                temp_featcode(i,j,1,:) = a(1);
                end       
            end
             featcode_test{n} = temp_featcode;
         end
         
         
    case 'salient_colorname'
      
        color_space = 'LAB';
        % generate codebook
         codebook{1}=[[0 0 0]; [255 255 255]; [192 192 192]; [128 128 128]; 
                                  [255 0 0]; [128 0 0]; [0 255 0]; [0 128 0]; [0 0 255];
                                  [0 0 128]; [255 0 255]; [128 0 128]; [255 255 0]; 
                                  [128 128 0]; [0 255 255]; [0 128 128]]';           
          switch color_space
              case 'HSV'
                  temp(1,:,:) = uint8(codebook{1}');
                  temp = rgb2hsv(temp);
                  codebook{1} = reshape(temp, [size(temp,2) size(temp,3)])';
              case 'RGB'
                  codebook{1} =  im2double(uint8(codebook{1}));
              case 'normRGB'
                  codebook{1} =  im2double(uint8(codebook{1}));
                  temp_sum = sum(codebook{1},1);
                  temp_sum(find(temp_sum==0)) = 1;
                  codebook{1}  = codebook{1} ./ repmat(temp_sum, [size(codebook{1},1) 1]);
              case 'learnDIC'
                  codebook{1} = learn_scn_dic(featmap_train, codeword_num)';
              case 'YUV'
                  temp=  im2double(uint8(codebook{1}));
                  codebook{1} (1,:) = 0.299*temp(1,:) + 0.587*temp(2,:) + 0.114*temp(3,:);
                  codebook{1} (2,:) = (-0.147*temp(1,:) -0.289*temp(2,:) + 0.436*temp(3,:) + 0.436)/0.872;
                  codebook{1} (3,:) = (0.615*temp(1,:) - 0.515*temp(2,:) - 0.100*temp(3,:) + 0.615)/1.23;
              case 'LAB'                 
                  temp(1,:,:) = uint8(codebook{1}');
                  temp = rgb2lab(temp);
                  codebook{1} = reshape(temp, [size(temp,2) size(temp,3)])';
                  codebook{1}(1,:) = codebook{1}(1,:)/100;
                  codebook{1}(2,:) = (codebook{1}(2,:) + 128)/255;
                  codebook{1}(3,:) = (codebook{1}(3,:) + 128)/255;
          end
          
          % learn color name
          color_name = calculate_color_name([32, 32, 32],[8,8,8], codebook{1}, color_space,5);
%           load([color_space '_color_name_alp_1.mat']);
          
          % encode local feature
         for n=1:size(featmap_train, 2)
             temp_map = featmap_train{n};
             temp_map = fix(temp_map/(1/32));
             temp_map(find(temp_map == 0)) = 1;
             for i = 1:size(temp_map,1)
                 for j=1:size(temp_map,2)
                    temp_featcode(i,j,1,:) = color_name(temp_map(i,j,1),temp_map(i,j,2),temp_map(i,j,3),:);
                 end
             end
             featcode_train{n} = temp_featcode;
         end

         for n=1:size(featmap_test, 2)
             temp_map = featmap_test{n};
             temp_map = fix(temp_map/(1/32));
             temp_map(find(temp_map == 0)) = 1;
             for i = 1:size(temp_map,1)
                 for j=1:size(temp_map,2)
                    temp_featcode(i,j,1,:) = color_name(temp_map(i,j,1),temp_map(i,j,2),temp_map(i,j,3),:);
                 end
             end
             featcode_test{n} = temp_featcode;
         end
         
    case 'feat_encode'
        % dictionary learning
        word_num1 = 16;
        word_num2 = 32;
        featbags2{1} = [];
        featbags2{2} = [];
        featbags2{3} = [];
        for n=1:size(featmap_train,2)
            featbags1{1} = [];
            featbags1{2} = [];
            featbags1{3} = [];
            temp_map  = featmap_train{n};
            for i=1:size(temp_map,1)
                for j=1:size(temp_map,2)
                    featbags1{1} = [featbags1{1}, reshape(temp_map(i,j,1,:), [size(temp_map, 4) 1])];
                    featbags1{2} = [featbags1{2}, reshape(temp_map(i,j,2,:), [size(temp_map, 4) 1])];
                    featbags1{3} = [featbags1{3}, reshape(temp_map(i,j,3,:), [size(temp_map, 4) 1])];
                end
            end
            [IDX1, codebook1{1}] = kmeans(featbags1{1}', word_num1);    
            [IDX2, codebook1{2}] = kmeans(featbags1{2}', word_num1);
            [IDX3, codebook1{3}] = kmeans(featbags1{3}', word_num1); 
            featbags2{1} = [featbags2{1}; codebook1{1}];
            featbags2{2} = [featbags2{2};codebook1{2}];
            featbags2{3} = [featbags2{3}; codebook1{3}];
        end
        [IDX1, codebook{1}] = kmeans(featbags2{1}, word_num2);    
        [IDX2, codebook{2}] = kmeans(featbags2{2}, word_num2);
        [IDX3, codebook{3}] = kmeans(featbags2{3}, word_num2); 

end


% feature_code = [featcode_train featcode_test];
feature_code(:, train) = featcode_train;
feature_code(:, test) = featcode_test;

end

