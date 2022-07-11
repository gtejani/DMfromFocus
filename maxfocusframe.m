function [Mp, Mf] = maxfocusframe(fm)

    [r,c,ch,~] = size(fm);
    Mp = zeros(r,c);
    Mf = zeros(r,c);   
    for i = 1:r
        for j = 1:c
            d = zeros(3,2);
            [d(1,1),d(1,2)] = max(fm(i,j,1,:));
            [d(2,1),d(2,2)] = max(fm(i,j,2,:));
            [d(3,1),d(3,2)] = max(fm(i,j,3,:));
            [Mp(i,j), ind] = max(d(:,1));
            Mf(i,j) = d(ind,2);
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