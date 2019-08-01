%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% file:DataPreprocess.m
% date:2019/07/31
% author:YangYue
% email:qinguoxiaozi@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Sensor data preprocess
clear;
clc;
% load optional sensor data
load('data1.mat');
clearvars -except IMU IMU_label MAG MAG_label GPS GPS_label BARO BARO_label EKF1 EKF1_label;

% data length
[imuLength,~] = size(IMU);
[magLength,~] = size(MAG);
[gpsLength,~] = size(GPS);
[baroLength,~] = size(BARO);
[ekf1Length,~] = size(EKF1);

% data index
imuIndex = 1;
magIndex = 1;
gpsIndex = 1;
baroIndex = 2;
ekfIndex = 1;



