clear all;
close all;

%Question B1

T = 0.01; %Period
A = 4;
a = 0.5; % Roll - off factor
over = 10; 
kStep = 1;
k = [0 ,1 ,2, 3];
t_delay = k .* T ;
Ts = T / over ; % sampling period
phi = {}; 

%Set vars for each roll-off factor and plot
for i =1: length(a)
    [phi{i}, t] = srrc_pulse(T,over,A,a);
    subplot(length(k),1,i);
    for j=1:length(k)
        plot(t+t_delay(j),phi{i});
        hold on;
    end
    title(['SRRC, a=' num2str(a)]);
    legend ('k=0','k=1','k=2','k = 3');
    xlabel('Time');
    xlim([-A*T A*T]);
end

hold off;

%φ(t)*φ(t-kT)

t_delay2=k*T;

for i=1:length(a)
    figure
    for j=1:length(k)
        subplot(length(k),1,j);
        time = -A*T:Ts:A*T+k(j)*T;
        phi_t=[phi{i} zeros(1,k(j)*T/Ts)];   %Zero pdding
        phi_KT = [zeros(1,k(j)*T/Ts) phi{i}]; %zero padding
        result = phi_t.*phi_KT; %Multiply
        plot(time,result);
        xlim([-A*T A*T+k(j)*T]);
        title([' \phi(t) times \phi(t-Kt) with a=' num2str(a(i)), 'k=' num2str(k(j))]);
    end
    xlabel('Time');
end

%ypologismos olokliromatwn

k = [0 ,1 ,2, 3];
for i=1:length(a)
    fprintf('Integral of \phi(t) times \phi(t-kT) with a=%.1f and\n', a(i))
     for j=1:length(k)
        phi_t=[phi{i} zeros(1,k(j)*T/Ts)];
        phi_KT = [zeros(1,k(j)*T/Ts) phi{i}];
        result = phi_t.*phi_KT;
        v(i)=sum(result)*Ts;            
        fprintf('k=%d: %.6f\n', k(j), v(i))
     end
end
