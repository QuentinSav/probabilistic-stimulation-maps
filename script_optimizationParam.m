clc
clear all;
close all;

%% 1D map convex

x = linspace(0, 10, 101);
map = -20+10.*x-x.^2;
int_map = cumtrapz(x, map);

figure
subplot(1, 2, 1);
hold on;
plot(x, map);
xlabel('x');
ylabel('theta(x)');

subplot(1, 2, 2);
hold on;
plot(x, int_map)
xlabel('x');
ylabel('integral of theta(x)');

% We define a center for the contact
c = 5;
index_c = find(x == c);

% function to minimize
radius = 1:30;

for k = 1:length(radius)
    
    y(k) = sum(map(index_c - radius(k):index_c + radius(k)));

end


figure;
plot(radius, y)