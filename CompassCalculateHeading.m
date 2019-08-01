%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% file:CompassCalculateHeading.m
% date:2019/07/31
% author:YangYue
% email:qinguoxiaozi@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function yaw = CompassCalculateHeading(mag,dcm)

cos_pitch_sq = 1.0 - dcm(3,1)*dcm(3,1);
hy = mag(2) * dcm(3,3) - mag(3) * dcm(3,2);
hx = mag(1) * cos_pitch_sq - dcm(3,1)*(mag(2) * dcm(3,2) + mag(3)*dcm(3,3));
yaw = getYawFromMag([hx,hy,0]);

end