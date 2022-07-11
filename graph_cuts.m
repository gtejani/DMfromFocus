function [GC] = graph_cuts(Mf,N,D_threshold, S_threshold)
cd 'graphcut'
Mf = double(Mf);
[r,c] = size(Mf);

data_cost = zeros(r, c, N);     
smooth_cost = zeros(N,N);           

for i = 1:N
    data_cost(:,:,i) = min(D_threshold,abs(Mf-i));      
    for j = 1:N
        if(i~=j) 
            smooth_cost(i,j) = min(abs(i-j),S_threshold); 
            smooth_cost(j,i) = smooth_cost(i,j); 
        end
    end
end

[gch] = GraphCut('open', data_cost, smooth_cost);
[gch GC] = GraphCut('expand',gch);
gch = GraphCut('close', gch);

cd ..

end
 