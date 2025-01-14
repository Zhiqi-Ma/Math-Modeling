% Set parameter values
alpha1 = 1;
alpha2 = 1;
phi1 = 1;
phi2 = 1;
k1 = 15;
beta1 = 1;
k2 = 15;
beta2 = 1;

A1 = 0.5;
A2 = 1.2;

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
 additional_fixed_points1 = [
     % coordinate of fixed point 1
 ]; 
 additional_fixed_points2 = [
     % coordinate of fixed point 2 if exists
 ];  
additional_fixed_points3 = [
    % coordinate of fixed point 2 if exists
]; 
% Combine all fixed points
all_fixed_points = [fixed_points; additional_fixed_points1;additional_fixed_points2;additional_fixed_points3];

% Define initial conditions for trajectories
initial_conditions = [[2, 4]; [2, 0]; [2, 4]; [0,0]; [0,3]; [8,3]; [6,8]; [8,6]; [8,8]; [1.08,0]; [1.5,8]];

% Define new initial condition for the special trajectory
special_initial_condition = [3.55, 2.64];

% Plot the phase portrait with trajectories, arrows, and fixed points
figure; 
hold on;

% Iterate through initial conditions and plot trajectories
for i = 1:size(initial_conditions, 1)
    [t, sol] = ode45(ode_system, tspan, initial_conditions(i, :));
    plot(sol(:, 1), sol(:, 2), 'LineWidth', 1, 'Color', 'blue');
    
    % Downsampling factor for arrows
    downsample_factor = 5;

    % Plot arrows on downsampled trajectory points
    quiver(sol(1:downsample_factor:end, 1), sol(1:downsample_factor:end, 2), ...
    gradient(sol(1:downsample_factor:end, 1)), gradient(sol(1:downsample_factor:end, 2)), ...
    1, 'Color', 'black', 'AutoScale', 'off');
end

% Plot the special trajectory from the new initial condition
[t_special, sol_special] = ode45(ode_system, tspan, special_initial_condition);
plot(sol_special(:, 1), sol_special(:, 2), 'LineWidth', 2, 'Color', 'magenta');

% Plot fixed points
scatter(all_fixed_points(:, 1), all_fixed_points(:, 2), 40, 'k', 'filled');

% Plot nullclines
x1_values = linspace(0, 8, 100);
x2_nullcline = (phi2 * A1 + k2 * x1_values .* exp(-x1_values / beta2)) / alpha2; %x2' = 0
plot(x1_values, x2_nullcline, 'r--', 'LineWidth', 1.5, 'Color', [0, 0.5, 0]);

x2_values = linspace(0, 8, 100);
x1_nullcline = (phi1 * A2 + k1 * x2_values .* exp(-x2_values / beta1)) / alpha1; %x1' = 0
plot(x1_nullcline, x2_values, 'b--', 'LineWidth', 1.5, 'Color', 'red');

% Set axis limits and labels
xlim([-0.5, 8]);
ylim([-0.5, 8]);
xlabel("Scarlett's love x1");
ylabel("Rhett's love x2");

% Finish the figure
hold off;

