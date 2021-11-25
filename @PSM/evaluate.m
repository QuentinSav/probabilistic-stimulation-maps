function evaluate(obj)
% Function that performs a linear regression of the predictions

disp('--------------------------------------------------');
disp('Evaluation');

% Linear regression model
mdl = fitlm(obj.results.overlap.ratio, obj.results.efficiency);

disp("Linear regression:      R² (ordinary) = " + mdl.Rsquared.Ordinary);
disp("                        R² (adjusted) = " + mdl.Rsquared.Adjusted);
disp(' ');

% Compute Spearman correlation
[rho, p] = corr(obj.results.overlap.ratio', obj.results.efficiency', 'Type', 'Spearman');
disp("Spearman correlation:   rho = " + rho);
disp("                        p = " + p);
disp(' ');

% Compute Pearson correlation
[rho, p] = corr(obj.results.overlap.ratio', obj.results.efficiency', 'Type', 'Pearson');
disp("Pearson correlation:    rho = " + rho);
disp("                        p = " + p);
disp(' ');

figure('Name',  'Evaluation');
hold on;
scatter(100.*obj.results.overlap.ratio, 100.*obj.results.efficiency, 120, color, '.');
xlabel('Overlap ratio (%)');
ylabel('Clinical efficiency (%)');


end