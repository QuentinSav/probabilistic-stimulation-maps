function R2_kFold = evaluate(obj, metricType)
% Function that performs a linear regression of the predictions

disp('--------------------------------------------------');
disp('Evaluation');

if strcmpi(metricType, 'overlap_ratio')
    metric = obj.results.overlap.ratio;
    groundTruth = obj.results.score;
      
elseif strcmpi(metricType, 'predictor')
    metric = obj.results.regression.predictionsTesting;
    groundTruth = obj.features.regression.y.testing;
end

% Linear regression model
mdl = fitlm(metric, groundTruth);

% Compute Spearman correlation
[spearman_rho, spearman_p] = corr(metric', groundTruth', 'Type', 'Spearman');

% % Compute Pearson correlation
[pearson_rho, pearson_p] = corr(metric', groundTruth', 'Type', 'Pearson');

f1 = figure('Name', 'Overall results', ...
    'Position', [200 200 400 400]);
hold on;
plot(mdl);
axis([0 1 0 1]);
axis square
xlabel('Overlap ratio (%)');
ylabel('Relative improvement (%)');
title('')
f1.Children(2).Children(4).Marker = 'o';
f1.Children(2).Children(4).MarkerSize = 4;
f1.Children(2).Children(4).MarkerFaceColor = [102 153 204]/255;
f1.Children(2).Children(4).MarkerEdgeColor = 'None';
legend off

disp("Overall results -------------------------- ");
disp("Linear regression:      R² (ordinary) = " + mdl.Rsquared.Ordinary);
disp("                        R² (adjusted) = " + mdl.Rsquared.Adjusted);
disp("                        theta_0 = " + mdl.Coefficients.Estimate(1) + ...
                            " p-value = " + mdl.Coefficients.pValue(1));
disp("                        theta_1 = " + mdl.Coefficients.Estimate(2) + ...
                            " p-value = " + mdl.Coefficients.pValue(2));
disp(' ');
disp("Spearman correlation:   rho = " + spearman_rho);
disp("                        p = " + spearman_p);
disp(' ');
disp("Pearson correlation:    rho = " + pearson_rho);
disp("                        p = " + pearson_p);
disp(' ');

for k = 1:max(obj.results.kFold)
    
    metric_kFold = obj.results.overlap.ratio(obj.results.kFold==k);
    groundTruth_kFold = obj.results.score(obj.results.kFold==k);

    mdl = fitlm(metric_kFold, groundTruth_kFold);

    R2_kFold(k) = mdl.Rsquared.Adjusted;

end

end