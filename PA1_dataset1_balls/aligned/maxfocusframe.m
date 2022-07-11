function [Mp, Mf] = maxfocusframe(fm)

    [r,c,ch,~] = size(fm);
    Mp = zeros(r,c);
    Mf = zeros(r,c);   
    for i = 1:r
        for j = 1:c
            c = zeros(3,2);
            [c(1,1),c(1,2)] = max(fm(i,j,1,:));
            [c(2,1),c(2,2)] = max(fm(i,j,2,:));
            [c(3,1),c(3,2)] = max(fm(i,j,3,:));
            [Mp(i,j), ind] = max(c(:,1));
            Mf(i,j) = c(ind,2);
        end
    end
            
%             
%             maxframe = 1;
%             temp = -100;
%             for k = 1:length(fm)
%                 maxfoc = max(fm{k}(i,j),temp);
%                 if maxfoc > temp
%                     maxframe = k;
%                 end
%                 temp = maxfoc;
%             end
%             Mp(i,j) = maxfoc;
%             Mf(i,j) = maxframe;
%         end
%     end        
%             
% end