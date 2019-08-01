%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% file:driftCorrection.m
% date:2019/07/31
% author:YangYue
% email:qinguoxiaozi@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function driftCorrection(accel,deltat,mag,gps)
global dcm_matrix;
global accel_ef;
global ra_sum;
global ra_deltat;
global last_velocity;
global last_lat;
global last_lng;
global GRAVITY_MSS;
global omega;
global omega_P;
global omega_I;
global kp;
global ki;
global omega_I_sum;
global omega_I_sum_time;
global updateGPS;
global ra_sum_start;
global SPIN_RATE_LIMIT;
global gyro_drift_limit;

temp_dcm = dcm_matrix;
driftCorrectionYaw(mag);
accel_ef = temp_dcm*accel;

ra_sum = ra_sum + accel_ef*deltat;

ra_deltat = ra_deltat + deltat;

if updateGPS == 0
    return;
end

updateGPS = 0;

% north, east, down
velocity = [gps(4);gps(5);gps(6)];

last_lat = gps(1);
last_lng = gps(2);

if ra_sum_start==0
    ra_sum_start = 1;
    last_velocity = velocity;
    return;
end

GA_e = [0;0;-1];
v_scale = 1/(ra_deltat*GRAVITY_MSS);
vdelta = (velocity - last_velocity) * v_scale;
GA_e = GA_e + vdelta;
GA_e = GA_e/norm(GA_e);
ra_sum = ra_sum/(ra_deltat * GRAVITY_MSS);
GA_b = ra_sum;
GA_b = GA_b / norm(GA_b);
error = cross(GA_b,GA_e);
error(3) = 0;
error = dcm_matrix' * error;
spin_rate = norm(omega);
omega_P = error * PGain(spin_rate) * kp;
if spin_rate < SPIN_RATE_LIMIT*pi/180
    omega_I_sum = omega_I_sum + error * ki * ra_deltat;
    omega_I_sum_time = omega_I_sum_time + ra_deltat;
end
if omega_I_sum_time >= 5
    change_limit = gyro_drift_limit * omega_I_sum_time;
    for i=1:3
        if omega_I_sum(i) < -change_limit
            omega_I_sum(i) = -change_limit;
        end
        if omega_I_sum(i) > change_limit
            omega_I_sum(i) = change_limit;
        end
    end
    omega_I = omega_I + omega_I_sum;
    omega_I_sum = zeros(3,1);
    omega_I_sum_time = 0;
end
ra_sum = [0;0;0];
ra_deltat = 0;
last_velocity = velocity;
end