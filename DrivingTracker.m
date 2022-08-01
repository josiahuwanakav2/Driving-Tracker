clear; clc;
%I first loaded the data from the file. The file was saved as "rush hour"
%from the app, and was converted to that format when saved, uploaded, and
%downloaded.
load('rush+hour.mat');
%---------------------------------------------------------
%TimeStamp Variables
x = Position.Timestamp(end,:)-Position.Timestamp(1,:);
x = seconds(x);
time = 1:1:(x+1);
time = time';
v = Position.speed;
%Position Variables foir the Map
lat = Position.latitude;
lat(1,:) = [];
lon = Position.longitude;
lon(1,:) = [];
% normalizes speed < 1mph to 0
v(v < 0.447) = 0;
%Safety Thresholds are being set for tracking
uppert = 1.5;
lowert = -1.5;
%Acceleration and Brake Tracking
a = diff(v);
track = a >= uppert | a <= lowert;
tracka = a >= uppert;
trackb = a <= lowert;
%Setting tracked data to be the only values to be mapped
newa = a;
newa(~track) = NaN;
speed = a; speed(~tracka) = NaN; speed(tracka) = 1;
brake = a; brake(~trackb) = NaN; brake(trackb) = -1;
%geobubble variables with magnitude
speedm = a; speedm(~tracka) = NaN;
brakem = a; brakem(~trackb) = NaN;
%plotting graph with annotations
y1 = polyval(uppert,time);
y2 = polyval(lowert,time);
figure('Name','Acceleration Versus Time');
plot(time,a,'.',time,newa,'o',time,y1,'r',time,y2,'r');
legend('all acceleration','unsafe acceleration','unsafe acceleration threshold','unsafe breaking threshold');
xlabel('Time from the beginning of drive, s, (seconds)'); ylabel('acceleration');
title('Safe and Unsafe Acceleration/Breaking over time of drive');
%plotting geobubble without magnitude with annotations
figure('Name','Acceleration Points');
geobubble(lat,lon,speed);
title('Unsafe Accelerations Over Drive');
figure('Name','Braking Points');
geobubble(lat,lon,brake);
title('Unsafe Braking Over Drive');
%plotting with magnitude and annotations
figure('Name','Magnitude Acceleration');
geobubble(lat,lon,speedm);
title('Unsafe Accelerations Over Drive with Magnitude');
figure('Name','Magnitude Braking');
geobubble(lat,lon,brakem);
title('Unsafe Braking Over Drive with Magnitude');