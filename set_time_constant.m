%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% file:set_time_constant.m
% date:2019/07/31
% author:YangYue
% email:qinguoxiaozi@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function set_time_constant()
global time_constant_xy;
global time_constant_z;
global k1_xy;
global k2_xy;
global k3_xy;
global k1_z;
global k2_z;
global k3_z;
% time constant
time_constant_xy = 2.5;
time_constant_z = 5;
k1_xy = 3 / time_constant_xy;
k2_xy = 3 / (time_constant_xy * time_constant_xy);
k3_xy = 1 / (time_constant_xy * time_constant_xy * time_constant_xy);
k1_z = 3 / time_constant_z;
k2_z = 3 /(time_constant_z * time_constant_z);
k3_z = 3 / (time_constant_z * time_constant_z * time_constant_z);
end