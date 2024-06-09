function [b] = DrawingBar(mesh,way,sway,val)

Nd = length(way);

c = ["r","g","b","c","y","m"];

[vert,conn] = GetDefualtBar(mesh);

limits = GetBoundaryBox(mesh.hvc);

for i = 1:Nd

    f(i) = figure();
    a(i) = axes(f(i));

    a(i).XLim = limits([1,2]);
    a(i).YLim = limits([3,4]);
    a(i).ZLim = [0,3.5];
    a(i).Visible = "off";

    a(i).View = [30,60];
    b(i) = patch(a(i),"vertices",vert,"Faces",conn);
    set(b(i),"FaceColor",c(i));

end

UpdateBar(b,mesh,way,sway,val);
drawnow();

end