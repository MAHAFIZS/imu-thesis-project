# IMU Thesis Project One Part – Bias and Noise Characterization with MATLAB

This repository contains MATLAB code and real IMU data for analyzing and compensating inertial sensor bias and noise. The project is part of my Master's thesis at FAU Erlangen-Nürnberg, focusing on gesture-based teleoperation of a Franka Emika Panda robot.

## 📁 Folder Structure
/data
imu_hand.txt - IMU data while attached to hand (motion + noise)
imu_table.txt - IMU data while resting on table (baseline reference)
/plots
histogram_x_axis.png
histogram_y_axis.png
histogram_z_axis.png
## 📊 What’s Inside
- **Bias & Noise Estimation**: Compute mean (bias) and standard deviation (noise) for each axis (ax, ay, az).
- **Sensor Stability Comparison**: Visual and statistical comparison between static (table) and dynamic (hand) placements.
- **MATLAB Code**: Modular scripts for loading, analyzing, and plotting IMU signal quality.
- **Signal Compensation**: Optional compensation applied for gesture recognition tasks.

## 🔬 Example Output
--- Hand ---
Bias : [-2.14 1.89 1.35]
Noise : [ 1.06 0.93 0.66]

--- Table ---
Bias : [ 3.06 -0.34 0.58]
Noise : [ 1.23 0.34 0.42]

## 📌 Relevance
The results from this analysis support:
- Filtering design for gesture-based robot control
- Sensor calibration logic in embedded systems
- Robust IMU signal processing for human-machine interfaces

## 🛠 Technologies Used
- MATLAB R2018b
- MEMS-based IMU (Muovi Sensor)
- Data collected from real-time hand and table experiments

## 🔗 Project Scope
This work is part of a larger thesis project on **gesture-based control interfaces** for robot teleoperation using sensor fusion (EMG + IMU).

---
git add README.md
git commit -m "Add detailed README for IMU thesis project"
git push
