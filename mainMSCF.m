%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% file:mainMSCF.m
% date:2019/07/31
% author:YangYue
% email:qinguoxiaozi@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
clc;
close all;

%% DataPreprocess
DataPreprocess;

%% global variable
global GRAVITY_MSS;
global dcm_matrix;
global roll;
global pitch;
global yaw;
global updateGPS;
global updateMAG;
global accel_ef;
global ra_sum;
global ra_deltat;
global last_velocity;
global last_lat;
global last_lng;
global omega;
global omega_P;
global omega_I;
global kp;
global ki;
global omega_I_sum;
global omega_I_sum_time;
global mag_earth;
global kp_yaw;
global omega_yaw_P;
global last_declination;
global yaw_deltat;
global ki_yaw;
global ra_sum_start;
global SPIN_RATE_LIMIT;
global gyro_drift_limit;

%% initial global variable
GRAVITY_MSS = 9.80665;
mag_earth = [1;0];
ki = 0.0087;
kp = 0.2;
kp_yaw = 0.2;
accel_ef = zeros(3,1);
ra_sum = zeros(3,1);
ra_deltat = 0;
last_velocity = zeros(3,1);
last_lat = 0;
last_lng = 0;
omega = zeros(3,1);
omega_P = zeros(3,1);
omega_I = zeros(3,1);
omega_I_sum = zeros(3,1);
omega_I_sum_time = 0;
omega_yaw_P = zeros(3,1);
last_declination = 0;
yaw_deltat = 0;
ki_yaw = 0.01;
ra_sum_start = 0;
SPIN_RATE_LIMIT = 20;
gyro_drift_limit = 0.5*60/180*pi;
%% inertialNav
%gps
global gps_last_time;
global gps_update_time;
global base_lat;
global base_lon;
global LATLON_TO_CM;
global lon_to_cm_scaling;
% baro
global baro_last_update;
global baro_update_time;
global baro_alt;
% 3*1 vector
global position_error;
global hist_position_estimate;
global position_correction;
global accel_correction_ef;
global velocity;
global position_base;
global position;
% coeff
global k3_xy;
global k3_z;
global k2_xy;
global k2_z;
global k1_xy;
global k1_z;
global dt;
%% init
accel = IMU(imuIndex,6:8)';
mag = MAG(magIndex,3:5)';
[roll, pitch] = getRollPitchFromAccel(accel);
hx = mag(1)*cos(pitch)+mag(2)*sin(pitch)*sin(roll)+mag(3)*sin(pitch)*cos(roll);
hy = mag(2)*cos(roll)-mag(3)*sin(roll);
yaw = getYawFromMag([hx,hy,0]);
dcm_matrix = getDCMFromEuler(roll,pitch,yaw);
angle = zeros(imuLength,3);
angle(imuIndex,:) = [roll,pitch,yaw];
imuIndex = imuIndex + 1;

updateGPS = 0;
updateMAG = 0;


% lat,lng,alt,vx,vy,vz
gps = zeros(6,1);

% inertialNav
position_error = zeros(3,1);
hist_position_estimate = zeros(3,1);
position_correction = zeros(3,1);
accel_correction_ef = zeros(3,1);
velocity = zeros(3,1);
position_base = zeros(3,1);
position = zeros(3,1);

% cm 
position_base(3) = BARO(baroIndex,3)*100;
position(3) = BARO(baroIndex,3)*100;
hist_position_estimate(3) = BARO(baroIndex,3)*100;


