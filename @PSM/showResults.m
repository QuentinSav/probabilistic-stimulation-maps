function showResults(obj, resultType)

if strcmpi(resultType, 'OverlapRatio')

    color = mod(2*obj.results.leadID, 2);
    figure('Name',  resultType);
    scatter(100.*obj.results.overlap.ratio, 100.*obj.results.efficiency, 120, color, '.');
    xlabel('Overlap ratio (%)');
    ylabel('Clinical efficiency (%)');

elseif strcmpi(resultType, 'OverlapSize')
    figure('Name',  resultType);
    scatter(obj.results.overlap.size, 100.*obj.results.efficiency, 120, '.');
    xlabel('Overlap size (mm^3)');
    ylabel('Clinical efficiency (%)');

elseif strcmpi(resultType, 'Dice')
    figure('Name', resultType);
    scatter(obj.results.dice.similarity, 100.*obj.results.efficiency, 120, '.')
    xlabel('Dice similarity (-)');
    ylabel('Clinical efficiency (%)');

elseif strcmpi(resultType, 'weightedSum')
    figure('Name', resultType);
    scatter(obj.results.weightedSum.value, 100.*obj.results.efficiency, 120, '.', 'ColorVariable', obj.results.kFold)
    xlabel('WeightedSum (-)');
    ylabel('Clinical efficiency (%)');

end
end