%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% file:normlizeMatrix.m
% date:2019/07/31
% author:YangYue
% email:qinguoxiaozi@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function normlizeMatrix()
global dcm_matrix;
error = dcm_matrix(1,:)*dcm_matrix(2,:)';
t0 = dcm_matrix(1,:) - (dcm_matrix(2,:)*(0.5*error));
t1 = dcm_matrix(2,:) - (dcm_matrix(1,:)*(0.5*error));
t2 = cross(t0,t1);
t0 = t0/norm(t0);
t1 = t1/norm(t1);
t2 = t2/norm(t2);
dcm_matrix(1,:) = t0;
dcm_matrix(2,:) = t1;
dcm_matrix(3,:) = t2;
end