function [df] = depth_ref(img) % takes depthmap as input 
%  create mask of size 3x3
mask = 3;
I = double(label2rgb(img));
W = ones(mask);
ctr = ceil(mask/2);
W(ctr, ctr) = 10;
W_sum = sum(W(:));
W = W./W_sum; 
% image is padded with zeros on all sides              
image_padded = padarray(I,[1,1],'symmetric','both');
[r, c, ~] = size(I);
row_pad = r + 2;
col_pad = c + 2;
% filter applied on depth map
for x = ctr:row_pad - 2
    for y = ctr:col_pad - 2
        patch = image_padded(x - 1: x + 1, y - 1: y + 1);
        s = W.*patch;
        med = median(s(:))*W_sum; 
        I(x,y) = med;
    end
end
% refined depth map
df = uint8(I);

end