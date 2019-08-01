%% roll
figure()
hold on
grid on
plot(IMU(:,2)/10^6,angle(:,1)*180/pi,'r');
plot(EKF1(:,2)/10^6,EKF1(:,3),'b');
legend('MECF','Pixhawk')
xlabel('time/s');ylabel('degree/。')
title('roll');
box on;
%% pitch
figure()
hold on
grid on
plot(IMU(:,2)/10^6,angle(:,2)*180/pi,'r');
plot(EKF1(:,2)/10^6,EKF1(:,4),'b');
legend('MECF','Pixhawk')
xlabel('time/s');ylabel('degree/。')
title('pitch');
box on;
%% yaw
figure()
hold on
grid on
plot(IMU(:,2)/10^6,angle(:,3)*180/pi,'r');
plot(EKF1(:,2)/10^6,EKF1(:,5),'b');
legend('MECF','Pixhawk')
xlabel('time/s');ylabel('degree/。')
title('yaw');
box on;
%% vx
figure()
hold on
grid on
plot(IMU(:,2)/10^6,vel(:,1)/100,'r');
plot(EKF1(:,2)/10^6,EKF1(:,6),'b');
legend('MECF','Pixhawk')
xlabel('time/s');ylabel('vel(m/s)。')
title('north');
box on;
%% vy
figure()
hold on
grid on
plot(IMU(:,2)/10^6,vel(:,2)/100,'r');
plot(EKF1(:,2)/10^6,EKF1(:,7),'b');
legend('MECF','Pixhawk')
xlabel('time/s');ylabel('vel(m/s)。')
title('east');
box on;
%% vz
figure()
hold on
grid on
plot(IMU(:,2)/10^6,-vel(:,3)/100,'r');
plot(EKF1(:,2)/10^6,EKF1(:,8),'b');
legend('MECF','Pixhawk')
xlabel('time/s');ylabel('vel(m/s)。')
title('down');
box on;
%% x
figure()
hold on
grid on
plot(IMU(:,2)/10^6,pos(:,1)/100,'r');
plot(EKF1(:,2)/10^6,EKF1(:,9),'b');
legend('MECF','Pixhawk')
xlabel('time/s');ylabel('pos(m)。')
title('north')
box on
%% y
figure()
hold on
grid on
plot(IMU(:,2)/10^6,pos(:,2)/100.5,'r');
plot(EKF1(:,2)/10^6,EKF1(:,10),'b');
legend('MECF','Pixhawk')
xlabel('time/s');ylabel('pos(m)。')
title('east')
%% z
figure()
hold on
grid on
plot(IMU(:,2)/10^6,-pos(:,3)/100,'r');
plot(EKF1(:,2)/10^6,EKF1(:,11),'b');
legend('MECF','Pixhawk')
xlabel('time/s');ylabel('pos(m)。')
title('down')
box on
%% flight trajectory
figure()
grid on
plot3(pos(:,1)/100,pos(:,2)/100,-pos(:,3)/100,'r');hold on
plot3(EKF1(:,9),EKF1(:,10),EKF1(:,11),'b')
legend('MECF','Pixhawk')
xlabel('north');ylabel('east'),zlabel('down');
title('flight path(unit:m)')
box on;