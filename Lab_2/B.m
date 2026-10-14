clear; clc; close all;

f_carrier = 10;                
dt = 0.01;                     
time_vec = 0:dt:(5/f_carrier); 
num_samples = length(time_vec);


figure('Name', 'Sample Realizations');
hold on; grid on;
for i = 1:5
    X_val = randn(1);               
    Phase_val = 2*pi*rand(1);       
    y_sample = X_val * cos(2*pi*f_carrier*time_vec + Phase_val);
    plot(time_vec, y_sample, 'LineWidth', 1.2);
end
title('5 Sample Realizations of Stochastic Process Y(t)');
xlabel('Time (s)');
ylabel('Amplitude');
hold off;

K_simulations = 5000;

X_array = randn(K_simulations, 1);
Phi_array = 2*pi*rand(K_simulations, 1);
ensemble_matrix = X_array .* cos(2*pi*f_carrier*time_vec + Phi_array);

estimated_mean = mean(ensemble_matrix, 1);

idx_t1 = round(num_samples / 2);

tau_indices = -100:100;
tau_vec = tau_indices * dt;
autocorr_est = zeros(size(tau_indices));

for k = 1:length(tau_indices)
    idx_t2 = idx_t1 + tau_indices(k);
    
    
    if idx_t2 > 0 && idx_t2 <= num_samples
        
        autocorr_est(k) = mean(ensemble_matrix(:, idx_t1) .* ensemble_matrix(:, idx_t2));
    else
        autocorr_est(k) = NaN;
    end
end

autocorr_theory = 0.5 * cos(2*pi*f_carrier*tau_vec);

figure('Name', 'Statistics of Y(t)');

subplot(2,1,1);
plot(time_vec, estimated_mean, 'b', 'LineWidth', 1.5);
title('Ensemble Mean: E[Y(t)]');
xlabel('Time (s)');
ylabel('Amplitude');
ylim([-0.2 0.2]); 
grid on;

subplot(2,1,2);
plot(tau_vec, autocorr_est, 'g', 'LineWidth', 2, 'DisplayName', 'Experimental');
hold on; grid on;
plot(tau_vec, autocorr_theory, 'k--', 'LineWidth', 1.5, 'DisplayName', 'Theoretical');
title('Autocorrelation: R_Y(\tau)');
xlabel('\tau (s)');
ylabel('R_Y');
legend('Location', 'best');
hold off;