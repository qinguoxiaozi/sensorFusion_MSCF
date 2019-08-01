%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% file:getYawFromMag.m
% date:2019/07/31
% author:YangYue
% email:qinguoxiaozi@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function yaw = getYawFromMag(mag)
 x = mag(1);y = mag(2);
 yaw = atan2(y,x);
 if yaw<0
    yaw = yaw + 2*pi;
 end
end