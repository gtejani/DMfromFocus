function [med_out] = wmf(depthmap, stitched_img, mask)
    S=double(rgb2gray(im2uint8(stitched_img/255)));  % stiched image as guide/weight
    D = double(depthmap); 
    [r,c] = size(S);
    med_out = zeros(r,c);
   
    ctr = ceil(mask/2);
    str = ctr - 1;
%   padding with zeros on all sides
    padded_S = padarray(S, [ctr,ctr], 'symmetric', 'both');
    padded_D = padarray(D, [ctr,ctr], 'symmetric', 'both');
    
    rowp = r + fix(mask/2);
    colp = c + fix(mask/2);
    
    for x = ctr:rowp - str - 1
        for y = ctr:colp - str - 1
            weight_selected = padded_S(x - str: x + str, y - str: y + str);
            window_selected = padded_D(x - str: x + str, y - str: y + str);

            W = weight_selected;
            D = window_selected;
            
            epsilon =1e-5;
            WSum = sum(W(:));
            W = W / (WSum+epsilon);
            
            % transformation of the input-matrices to line-vectors
            d = reshape(D',1,[]);
            w = reshape(W',1,[]);
            
            % sort the vectors
            A = [d' w'];
            ASort = sortrows(A,1);
            
            dSort = ASort(:,1)';
            wSort = ASort(:,2)';
            
            sumVec = [];    % cumulative sums of the weights
            for i = 1:length(wSort)
                sumVec(i) = sum(wSort(1:i));
            end
            
            wMed = [];
            j = 0;
            
            while isempty(wMed)
                j = j + 1;
                if max(sumVec)<0.5
                    wMed = dsort(1);
                else
                    if sumVec(j) >= 0.5
                        wMed = dSort(j);    % value of the weighted median
                        
                    end
                end
            end
            
            med_out(x,y)=wMed;
            
        end
    end
    med_out = label2rgb(uint8(med_out));
end