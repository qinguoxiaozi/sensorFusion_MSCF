%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% file:correct_with_gps.m
% date:2019/07/31
% author:YangYue
% email:qinguoxiaozi@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function correct_with_gps(lon, lat)
global gps_last_time;
global gps_update_time;
global base_lat;
global base_lon;
global LATLON_TO_CM;
global lon_to_cm_scaling;
% 3*1 vector
global position_correction;
global hist_position_estimate;
global position_error;
x = (lat - base_lat) * LATLON_TO_CM;
y = (lon - base_lon) * lon_to_cm_scaling;
position_error(1) = x - (hist_position_estimate(1) + position_correction(1));
position_error(2) = y - (hist_position_estimate(2) + position_correction(2));
gps_last_time = gps_update_time;
end