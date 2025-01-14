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
% % oldfig3a 
% A11 = 1; % oldfig3a 
% A21 = 0; 
% A12 = 1; 
% A22 = 0; 
% A32 = 0; 
% A42 = 0; 
% oldfig3b
A11b = 1.2; % oldfig3a 
A21b = 0; 
A12b = 1; 
A22b = 0; 
A32b = 0; 
A42b = 0; 
A1b = lambda12 * A11b + lambda22 * A21b;
A2b = lambda11 * A12b + lambda21 * A22b + lambda31 * A32b + lambda41 * A42b;
% oldfig3c
A11c = 1.2;  
A21c = 0; 
A12c = 2; 
A22c = 0; 
A32c = 0; 
A42c = 0; 
A1c = lambda12 * A11c + lambda22 * A21c;
A2c = lambda11 * A12c + lambda21 * A22c + lambda31 * A32c + lambda41 * A42c;

% Define the functions for the terms
R1 = @(x2) k1 * x2 * exp(-x2 / beta1);
R2 = @(x1) k2 * x1 * exp(-x1 / beta2);

% Define the ODE system for case b 
ode_system_b = @(t, x) [-alpha1 * x(1) + phi1 * A2b + R1(x(2)); ...
                       -alpha2 * x(2) + phi2 * A1b + R2(x(1))];
% Define the ODE system for case c 
ode_system_c = @(t, x) [-alpha1 * x(1) + phi1 * A2c + R1(x(2)); ...
                       -alpha2 * x(2) + phi2 * A1c + R2(x(1))];

% Define time span
tspan = [0, 100];

% Find and plot fixed points
options = optimoptions('fminunc', 'Display', 'off');
fixed_points_b = fminunc(@(x) norm(ode_system_b(0, x)), [0, 0], options);
fixed_points_c = fminunc(@(x) norm(ode_system_c(0, x)), [0, 0], options);

% Additional fixed points by graph calculator 
additional_fixed_points_b = [
    1.126, 6.678;
    % 3.411, 2.889;
    % 6.194, 1.39
]; % oldfig3b 
additional_fixed_points_c = [
    7.349, 1.271;
]; % oldfig3c

% Combine all fixed points
all_fixed_points = [fixed_points_b; fixed_points_c];
all_fixed_points = [all_fixed_points; additional_fixed_points_b];
all_fixed_points = [all_fixed_points; additional_fixed_points_c];

% for final combines phase portrait initial conditons
initial_conditions_b = [0,0];
initial_conditions_c = [0.55,2.4];

% Plot the phase portrait with trajectories, arrows, and fixed points
figure; 
% quiver(x1, x2, dx1dt, dx2dt); %plot vector fiel
hold on;

% Iterate through initial conditions and plot trajectories
for i = 1:size(initial_conditions_b, 1)
    [t, sol] = ode45(ode_system_b, tspan, initial_conditions_b(i, :));
    plot(sol(:, 1), sol(:, 2), 'LineWidth', 1, 'Color', 'blue');

    % Find x1 value when x2 = 5.5
    x1_at_x2_5 = interp1(sol(:, 2), sol(:, 1), 5.5, 'linear', 'extrap'); %1.3814

    % plot(sol(1:1.3814, 1), sol(1:5.5, 2), 'LineWidth', 1, 'Color', 'blue');

    % Downsampling factor
    downsample_factor = 5;
    % Set the size of the arrows
    arrow_size = 1;
    % Plot arrows on downsampled trajectory points
    quiver(sol(1:downsample_factor:end, 1), sol(1:downsample_factor:end, 2), ...
    gradient(sol(1:downsample_factor:end, 1)), gradient(sol(1:downsample_factor:end, 2)), ...
    arrow_size, 'Color', 'black', 'AutoScale', 'off');
end

% Iterate through initial conditions and plot trajectories
for i = 1:size(initial_conditions_c, 1)
    [t, sol] = ode45(ode_system_c, tspan, initial_conditions_c(i, :));
    plot(sol(:, 1), sol(:, 2), 'LineWidth', 1, 'Color', 'red');
    
    % Downsampling factor
    downsample_factor = 5;

    % Set the size of the arrows
    arrow_size = 1;

    % Plot arrows on downsampled trajectory points
    quiver(sol(1:downsample_factor:end, 1), sol(1:downsample_factor:end, 2), ...
    gradient(sol(1:downsample_factor:end, 1)), gradient(sol(1:downsample_factor:end, 2)), ...
    arrow_size, 'Color', 'black', 'AutoScale', 'off');

    % % Find x2 value when x1 = 7
    % x2_at_x1_7 = interp1(sol(:, 1), sol(:, 2), 7, 'linear', 'extrap'); %1.3603
end

% Plot the dotted line between the two lines 
plot([additional_fixed_points_b(1), initial_conditions_c(1)], [additional_fixed_points_b(2), initial_conditions_c(2)], 'k--','Color','green');
% plot([x1_at_x2_5, initial_conditions_c(1)], [5.5, initial_conditions_c(2)], 'k--','Color',[0,0.5,0]);

% Plot fixed points
scatter(all_fixed_points(:, 1), all_fixed_points(:, 2), 40, 'k', 'filled');


hold off;
xlabel("Scarlett's love x1");
ylabel("Rhett's love x2");

% Set axis limits
xlim([0, 8]);
ylim([0, 8]);


