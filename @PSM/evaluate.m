function evaluate(obj, metricType)
% Function that performs a linear regression of the predictions

disp('--------------------------------------------------');
disp('Evaluation');

if strcmpi(metricType, 'overlapRatio')
    metric = obj.results.overlap.ratio;

elseif strcmpi(metricType, 'predictor')
    metric = obj.results.regression.predictionsTesting;
end

% Linear regression model
mdl = fitlm(metric./obj.data.testing.table.amplitude, obj.features.regression.y.testing./obj.data.testing.table.amplitude);

disp("Linear regression:      R² (ordinary) = " + mdl.Rsquared.Ordinary);
disp("                        R² (adjusted) = " + mdl.Rsquared.Adjusted);
disp(' ');

% Compute Spearman correlation
% [rho, p] = corr(metric, obj.results.score, 'Type', 'Spearman');
% disp("Spearman correlation:   rho = " + rho);
% disp("                        p = " + p);
% disp(' ');
% 
% % Compute Pearson correlation
% [rho, p] = corr(metric, obj.results.score, 'Type', 'Pearson');
% disp("Pearson correlation:    rho = " + rho);
% disp("                        p = " + p);
% disp(' ');

figure('Name', 'Evaluation');
hold on;
plot(mdl);
axis([0 1 0 1]);
xlabel('Overlap ratio (%)');
ylabel('Efficiency (Ground Truth)');
plot(linspace(0,1,2), linspace(0,1,2),'k--')

end