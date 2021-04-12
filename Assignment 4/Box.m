
function [x1,x2,y1,y2]=Box(x1,x2,y1,y2) 

x = [x1, x2, x2, x1, x1];
y = [y1, y1, y2, y2, y1];
figure (1)
plot(x, y, 'y-', 'LineWidth', 1);
hold on;
end
