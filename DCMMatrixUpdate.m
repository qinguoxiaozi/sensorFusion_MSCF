%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% file:DCMMatrixUpdate.m
% date:2019/07/31
% author:YangYue
% email:qinguoxiaozi@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function DCMMatrixUpdate(gyro,G_Dt)
global omega_I;
global dcm_matrix;
global omega;
global omega_P;
global omega_yaw_P;
% omega = gyro*pi/180 + omega_I;
omega = gyro + omega_I;
% omega
% omega_P
% omega_yaw_P
% omega_I
temp = (omega + omega_P + omega_yaw_P)*G_Dt;
dcm_matrix = dcm_matrix*[1,        -temp(3), temp(2);
                         temp(3),  1,        -temp(1);
                         -temp(2), temp(1),  1];
end