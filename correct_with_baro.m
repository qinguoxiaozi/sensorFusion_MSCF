%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% file:correct_with_baro.m
% date:2019/07/31
% author:YangYue
% email:qinguoxiaozi@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function correct_with_baro()
global baro_last_update;
global baro_update_time;
global baro_alt;
% 3*1 vector
global position_error;
global hist_position_estimate;
global position_correction;
position_error(3) = baro_alt - (hist_position_estimate(3)+position_correction(3));
baro_last_update = baro_update_time;
end