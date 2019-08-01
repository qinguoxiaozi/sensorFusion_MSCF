%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% file:PGain.m
% date:2019/07/31
% author:YangYue
% email:qinguoxiaozi@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function gain = PGain(spin_rate)
if spin_rate < 50*pi/180
    gain = 1;
    return;
end
if spin_rate > 500*pi/180
    gain = 10;
    return;
end
gain = spin_rate/(50*pi/180);
end