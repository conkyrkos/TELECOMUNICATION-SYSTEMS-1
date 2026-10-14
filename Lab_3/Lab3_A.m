clear all;
close all;

%% Variable decleration

N = 200;
A = 1;
A_SRRC = 4;
a = 0.5;
T = 0.001;
over = 10;
Ts = T/over;
Fs = 1/Ts;
Nf = 2048;

% A.1

bits = (sign(randn(4*N, 1)) + 1)/2;

% A.3

% [0,2N]
bitXI = bits(1:2*N);
XIn = bits_to_4_PAM(bitXI, A);

% [2N+1,4N]
bitXQ = bits(2*N+1:4*N);
XQn = bits_to_4_PAM(bitXQ, A);

%% A.4

% Creating the pulse
[phi, t] = srrc_pulse(T, over, A_SRRC, a);

% Upsample the 2 sequencies
XIn_up = (1/Ts)*upsample(XIn, over);
XI_up_time = 0:Ts:N*T-Ts;

XQn_up = (1/Ts)*upsample(XQn, over);
XQ_up_time = XI_up_time;

% Convolutions and time
XIt = Ts*conv(XIn_up, phi);
XQt = Ts*conv(XQn_up, phi);
conv_t = t(1) + XQ_up_time(1):Ts:t(end) + XQ_up_time(end);

% Output waveform plots
figure;
plot(conv_t, XIt);
title("Output waveform XI(t)");
xlabel("t");
ylabel("XI(t)");
xlim([conv_t(1) conv_t(end)]);

figure;
plot(conv_t, XQt);
title("Output waveform XQ(t)");
xlabel("t");
ylabel("XQ(t)");
xlim([conv_t(1) conv_t(end)]);

% Frequency Range
f_axis = linspace(-Fs/2,(Fs/2-Fs/Nf), Nf);

% Periodograms 
XIF = fftshift(fft(XIt, Nf)*Ts);
num = power(abs(XIF),2);
T_total = conv_t(end) - conv_t(1);
PXIF = num/T_total;

XQF = fftshift(fft(XQt, Nf)*Ts);
num = power(abs(XQF),2);
T_total = conv_t(end) - conv_t(1);
PXQF = num/T_total;

%  plots
figure;
plot(f_axis, PXIF);
title("Periodogram of XI(t)");
xlabel("f");
ylabel("Px(F)");

figure;
plot(f_axis, PXQF);
title("Periodogram of XQ(t)");
xlabel("f");
ylabel("Px(F)");

% A.5

Fo = 2000;
XImod_t = 2*XIt.*cos(2*pi*Fo*conv_t);
XQmod_t = -2*XQt.*sin(2*pi*Fo*conv_t);

% Plots 
figure;
plot(conv_t, XImod_t);
title("2XI(t)cos(2πFot)");
xlabel("t");
ylabel("XI(t)");
xlim([conv_t(1) conv_t(end)]);

figure;
plot(conv_t, XQmod_t);
title("-2XQ(t)sin(2πFot)");
xlabel("t");
ylabel("XQ(t)");
xlim([conv_t(1) conv_t(end)]);

% Periodograms 
XIFmod = fftshift(fft(XImod_t, Nf)*Ts);
num = power(abs(XIFmod),2);
T_total = conv_t(end) - conv_t(1);
PXIFmod = num/T_total;

XQFmod = fftshift(fft(XQmod_t, Nf)*Ts);
num = power(abs(XQFmod),2);
T_total = conv_t(end) - conv_t(1);
PXQFmod = num/T_total;

%  plots
figure;
plot(f_axis, PXIFmod);
title("Periodogram of XI(t)mod");
xlabel("f");
ylabel("Px(F)");

figure;
plot(f_axis, PXQFmod);
title("Periodogram of XQ(t)mod");
xlabel("f");
ylabel("Px(F)");

%% A.6

% Input signal creation 
Xmod_t = XImod_t + XQmod_t;

%  Xmod(t)
figure;
plot(conv_t, Xmod_t);
title("Input waveform X(t)mod");
xlabel("t");
ylabel("X(t)");
xlim([conv_t(1) conv_t(end)]);

% Periodogram 
Xmod_F = fftshift(fft(Xmod_t, Nf)*Ts);
num = power(abs(Xmod_F),2);
T_total = conv_t(end) - conv_t(1);
PXmod = num/T_total;

%  plot
figure;
plot(f_axis, PXmod);
title("Periodogram of X(t)mod");
xlabel("f");
ylabel("Px(F)");
% A.8

%Noise 
SNR = 10;
variance = (10*(A^2))/(Ts*(10^(SNR/10)));
gaussian_noise = sqrt(variance)*randn(1,length(Xmod_t));

% Adding noise to the waveform
Xmod_noise = Xmod_t + gaussian_noise;

