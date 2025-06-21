# IMU Thesis Project – MATLAB-Based IMU Simulation and Compensation

This project is part of my Master's thesis on **gesture-based control of robotic systems** using inertial sensor data. The focus is on simulating and compensating **bias** and **noise** in real-world IMU (Inertial Measurement Unit) signals using MATLAB.

## 🎯 Objective

To analyze and simulate the behavior of MEMS-based IMU signals and develop compensation strategies for:
- Sensor bias (offset)
- Sensor noise (standard deviation)

The compensated data can improve downstream processing such as gesture recognition or orientation estimation.

## 📂 Contents

- `imu_simulation_compensation.m`: Main script for simulating gesture motion, applying real-world IMU bias/noise, and compensating them.
- `imu_logger_log.txt`: Sample real IMU data (rest state) used to extract offset and noise.
- Example plots before and after compensation.
- Real data from Muovi sensor used in simulation.

## 🧠 Workflow

1. Load raw IMU data (from sensor at rest).
2. Calculate:
   - Accelerometer bias (mean)
   - Noise (standard deviation)
3. Simulate gesture-like motion using sine/cosine functions.
4. Add real sensor bias and noise to generate "measured" data.
5. Compensate bias and evaluate noise after compensation.
6. Plot results for visualization.

## 📊 Example Output

![Simulation Result](./simulation_plot_example.png)

```matlab
--- Real IMU Statistics ---
Bias (rest state):       [-1.73619 1.52775 1.07826]
Noise STD (rest state):  [1.27754 1.11536 0.78765]

--- Simulated Gesture Data ---
Bias After Compensation: [0.09891 -0.04806 0.04858]
Noise STD After:         [1.48659 1.26710 0.79436]
