clear all;
close all;

T = 0.01;                 %Period
over = 10;                %Over factor
Ts = T/over;              %Sampling Period
A = 4 ;                   
a = [0, 0.5, 1];          %Roll-off Factor
phi = {};                 %Initialization of truncated SRRC pulse
t = 0;                    %Initialization of time

%Question A1

figure(1)
grid on;
hold on;

%Set variables for each 'a' and plot
for i=1:length(a)
    [phi{i}, t] = srrc_pulse(T, over, A, a(i));
    plot(t,phi{i});
end
legend("a=0", "a=0.5","a=1")
xlim([-A*T A*T])
title("SRRC Pulses")
xlabel("Time")
hold off;

%Question A2

Fs = 1/Ts;  %Sampling Freq
%Nf = 1024;
Nf = 2048;  
phi_F = {}; 
phi_energy = {}; 

f_axis =  linspace(-Fs/2,(Fs/2-Fs/Nf),Nf);  %Freq range

figure(2)

hold on; grid on;
for i=1:length(a)
    phi_F{i} = fftshift(fft(phi{i}, Nf) * Ts); 
    phi_energy{i} = abs(phi_F{i}).^2;
    plot(f_axis, phi_energy{i}, 'LineWidth', 1.5);
end
legend("a=0", "a=0.5", "a=1");
title('Energy Spectral Density |\Phi(F)|^2 (Linear Scale)');
xlabel('Frequency (Hz)');
ylabel('|\Phi(F)|^2');
xlim([-1.5/T, 1.5/T]);
hold off;

%Set energy spectrum using semilogy

figure(3)
for i=1:length(a)
    semilogy(f_axis, phi_energy{i});
    hold on;
end
grid on;
legend("a=0", "a=0.5","a=1");
xlim([-Fs/2 Fs/2])
title('Energy (Nf=2048)');
xlabel('Frequency');
ylabel('Logarithmic');
hold off;

%Question 3

c1 = zeros(1,length(f_axis))+T/10^3;  
c2 = zeros(1,length(f_axis))+T/10^5; 

figure(4);

for i=1:length(a)
    semilogy(f_axis, phi_energy{i});
    hold on;
end
grid on;
title('Energy');
xlabel('Frequency');
ylabel('Logarithmic');
plot(f_axis, c1);
plot(f_axis, c2);
legend("a=0", "a=0.5","a=1", "c1 = T/10^3","c2 = T/10^5");
xlim([-Fs/2 Fs/2])
hold off;

