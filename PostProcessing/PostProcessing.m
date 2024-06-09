function [h,b] = PostProcessing(mesh,Ie,xval,way,width,gtol)

% Post Processing
[~,sway] = DecisionDirection1(mesh,Ie,xval,way);
[xval] = ConvertDir2Solution(mesh,Ie,sway,way);
[val,~] = DecisionDirection1(mesh,Ie,xval,way);

% 색깔 그래프
[h] = DrawingDir(mesh,way,sway);

% 바 그래프
[b] = DrawingBar(mesh,way,sway,val);

% 해칭 그래프
fig2 = figure("Name","Hatching");
ax2 = axes(fig2,"Visible","off");
axis(ax2,GetBoundaryBox(mesh.hvc));
pbaspect(ax2,[1,1,1]);

[bedge] = GetBoundaryEdge(mesh,sway);
[hverts,hedges] = GetHatchingLine(mesh,bedge,sway,way,width,gtol);

for i = 1:length(bedge)

    DrawingHedge(ax2,mesh,bedge{i},"Color","k","LineWidth",2);

end

DrawingEdge(ax2,hverts,hedges,1:size(hedges,1),"Color","k","LineWidth",1);

end