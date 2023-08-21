close all;clear;clc;

load('amp_mod_curve.mat')
load('amp_mod_measurements.mat')
amp_measurements = avg_amp;
clear avg_amp;

offset = 0.75*2*pi;

N=128;
phase = offset + (1:N)*2*pi/N;
phase_modulation_range = offset + pi + (1:N/2)*2*pi/N;

figure(1);
hold on;
% plot(phase,amp_measurements,'LineWidth',2);
amp_error = ones(N,1)*0.01; phase_error = ones(N,1)*2*pi/255;
errorbar(phase,amp_measurements, amp_error,amp_error,phase_error,phase_error, '.' );
plot(phase,( cos((phase-offset+0.16)/2) ).^2 *0.55,'g-','LineWidth',2);
plot(phase_modulation_range,( cos((phase_modulation_range-offset)/2) ).^2 *0.51+0.04,'r-','LineWidth',2);
legend({'gemessen','theoretisch','angepasst'},'Position',[0.45,0.75,0.1,0.1]);
%%% amp_phase = offset +- 2*acos( amplitude );
%%% amplitude = cos((amp_phase-offset)/2);
ylabel('amplitude','FontSize',16);xlabel('phase','FontSize',16);
hold off;
ax = gca;
ax.FontSize = 16; 
print(gcf,'amp_mod_measurement.png','-dpng','-r300');

%% -----

%position and values of max/min amplitude
[ampmin,xminp] = min(amp_measurements);
xmaxp = xminp+round(N/2);
ampmax = amp_measurements(xmaxp);

%fitting
amp_pos = xminp:xmaxp;
amp_measurements_reordered = amp_measurements(amp_pos);

phase_reordered = amp_pos*2*pi/N + offset;
ampcoeff = polyfit(amp_measurements_reordered,phase_reordered,9); %polynomial fit

amplitude_high_res = ampmin:0.01:ampmax;
phase_interpolated = polyval(ampcoeff,amplitude_high_res);
phase_theoretisch = offset-2*acos(sqrt(linspace(0,1,numel(amplitude_high_res))))+2*pi;

figure(2);
hold on
% plot(amp_measurements_reordered,phase_reordered,'o','LineWidth',2);
amp_error = ones(numel(amp_pos),1)*0.01; phase_error = ones(numel(amp_pos),1)*2*pi/255;
errorbar(amp_measurements_reordered,phase_reordered, amp_error,amp_error,phase_error,phase_error, '.' );
plot(amplitude_high_res,phase_interpolated,'g-','LineWidth',2);
plot(amplitude_high_res,phase_theoretisch,'r-','LineWidth',2);
legend({'gemessen','interpoliert','theoretisch'},'Position',[0.3,0.75,0.1,0.1]);
xlabel('amplitude','FontSize',16);ylabel('phase','FontSize',16);
hold off
ax = gca;
ax.FontSize = 16;
print(gcf,'amp_mod_fit.png','-dpng','-r300');
