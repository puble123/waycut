function [h] = DrawingDir(mesh,way,sway)

fig = figure("Name","DrawingDirection");
ax = axes(fig);
grid(ax,"on");
box(ax,"on");
axis(ax,GetBoundaryBox(mesh.hvc));
pbaspect(ax,[1,1,1]);

Nd = length(way);

c = ["r","g","b","c","y","m"];

for i = 1:Nd
    
    h(i) = patch(ax,"Faces",[],"Vertices",mesh.hvc);
    set(h(i),"FaceColor",c(i));

end


UpdateDir(h,mesh,way,sway);
drawnow();

end