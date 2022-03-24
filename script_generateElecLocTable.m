
% Load table
load('../../03_Data/01_Tables/multicentricTableAllImprovedOnlyRev04.mat');

tableMulticentric(tableMulticentric.centerID == 2, :) = [];
contactCoord = cell(height(tableMulticentric), 1);
tableMulticentric = addvars(tableMulticentric, contactCoord);

path = '../../03_Data/04_Reconstructions/';
reconstructionFile = 'ea_reconstruction.mat';

figure
hold on;
axis equal;
for k = 1:height(tableMulticentric)

    patientID = floor(tableMulticentric.leadID(k));
    patientFolder = ['Patient', num2str(patientID, '%04.f'), filesep];

    reconstructionMatrix = load([path, patientFolder, reconstructionFile]);

    side = mod(2*tableMulticentric.leadID(k), 2) + 1;

    if tableMulticentric.contactID(k) < 8 % Right directional contacts
        contact = tableMulticentric.contactID(k);
        coord = reconstructionMatrix.reco.mni.coords_mm{side}(contact + 1, :);

    elseif tableMulticentric.contactID(k) >= 8 && tableMulticentric.contactID(k) < 16 % Left directional contacts
        contact = tableMulticentric.contactID(k);
        coord = reconstructionMatrix.reco.mni.coords_mm{side}(contact - 8 + 1, :);

    elseif tableMulticentric.contactID(k) == 16 % Right ring contacts
        contact = tableMulticentric.contactID(k);
        p1 = reconstructionMatrix.reco.mni.coords_mm{side}(1 + 1, :);
        p2 = reconstructionMatrix.reco.mni.coords_mm{side}(2 + 1, :);
        p3 = reconstructionMatrix.reco.mni.coords_mm{side}(3 + 1, :);

        p12 = (p1 + p2)./2;
        coord = p12 + (p3 - p12)./3;

    elseif tableMulticentric.contactID(k) == 17 % Right ring contacts
        contact = tableMulticentric.contactID(k);
        p1 = reconstructionMatrix.reco.mni.coords_mm{side}(4 + 1, :);
        p2 = reconstructionMatrix.reco.mni.coords_mm{side}(5 + 1, :);
        p3 = reconstructionMatrix.reco.mni.coords_mm{side}(6 + 1, :);

        p12 = (p1 + p2)./2;
        coord = p12 + (p3 - p12)./3;

    elseif tableMulticentric.contactID(k) == 18 % Right ring contacts
        contact = tableMulticentric.contactID(k);
        p1 = reconstructionMatrix.reco.mni.coords_mm{side}(9 - 8 + 1, :);
        p2 = reconstructionMatrix.reco.mni.coords_mm{side}(10 - 8 + 1, :);
        p3 = reconstructionMatrix.reco.mni.coords_mm{side}(11 - 8 + 1, :);

        p12 = (p1 + p2)./2;
        coord = p12 + (p3 - p12)./3;

    elseif tableMulticentric.contactID(k) == 19 % Right ring contacts
        contact = tableMulticentric.contactID(k);
        p1 = reconstructionMatrix.reco.mni.coords_mm{side}(12 - 8 + 1, :);
        p2 = reconstructionMatrix.reco.mni.coords_mm{side}(13 - 8 + 1, :);
        p3 = reconstructionMatrix.reco.mni.coords_mm{side}(14 - 8 + 1, :);

        p12 = (p1 + p2)./2;
        coord = p12 + (p3 - p12)./3;
 
%         scatter3(p1(1), p1(2), p1(3), [], "blue", '.');
%         scatter3(p2(1), p2(2), p2(3), [], "blue", '.');
%         scatter3(p3(1), p3(2), p3(3), [], "blue", '.');
% 
%         scatter3(p12(1), p12(2), p12(3), [], "black", '.');
%         scatter3(coord(1), coord(2), coord(3), [], "red", '.');
%         
%         a = 1;
    end

    tableMulticentric.contactCoord(k) = {coord};

end
