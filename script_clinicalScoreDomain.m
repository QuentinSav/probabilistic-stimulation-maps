%% Creation of domain of score

% The clinical improvement is a relative measure of which makes it
% contained in the interval [0, 1]
improvement = linspace(0, 1, 21);

% The stimulation amplitude is not bounded (it is but for physiological 
% reasons). [0 inf]
amplitude = linspace(0, 5, 201);

[X,Y] = meshgrid(improvement, amplitude);

efficiency = X./Y;

figure;
surf(X, Y, efficiency);
xlabel('Relative improvement');
ylabel('Stimulation amplitude');
zlabel('Efficiency');