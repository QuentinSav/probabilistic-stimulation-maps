function show_results(obj, resultType)
% Function used to show the predictions

% Initialize resultType to default if not passed to argument
if ~exist('resultType', 'var')
    resultType = 'overlapRatio';

end

% Show results
if strcmpi(resultType, 'overlapRatio')
    color = mod(2*obj.results.leadID, 2);
    figure('Name',  resultType);
    scatter(100.*obj.results.overlap.ratio, 100.*obj.results.efficiency, 120, color, '.');
    xlabel('Overlap ratio (%)');
    ylabel('Clinical efficiency (%)');

elseif strcmpi(resultType, 'overlapSize')
    figure('Name',  resultType);
    scatter(obj.results.overlap.size, 100.*obj.results.efficiency, 120, '.');
    xlabel('Overlap size (mm^3)');
    ylabel('Clinical efficiency (%)');

elseif strcmpi(resultType, 'dice')
    figure('Name', resultType);
    scatter(obj.results.dice.similarity, 100.*obj.results.efficiency, 120, '.')
    xlabel('Dice similarity (-)');
    ylabel('Clinical efficiency (%)');

end