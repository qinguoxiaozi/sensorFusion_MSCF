%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% file:check_matrix.m
% date:2019/07/31
% author:YangYue
% email:qinguoxiaozi@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function check_matrix()
global dcm_matrix;
% dcm_matrix
if dcm_matrix(3,1) >= 1 || dcm_matrix(3,1) <= -1
    normlizeMatrix()
end
end