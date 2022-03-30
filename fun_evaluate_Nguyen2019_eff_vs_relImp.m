function fun_evaluate_Nguyen2019_eff_vs_relImp(obj, ss_type)
% ss_type (sweet spot): 'eff' or 'relImp'

metric = obj.results.overlap.ratio;
groundTruth = obj.results.score;

if strcmpi(ss_type, 'eff')
    % Linear regression model
    mdl_1 = fitlm(100*metric, 100*groundTruth);
    mdl_2 = fitlm(100*metric, 100*groundTruth.*obj.data.testing.table.amplitude');

    f1 = figure('Name', 'A - eff eff', ...
        'Position', [200 200 450 450]);
    hold on;
    plot(mdl_1);
    axis([0 100 0 100]);
    axis square
    xlabel('Overlap ratio (%)');
    ylabel('Efficiency (-)');
    title('')
    f1.Children(2).Children(4).Marker = 'o';
    f1.Children(2).Children(4).MarkerSize = 4;
    f1.Children(2).Children(4).MarkerFaceColor = [102 153 204]/255;
    f1.Children(2).Children(4).MarkerEdgeColor = 'None';
    
    f2 = figure('Name', 'B - rI eff', ...
        'Position', [200 200 450 450]);
    hold on;
    plot(mdl_2);
    axis([0 100 0 100]);
    axis square
    xlabel('Overlap ratio (%)');
    ylabel('Relative improvement (%)');
    title('')
    f2.Children(2).Children(4).Marker = 'o';
    f2.Children(2).Children(4).MarkerSize = 4;
    f2.Children(2).Children(4).MarkerFaceColor = [102 153 204]/255;
    f2.Children(2).Children(4).MarkerEdgeColor = 'None';
    legend off
    
    disp('Efficiency Sweet Spot: ------------------------------------------');
    disp("Efficiency (A)       R² (adjusted) = " + mdl_1.Rsquared.Adjusted);
    disp("                     theta_0 = " + mdl_1.Coefficients.Estimate(1) + " p-value = " + mdl_1.Coefficients.pValue(1));
    disp("                     theta_1 = " + mdl_1.Coefficients.Estimate(2) + " p-value = " + mdl_1.Coefficients.pValue(2));
    disp(' ');
    disp("Rel. Improvement (B) R² (adjusted) = " + mdl_2.Rsquared.Adjusted);
    disp("                     theta_0 = " + mdl_2.Coefficients.Estimate(1) + " p-value = " + mdl_2.Coefficients.pValue(1));
    disp("                     theta_1 = " + mdl_2.Coefficients.Estimate(2) + " p-value = " + mdl_2.Coefficients.pValue(2));
    disp(' ');

elseif strcmpi(ss_type, 'relImp')
    % Linear regression model
    mdl_1 = fitlm(100*metric, 100*groundTruth./obj.data.testing.table.amplitude');
    mdl_2 = fitlm(100*metric, 100*groundTruth);

    f1 = figure('Name', 'C - eff rI', ...
        'Position', [200 200 450 450]);
    hold on;
    plot(mdl_1);
    axis([0 100 0 100]);
    axis square
    xlabel('Overlap ratio (%)');
    ylabel('Efficiency (-)');
    title('')
    f1.Children(2).Children(4).Marker = 'o';
    f1.Children(2).Children(4).MarkerSize = 4;
    f1.Children(2).Children(4).MarkerFaceColor = [102 153 204]/255;
    f1.Children(2).Children(4).MarkerEdgeColor = 'None';
    legend off

    f2 = figure('Name', 'D - rI rI', ...
        'Position', [200 200 450 450]);
    hold on;
    plot(mdl_2);
    axis([0 100 0 100]);
    axis square
    xlabel('Overlap ratio (%)');
    ylabel('Relative improvement (%)');
    title('')
    f2.Children(2).Children(4).Marker = 'o';
    f2.Children(2).Children(4).MarkerSize = 4;
    f2.Children(2).Children(4).MarkerFaceColor = [102 153 204]/255;
    f2.Children(2).Children(4).MarkerEdgeColor = 'None';
    legend off

    disp('Relative improvement Sweet Spot: -------------------------------');
    disp("Efficiency (C)       R² (adjusted) = " + mdl_1.Rsquared.Adjusted);
    disp("                     theta_0 = " + mdl_1.Coefficients.Estimate(1) + " p-value = " + mdl_1.Coefficients.pValue(1));
    disp("                     theta_1 = " + mdl_1.Coefficients.Estimate(2) + " p-value = " + mdl_1.Coefficients.pValue(2));
    disp(' ');
    disp("Rel. Improvement (D) R² (adjusted) = " + mdl_2.Rsquared.Adjusted);
    disp("                     theta_0 = " + mdl_2.Coefficients.Estimate(1) + " p-value = " + mdl_2.Coefficients.pValue(1));
    disp("                     theta_1 = " + mdl_2.Coefficients.Estimate(2) + " p-value = " + mdl_2.Coefficients.pValue(2));
    disp(' ');

end

end