function evaluate(obj, metricType)
% Function that performs a linear regression of the predictions

disp('--------------------------------------------------');
disp('Evaluation');

if strcmpi(metricType, 'overlapRatio')
    metric = obj.results.overlap.ratio;

elseif strcmpi(metricType, 'weightedSum')
    metric = obj.results.logRegression;
end

% Linear regression model
mdl = fitlm(metric, obj.results.score);

disp("Linear regression:      R² (ordinary) = " + mdl.Rsquared.Ordinary);
disp("                        R² (adjusted) = " + mdl.Rsquared.Adjusted);
disp(' ');

% Compute Spearman correlation
[rho, p] = corr(obj.results.overlap.ratio', obj.results.score', 'Type', 'Spearman');
disp("Spearman correlation:   rho = " + rho);
disp("                        p = " + p);
disp(' ');

% Compute Pearson correlation
[rho, p] = corr(obj.results.overlap.ratio', obj.results.score', 'Type', 'Pearson');
disp("Pearson correlation:    rho = " + rho);
disp("                        p = " + p);
disp(' ');

figure('Name', 'Evaluation');
hold on;
plot(mdl);
xlabel('Overlap ratio (%)');
ylabel('Clinical score (%)');

end