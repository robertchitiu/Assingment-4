function [cMap] = Conductivity_Map (x0,x1,y0,y1, nx,ny,cond)

cMap = ones(nx,ny);
for i=1:nx 
    for j=1:ny
        if j>=x0 && j<=x1
            if i>=y1 || i <=y0
            cMap(i,j)=cond;
            end
        end
        
    end
end

end