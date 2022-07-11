% creates all-in-focus image: takes input as focal map and aligned images 
function image = stitching(Mf, wimages) 
    [r,c] = size(Mf);
    image = zeros(r,c,3);
    for i = 1:r
        for j = 1:c
            image(i,j,1) = wimages(i,j,1,Mf(i,j));
            image(i,j,2) = wimages(i,j,2,Mf(i,j));
            image(i,j,3) = wimages(i,j,3,Mf(i,j));
        end
    end    
end