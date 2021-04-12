function [Ex,Ey,Vmap] = E_field_J (nx,ny,cMap,V)

Vmap =zeros(nx,ny);
for i=1:nx %%Converting V to matrix to plot
    for j=1:ny
        n = j+(i-1)*ny;
        Vmap(i,j) = V(n); 
    end
end


for i=1:nx %Electric Field calculation
    for j=1:ny
        if i==1
            Ex(i,j) = (Vmap(i+1,j) - Vmap(i,j));
        elseif i==nx
            Ex(i,j) = (Vmap(i,j) - Vmap(i-1,j));
        else
            Ex(i,j) = (Vmap(i+1,j) - Vmap(i-1,j)) * 0.5;
        end 
        
        if j==1
            Ey(i,j) = (Vmap(i,j+1) - Vmap(i,j));
        elseif j==ny
            Ey(i,j) = (Vmap(i,j) - Vmap(i,j-1));
        else
            Ey(i,j) = (Vmap(i,j+1) - Vmap(i,j-1)) * 0.5;
        end 
        
    end
end
Ex = -Ex;
Ey = -Ey;
FlowX = cMap .* Ex;
FlowY = cMap .* Ey;


end