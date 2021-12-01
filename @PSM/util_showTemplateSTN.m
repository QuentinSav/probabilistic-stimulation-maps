function util_showTemplateSTN()
% Khoa Nguyen

fileAtlas = ...
    'anatomyDISTALminimal.ply';
colorIdx = 4; % color code for STN in DISTAL atlas
ptCloud = pcread( fileAtlas );
pcColors = unique( ptCloud.Color,'rows' );
tmpIdx = ptCloud.Color == pcColors( colorIdx,: );
Idx = sum( tmpIdx,2 ) == 3;
IdxLeft = ptCloud.Location(:,1) < 0;
IdxRight = ptCloud.Location(:,1) >= 0;
[ boundarySTNLeft, ~ ] = boundary( ...
    double(ptCloud.Location((Idx & IdxLeft),1)), ...
    double(ptCloud.Location((Idx & IdxLeft),2)), ...
    double(ptCloud.Location((Idx & IdxLeft),3)),0.25);
[ boundarySTNRight, ~ ] = boundary( ...
    double(ptCloud.Location((Idx & IdxRight),1)), ...
    double(ptCloud.Location((Idx & IdxRight),2)), ...
    double(ptCloud.Location((Idx & IdxRight),3)),0.25);

% refresh figures
figure( fhMeanEfficiency )
hold off
trisurf( boundarySTNRight, ptCloud.Location( ( Idx & IdxRight ), 1 ), ...
    ptCloud.Location( ( Idx & IdxRight ) , 2 ), ...
    ptCloud.Location( ( Idx & IdxRight ) , 3 ), 'Facecolor', [ .4 .4 .4 ],...
    'FaceAlpha', 0.2, 'LineStyle' , 'none' , 'EdgeColor' , pcColors( colorIdx, : ) );
xlabel('Medial-lateral (mm)')
ylabel('Posterior-anterior (mm)')
zlabel('Inferior-superior (mm)')
grid on
xlim([5 20]); ylim([-25 0]); zlim([-15 5]);
hold on
view( -30, 30 )

end