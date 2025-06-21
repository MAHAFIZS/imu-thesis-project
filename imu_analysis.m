% imu_analysis.m
% Author: M A Hafiz
% IMU Data Analysis: Bias, Noise, Allan Variance, Complementary Filter

clc; clear;

% Paths
hand_file  = 'F:/Imu_thesis_project/data/imu_hand.txt';
table_file = 'F:/Imu_thesis_project/data/imu_table.txt';
mkdir('plots');

% Load Data (ax, ay, az only)
hand_data  = read_imu_file(hand_file);   % [N x 3]
table_data = read_imu_file(table_file);  % [N x 3]

% Bias and Noise Estimation
bias_hand  = mean(hand_data);
noise_hand = std(hand_data);
bias_table = mean(table_data);
noise_table = std(table_data);

fprintf('--- Hand ---\nBias   : [%.5f %.5f %.5f]\nNoise  : [%.5f %.5f %.5f]\n\n', ...
    bias_hand, noise_hand);
fprintf('--- Table ---\nBias   : [%.5f %.5f %.5f]\nNoise  : [%.5f %.5f %.5f]\n\n', ...
    bias_table, noise_table);

% Plot Histograms (X, Y, Z axes)
axes_names = {'X', 'Y', 'Z'};
for i = 1:3
    figure; clf;
    histogram(hand_data(:,i), 'Normalization','pdf', 'FaceColor', [0.8 0.3 0.3]);
    hold on;
    histogram(table_data(:,i), 'Normalization','pdf', 'FaceColor', [0.3 0.6 0.8]);
    legend('Hand', 'Table');
    xlabel(['Acceleration Axis ' axes_names{i}]);
    ylabel('Probability Density');
    title(['Histogram Comparison - ' axes_names{i} ' Axis']);
    grid on;
    saveas(gcf, ['plots/histogram_' lower(axes_names{i}) '_axis.png']);
end

% Allan Variance (Z-axis)
fs = 100;  % Hz (assumed sampling rate, adjust if needed)
allan_variance_analysis(hand_data(:,3), fs, 'Hand');
allan_variance_analysis(table_data(:,3), fs, 'Table');

% Complementary Filter (Pitch & Roll Estimation)
complementary_filter(hand_data, fs);
z6 = table_data(:, 3);  % Extract 3rd column (Z-axis)
 % convert table column to numeric array
% Simulate temperature readings (e.g., around 30°C with noise)
temp = 30 + randn(size(z6));  % or your actual temperature sensor data

% Simulate temperature readings
drift = 0.01*(temp - 30).^2 + 0.005*(temp - 30);  % nonlinear drift
acc_z_drifted = z6 + drift;
acc_z_compensated = acc_z_drifted - drift;


% Plot all three signals
figure;
plot(z6, 'k', 'LineWidth', 1.2); hold on;
plot(acc_z_drifted, 'r--', 'LineWidth', 1);
plot(acc_z_compensated, 'b:', 'LineWidth', 1.2);
legend('Original Z', 'Drifted Z', 'Compensated Z');
xlabel('Sample');
ylabel('Z Acceleration (m/s^2)');
title('Simulated Temperature Drift and Compensation');
grid on;

% Optional: Save
saveas(gcf, 'plots/temp_drift_compensation.png');


%% ---------------------- Helper Functions ------------------------

function data = read_imu_file(filepath)
    fid = fopen(filepath, 'r'); data = [];
    while ~feof(fid)
        line = strtrim(fgetl(fid));
        if isempty(line) || contains(line,'imu_logger') || contains(line,'DenseMatrix') || startsWith(line,'[')
            continue;
        end
        vals = sscanf(line, '%f %f %f %f');
        if numel(vals) == 4
            data = [data; vals(2:4)'];  % ax, ay, az
        end
    end
    fclose(fid);
end

function allan_variance_analysis(signal, fs, label)
    N = length(signal);
    max_m = floor(N / 10);
    m_vals = round(logspace(0, log10(max_m), 30));
    m_vals = unique(m_vals);
    taus = m_vals / fs;
    adevs = zeros(size(taus));

    for i = 1:length(m_vals)
        m = m_vals(i);
        y = mean(reshape(signal(1:m*floor(N/m)), m, []));
        dy = diff(y);
        adevs(i) = sqrt(0.5 * mean(dy.^2));
    end

    figure; clf;
    loglog(taus, adevs, 'o-', 'LineWidth', 2);
    grid on;
    xlabel('Averaging Time \tau [s]');
    ylabel('Allan Deviation');
    title(['Allan Variance - Z Axis (' label ')']);
    legend(label);
    saveas(gcf, ['plots/allan_variance_' lower(label) '.png']);
end

function complementary_filter(acc, fs)
    % Simple complementary filter for pitch & roll
    dt = 1 / fs;
    alpha = 0.98;  % Weight for gyroscope (if available)

    pitch = zeros(size(acc,1),1);
    roll  = zeros(size(acc,1),1);

    for i = 2:length(acc)
        ax = acc(i,1); ay = acc(i,2); az = acc(i,3);
        pitch(i) = atan2(ax, sqrt(ay^2 + az^2)) * 180/pi;
        roll(i)  = atan2(ay, sqrt(ax^2 + az^2)) * 180/pi;
        % Filtering could be added here if gyroscope was available
    end

    t = (0:length(pitch)-1) * dt;
    figure; clf;
    plot(t, pitch, 'r'); hold on;
    plot(t, roll, 'b');
    xlabel('Time [s]'); ylabel('Angle [deg]');
    title('Complementary Filter - Pitch & Roll');
    legend('Pitch','Roll'); grid on;
    saveas(gcf, 'plots/complementary_pitch_roll.png');
end
% Extract Z-axis from table_data
