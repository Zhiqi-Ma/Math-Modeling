% Set parameter values
alpha1 = 1;
alpha2 = 1;
phi1 = 1;
phi2 = 1;
k1 = 15;
beta1 = 1;
k2 = 15;
beta2 = 1;
lambda12 = 1; 
lambda22 = 0;
lambda11 = 1; 
lambda21 = 0;
lambda31 = 0; 
lambda41 = 0; 
A11 = 1.2; 
A21 = 0; 
A12 = 2; 
A22 = 0; 
A32 = 0; 
A42 = 0; 
A1 = lambda12 * A11 + lambda22 * A21;
A2 = lambda11 * A12 + lambda21 * A22 + lambda31 * A32 + lambda41 * A42;

% Define the functions for the terms
R1 = @(x2) k1 * x2 * exp(-x2 / beta1);
R2 = @(x1) k2 * x1 * exp(-x1 / beta2);

% Define the ODE system
ode_system = @(t, x) [-alpha1 * x(1) + phi1 * A2 + R1(x(2)); ...
                       -alpha2 * x(2) + phi2 * A1 + R2(x(1))];

% Define time span
tspan = [0, 100];

% Find and plot fixed points
options = optimoptions('fminunc', 'Display', 'off');
fixed_points = fminunc(@(x) norm(ode_system(0, x)), [0, 0], options);
disp(fixed_points)

% Additional fixed points by graph calculator for oldfig3a
% uncomment either set of additional_fixed_points based on the case
% additional_fixed_points = [
%     1.152, 6.461;
%     3.098, 3.098;
%     6.461, 1.152
% ]; % oldfig3a
% additional_fixed_points = [
%     1.126, 6.678;
%     3.411, 2.889;
%     6.194, 1.39
% ]; % oldfig3b 
additional_fixed_points = [
    7.349, 1.271;
]; % oldfig3c

% Combine all fixed points
all_fixed_points = [fixed_points; additional_fixed_points];

% Define initial conditions for trajectories
initial_conditions = [[2, 4]; [2, 0]; [2, 4]; [0,0]; [0,3]; [8,3]; [6,8]; [8,6]; [8,8]; [1.08,0];[1.5,8]];

% % Plot the phase portrait with trajectories, arrows, and fixed points
figure; 
% quiver(x1, x2, dx1dt, dx2dt); %plot vector fiel
hold on;

% Iterate through initial conditions and plot trajectories
for i = 1:size(initial_conditions, 1)
    [t, sol] = ode45(ode_system, tspan, initial_conditions(i, :));
    plot(sol(:, 1), sol(:, 2), 'LineWidth', 1, 'Color', 'blue');
    
    % Downsampling factor
    downsample_factor = 5;

    % Set the size of the arrows
    arrow_size = 1;

    % Plot arrows on downsampled trajectory points
    quiver(sol(1:downsample_factor:end, 1), sol(1:downsample_factor:end, 2), ...
    gradient(sol(1:downsample_factor:end, 1)), gradient(sol(1:downsample_factor:end, 2)), ...
    arrow_size, 'Color', 'black', 'AutoScale', 'off');
end

% Plot fixed points
scatter(all_fixed_points(:, 1), all_fixed_points(:, 2), 40, 'k', 'filled');

% Plot nullclines
x1_values = linspace(0, 8, 100);
x2_nullcline = (phi2 * A1 + k2 * x1_values .* exp(-x1_values / beta2)) / alpha2; %x2' = 0
plot(x1_values, x2_nullcline, 'r--', 'LineWidth', 1.5, 'Color', [0, 0.5, 0]);

x2_values = linspace(0, 8, 100);
x1_nullcline = (phi1 * A2 + k1 * x2_values .* exp(-x2_values / beta1)) / alpha1; %=x1, x1' = 0
plot(x1_nullcline, x2_values, 'b--', 'LineWidth', 1.5, 'Color', 'red');

hold off;
xlabel("Scarlett's love x1");
ylabel("Rhett's love x2");

% Set axis limits
xlim([-0.5, 8]);
ylim([-0.5, 8]);

% Save the figure as a JPEG file
% saveas(gcf, 'vector_field_plot.jpg');