% cm/s
velocity(1) = GPS(gpsIndex,12)*cos(GPS(gpsIndex,13))*100;
velocity(2) = GPS(gpsIndex,12)*sin(GPS(gpsIndex,13))*100;
velocity(3) = GPS(gpsIndex,14)*100;
baro_alt = BARO(baroIndex,3)*100;
baro_last_update = BARO(baroIndex,2);
gps_last_time = GPS(gpsIndex,2);
% degree
base_lat = GPS(gpsIndex,8);
base_lon = GPS(gpsIndex,9);
set_time_constant();
LATLON_TO_CM = 1.113195*10^7;
lon_to_cm_scaling = LATLON_TO_CM * cos(base_lat*pi/180);
vel = zeros(imuLength,3);
pos = zeros(imuLength,3);
vel(1,1:3)=[velocity(1),velocity(2),velocity(3)];
pos(1,1:3)=[position(1),position(2),position(3)];
%% start
while imuIndex <= imuLength
    accel = IMU(imuIndex,6:8)';
    gyro =  IMU(imuIndex,3:5)';
    delta_t = (IMU(imuIndex,2)-IMU(imuIndex-1,2))/10^6;% s
    dt = delta_t;
    DCMMatrixUpdate(gyro,delta_t);
    normlizeMatrix();
    

    %gps
    if gpsIndex <gpsLength && GPS(gpsIndex,2) > IMU(imuIndex-1,2) && GPS(gpsIndex,2) < IMU(imuIndex,2)
        updateGPS = 1;
        gps_update_time = GPS(gpsIndex,2);
        temp = GPS(gpsIndex,3:8)';
        gps(1) = GPS(gpsIndex,8);%lat
        gps(2) = GPS(gpsIndex,9);%lon
        gps(3) = GPS(gpsIndex,10);%RAlt
        gps(4) = GPS(gpsIndex,12)*cos(GPS(gpsIndex,13)*pi/180);%north velocity
        gps(5) = GPS(gpsIndex,12)*sin(GPS(gpsIndex,13)*pi/180);%east velocity
        gps(6) = GPS(gpsIndex,14);%Vertical speed
        lat = GPS(gpsIndex,8);
        lon = GPS(gpsIndex,9);
        gpsIndex = gpsIndex + 1;
    end
    
    %mag
    if magIndex < magLength && MAG(magIndex,2) > IMU(imuIndex-1,2) &&  MAG(magIndex,2) < IMU(imuIndex,2)
        updateMAG = 1;
        mag = MAG(magIndex,3:5)';
        if magIndex == 1
            yaw_deltat = 0;
        else
            yaw_deltat = (MAG(magIndex,2)-MAG(magIndex-1,2))/10^6;
        end
        magIndex = magIndex + 1;
   
    end
    
     %correct gyro drift
    driftCorrection(accel,delta_t,mag,gps)
    check_matrix();
    [roll, pitch, yaw] = getEulerFromDCM(dcm_matrix);
    angle(imuIndex,:) = [roll,pitch,yaw];
    
    %baro
    if baroIndex < baroLength && BARO(baroIndex,2) > IMU(imuIndex-1,2) && BARO(baroIndex,2) < IMU(imuIndex,2)
        baro_alt = BARO(baroIndex,3)*100;
        baro_update_time = BARO(baroIndex,2);
        baroIndex = baroIndex + 1;
    end
    
   % if ( baro_update_time ~= baro_last_update)
        correct_with_baro();
   % end
    
   % if (gps_update_time ~= gps_last_time)
        correct_with_gps(lon, lat)
   % end
   
    %inertialNav
    accel_ef(3) = accel_ef(3) + GRAVITY_MSS;
    accel_ef = accel_ef * 100;
    accel_ef(3) = -accel_ef(3);
    % accel
    accel_correction_ef(1) = accel_correction_ef(1) + position_error(1) * k3_xy * dt;
    accel_correction_ef(2) = accel_correction_ef(2) + position_error(2) * k3_xy * dt;
    accel_correction_ef(3) = accel_correction_ef(3) + position_error(3) * k3_z * dt;
    % velocity
    velocity(1) = velocity(1) + position_error(1) * k2_xy * dt;
    velocity(2) = velocity(2) + position_error(2) * k2_xy * dt;
    velocity(3) = velocity(3) + position_error(3) * k2_z * dt;
    % position_correction
    position_correction(1) = position_correction(1) + position_error(1) * k1_xy * dt;
    position_correction(2) = position_correction(2) + position_error(2) * k1_xy * dt;
    position_correction(3) = position_correction(3) + position_error(3) * k1_z * dt;
    velocity_increase = (accel_ef + accel_correction_ef) * dt;%v=at
    position_base = position_base + (velocity + velocity_increase*0.5)*dt;
    position = position_base + position_correction;
    velocity = velocity + velocity_increase;
    hist_position_estimate = position_base;
    vel(imuIndex,1:3) = velocity';
    pos(imuIndex,1:3) = position';
    imuIndex = imuIndex + 1;
end

%% drawPlot
drawPlot;