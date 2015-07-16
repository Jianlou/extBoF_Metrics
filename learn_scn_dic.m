function [code_book] = learn_scn_dic(featmap_train, codeword_num)
    codeword_set = [];
    for i =1:size(featmap_train,2)
        featmap = reshape(featmap_train{i}, [size(featmap_train{i},1)*size(featmap_train{i},2) size(featmap_train{i},3)]);
        [IDX1, C1]  = kmeans(featmap, codeword_num);
        codeword_set = [codeword_set;C1];
    end
    [IDX2, code_book]  = kmeans(codeword_set, codeword_num);
    
end