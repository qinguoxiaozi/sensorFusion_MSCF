%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% file:getRollPitchFromAccel.m
% date:2019/07/31
% author:YangYue
% email:qinguoxiaozi@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [roll, pitch] = getRollPitchFromAccel(accel)
 x = accel(1);
 y = accel(2);
 z = accel(3);
 gravity = 9.80665;
 length = sqrt(x^2 + y^2 +z^2);
 x = x*gravity/length;
 y = y*gravity/length;
 z = z*gravity/length;
 %% pitch-->-pi--pi
 pitch = asin(x/gravity);
 %% roll-->-pi--pi
 roll = atan(y/z);
end