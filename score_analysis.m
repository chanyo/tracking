clear all;
clc;
close all;

dir_name = './overlaid-test/';
fname = dir(sprintf('%s*.png', dir_name));


% TRUE -> white exist
% False -> no white 

mkdir( sprintf('%sTP', dir_name));
mkdir( sprintf('%sTN', dir_name));
mkdir( sprintf('%sFP', dir_name));
mkdir( sprintf('%sFN', dir_name));

TP = 0; TN = 0;
FP = 0; FN = 0;
for i=1:length(fname)
    fprintf('%d/%d =============\n', i, length(fname));
    I = imread(sprintf('%s%s',dir_name,fname(i).name));
    
    mask = uint8(zeros(size(I,1),size(I,2)));
    mask(find(I(:,:,1) == 255 & I(:,:,2) == 255 & I(:,:,3) == 255)) = 1;
    
    mask_pred = uint8(zeros(size(I,1),size(I,2)));
    mask_pred(find(I(:,:,1) == 255 & I(:,:,2) == 255 & I(:,:,3) == 0)) = 1;
    
    mask = bwareaopen(bwconvhull(mask),100);
    mask_pred = bwareaopen(bwconvhull(mask_pred),100);
    
   
    s1 = regionprops(mask, 'BoundingBox');
    if length(find(mask > 0)) > 0 & length(find (mask > 0 & mask_pred > 0)) > 0% TP
        movefile(sprintf('%s%s',dir_name,fname(i).name), sprintf('%sTP/%s', dir_name, fname(i).name));
        TP = TP + 1;
    end
    
    if length(find(mask > 0)) > 0 & length(find (mask > 0 & mask_pred > 0)) == 0 % FN
        movefile(sprintf('%s%s',dir_name,fname(i).name), sprintf('%sFN/%s', dir_name, fname(i).name));
        FN = FN + 1;
    end
    
    if length(find(mask > 0)) == 0 & length(find(mask_pred > 0)) > 0 % FP
        movefile(sprintf('%s%s',dir_name,fname(i).name), sprintf('%sFP/%s', dir_name, fname(i).name));
        FP = FP + 1;
    end
     
   
    if length(find(mask > 0)) == 0 & length(find(mask_pred > 0)) == 0 % TN
        movefile(sprintf('%s%s',dir_name,fname(i).name), sprintf('%sTN/%s', dir_name, fname(i).name));
        TN = TN + 1;
    end 
end