% A.9

% Demodulating the signal
XImod_noise = Xmod_noise.*cos(2*pi*Fo*conv_t);
XQmod_noise = -Xmod_noise.*sin(2*pi*Fo*conv_t);

% Plot the signals
figure;
plot(conv_t, XImod_noise);
title("XI(t)cos(2πFot)")
xlabel("t");
ylabel("XI(t)");
xlim([conv_t(1) conv_t(end)]);

figure;
plot(conv_t, XQmod_noise);
title("-XQ(t)sin(2πFot)")
xlabel("t");
ylabel("XQ(t)");
xlim([conv_t(1) conv_t(end)]);

% Periodograms creation
XImod_noise_F = fftshift(fft(XImod_noise, Nf)*Ts);
num = power(abs(XImod_noise_F),2);
T_total = conv_t(end) - conv_t(1);
PXImod_noise = num/T_total;

XQmod_noise_F = fftshift(fft(XQmod_noise, Nf)*Ts);
num = power(abs(XQmod_noise_F),2);
T_total = conv_t(end) - conv_t(1);
PXQmod_noise = num/T_total;

% Plot the periodogram
figure;
plot(f_axis, PXImod_noise);
title("Periodogram of XI(t)")
xlabel("f");
ylabel("Px(F)");

figure;
plot(f_axis, PXQmod_noise);
title("Periodogram of XQ(t)")
xlabel("f");
ylabel("Px(F)");

% A.10

% Filter the waveforms
XIt_demodulated = Ts*conv(XImod_noise, phi);
XQt_demodulated = Ts*conv(XQmod_noise, phi);
conv_t2 = t(1) + conv_t(1):Ts:t(end) + conv_t(end);

% Plot the filtered waveforms
figure;
plot(conv_t2, XIt_demodulated);
title("Filtered XI(t)")
xlabel("t");
ylabel("XI(t)");
xlim([conv_t2(1) conv_t2(end)]);

figure;
plot(conv_t2, XQt_demodulated);
title("Filtered XQ(t)")
xlabel("t");
ylabel("XQ(t)");
xlim([conv_t2(1) conv_t2(end)]);

XIF_demodulated = fftshift(fft(XIt_demodulated, Nf)*Ts);
num = power(abs(XIF_demodulated),2);
T_total = conv_t2(end) - conv_t2(1);
PXI_demodulated = num/T_total;

XQF_demodulated = fftshift(fft(XQt_demodulated, Nf)*Ts);
num = power(abs(XQF_demodulated),2);
T_total = conv_t2(end) - conv_t2(1);
PXQ_demodulated = num/T_total;

% Plot the periodogram of filtered waveforms
figure;
plot(f_axis, PXI_demodulated);
title("Periodogram of XI(t)")
xlabel("f");
ylabel("PxI(F)");

figure;
plot(f_axis, PXQ_demodulated);
title("Periodogram of XQ(t)")
xlabel("f");
ylabel("PxQ(F)");

% A.11

XIt_demodulated_sampling= XIt_demodulated((2*A_SRRC*T/Ts)+1:over:length(XIt_demodulated)-(2*A_SRRC*T/Ts));
XQt_demodulated_sampling= XQt_demodulated((2*A_SRRC*T/Ts)+1:over:length(XQt_demodulated)-(2*A_SRRC*T/Ts));

for i=1:N
    sampling(i,1)=XIt_demodulated_sampling(i); 
    sampling(i,2)=XQt_demodulated_sampling(i);
end
scatterplot(sampling)

% Get the current figure handle
hFig = gcf;
% Set the figure background color to white
set(hFig, 'Color', [1 1 1]);

% Get the current axes handle
hAxes = gca;
% Set the axes background color to white
set(hAxes, 'Color', [1 1 1]);

% A.12

% Estimating the symbols value
for i = 1:N
    detected_XI(i) = detect_4_PAM(XIt_demodulated_sampling(i), A);
    detected_XQ(i) = detect_4_PAM(XQt_demodulated_sampling(i), A);
end

% A.13

x_sent = [XIn; XQn];
x_detected = [detected_XI; detected_XQ];

errors_num = 0;
for i = 1:N
    for j = 1:2
        difference(j,i) = x_sent(j,i) - x_detected(j,i);
        if (difference(j,i) ~= 0)
            errors_num = errors_num + 1;
        end
    end
end
errors_num

% A.15

bitXI_received = PAM_4_to_bits(detected_XI, A);
bitXQ_received = PAM_4_to_bits(detected_XQ, A);

estimated_bits = [bitXI_received bitXQ_received];
difference = estimated_bits - bits;
errors_in_bits = 0;
for i = 1:4*N
        if (difference(i) ~= 0)
            errors_in_bits = errors_in_bits + 1;
        end
end
errors_in_bits