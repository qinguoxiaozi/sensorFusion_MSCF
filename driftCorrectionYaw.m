%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% file:driftCorrectionYaw.m
% date:2019/07/31
% author:YangYue
% email:qinguoxiaozi@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function driftCorrectionYaw(mag)
global dcm_matrix;
global roll;
global pitch;
global mag_earth;
global omega;
global kp_yaw;
global omega_yaw_P;
global updateMAG;
global last_declination;
global yaw_deltat;
global omega_I_sum;
global ki_yaw;


if updateMAG==0
    omega_yaw_P = omega_yaw_P * 0.97;
    return
end
updateMAG = 0;

heading = CompassCalculateHeading(mag,dcm_matrix);
dcm_matrix = getDCMFromEuler(roll,pitch,heading);
temp = dcm_matrix*mag;
rb = temp(1:2);
rb = rb/norm(rb);

mag_earth(1) = cos(last_declination);
mag_earth(2) = sin(last_declination);

yaw_error = rb(1)*mag_earth(2)-rb(2)*mag_earth(1);

error_z = dcm_matrix(3,3)*yaw_error;
spin_rate = norm(omega);

omega_yaw_P(3) = error_z * PGain(spin_rate) * kp_yaw;

if yaw_deltat < 2
    omega_I_sum(3) = omega_I_sum(3) + error_z * ki_yaw * yaw_deltat;
end
end