%% MINI-PROJECT 1 %% TASK 1

% Consider the event driven simulator Simulator1 used in Task 5 of the
% Practical Guide.

%% 1.a. 
% Consider the case of C = 10 Mbps and f = 1.000.000 Bytes. Run Simulator1 
% 50 times with a stopping criterion of P = 10000 each run and compute the 
% estimated values and the 90% confidence intervals of the average delay 
% performance parameter when lamb = 400, 800, 1200, 1600 and 2000 pps. 
% Present the average packet delay results in bar charts with the confidence 
% intervals in error bars1. Justify the results and take conclusions 
% concerning the impact of the packet rate in the obtained average packet delay.

lambda = [400, 800, 1200, 1600, 2000]; 
C = 10;
f = 1000000;
P = 10000;
N = 50;
alfa = 0.1;

PL = zeros(1,5);
APD = zeros(1,5);
MPD = zeros(1,5);
TT = zeros(1,5);
mediaAPD = zeros(1,5);
termAPD = zeros(1,5);

for i= 1:length(lambda)
    for it= 1:N
        [PL(it), APD(it), MPD(it), TT(it)] = Simulator1(lambda(i),C,f,P);
    end
    mediaAPD(i) = mean(APD);
    termAPD(i) = norminv(1-alfa/2)*sqrt(var(APD)/N);
end

figure(1);
h = bar(lambda,mediaAPD);
hold on
er = errorbar(lambda,mediaAPD,termAPD);
er.Color = [0 0 0];
er.LineStyle = 'none';
grid on
title('Average Packet Delay');
xlabel('Lambda (pps)');
ylabel('Average packet delay (ms)');
hold off

%% 1.b. 
% Consider the case of lambda = 1800 pps and C = 10 Mbps. Run Simulator1 50 times
% with a stopping criterion of P = 10000 each run and compute the estimated 
% values and the 90% confidence intervals of the average delay and packet 
% loss performance parameters when f = 100.000, 20.000, 10.000 and 2.000 
% Bytes. Present the average packet delay results in one figure and the 
% average packet loss results in another figure (in both cases, in bar charts
% with the confidence intervals in error bars). Justify the results and 
% take conclusions concerning the impact of the queue size in the obtained 
% average packet delay and average packet loss.

lambda = 1800;
C = 10;
f = [2000, 10000, 20000, 100000];
P = 10000;
N = 50;
alfa = 0.1;

PL = zeros(1,4);
APD = zeros(1,4);
MPD = zeros(1,4);
TT = zeros(1,4);
mediaPL = zeros(1,4);
termPL = zeros(1,4);
mediaAPD = zeros(1,4);
termAPD = zeros(1,4);

for i= 1:length(f)
    for it= 1:N
        [PL(it), APD(it), MPD(it), TT(it)] = Simulator1(lambda,C,f(i),P);
    end
    mediaPL(i) = mean(PL);
    termPL(i) = norminv(1-alfa/2)*sqrt(var(PL)/N);
    mediaAPD(i) = mean(APD);
    termAPD(i) = norminv(1-alfa/2)*sqrt(var(APD)/N);
end

figure(2);
h = bar(f,mediaPL);
hold on
er = errorbar(f,mediaPL,termPL);
er.Color = [0 0 0];
er.LineStyle = 'none';
grid on
title('Average Packet Loss');
xlabel('Queue size (bytes)');
ylabel('Average packet poss (%)');
hold off

figure(3);
h = bar(f,mediaAPD);
hold on
er = errorbar(f,mediaAPD,termAPD);
er.Color = [0 0 0];
er.LineStyle = 'none';
grid on
title('Average Packet Delay');
xlabel('Queue size (bytes)');
ylabel('Average packet delay (ms)');
hold off


%% 1.c. 
% Consider the case of lambda = 1800 pps and f = 1.000.000 Bytes. Run Simulator1 
% 50 times with a stopping criterion of P = 10000 at each run and compute 
% the estimated values and the 90% confidence intervals of the average delay 
% performance parameter when C = 10, 20, 30 and 40 Mbps. Present the average 
% packet delay results in bar charts with the confidence intervals in error
% bars. Justify the results and take conclusions concerning the impact of
% the link capacity in the obtained average packet delay.

lambda = 1800; 
C = [10, 20, 30, 40]; 
f = 1000000;    
P = 10000;      
N = 50;         
alfa = 0.1;     

PL = zeros(1,4);    
APD = zeros(1,4);   
MPD = zeros(1,4);   
TT = zeros(1,4);    
mediaAPD = zeros(1,4);
termAPD = zeros(1,4);

for i= 1:length(C)
    for it= 1:N
        [PL(it), APD(it), MPD(it), TT(it)] = Simulator1(lambda,C(i),f,P);
    end
    mediaAPD(i) = mean(APD);
    termAPD(i) = norminv(1-alfa/2)*sqrt(var(APD)/N);
end

figure(4);
h = bar(C,mediaAPD);
hold on
er = errorbar(C,mediaAPD,termAPD);
er.Color = [0 0 0];
er.LineStyle = 'none';
grid on
title('Average Packet Delay');
xlabel('Link bandwidth (Mbps)');
ylabel('Average packet delay (ms)');
hold off


%% 1.d. 
% Consider that the system is modelled by a M/G/1 queueing model. Determine 
% the theoretical values of the average packet delay using the M/G/1 model 
% for all cases of 1.c. Compare the theoretical values with the simulation 
% results of experiments 1.c and take conclusions.

% lambda = 1800;
% size = MeanPacketSize();
% atrasoMG1_10 = TheoAvgDelayMG1(lambda,10,size)*1000;
% fprintf('------ lamb=1800 ; C=10 ------\n');
% fprintf("Average packet delay (ms) = %.4f\n", atrasoMG1_10);

lambda = 1800;
C = [10, 20, 30, 40];
f = 1000000;
P = 10000;
N = 50; 
alfa = 0.1;

PL = zeros(1,4);
APD = zeros(1,4);
MPD = zeros(1,4);
TT = zeros(1,4);

size = MeanPacketSize();
sim_APD = zeros(1,4);
the_APD = zeros(1,4);
the_APD_2 = zeros(1,4);

for i = 1:length(C)
    for it= 1:N
        [PL(it), APD(it), MPD(it), TT(it)] = Simulator1(lambda,C(i),f,P);
        the_APD_2 = TheoAvgDelayMG1(lambda,C(i),size)*1000;
    end
    sim_APD(i) = mean(APD);
    the_APD(i) = mean(the_APD_2);
end

figure(5);
h = bar(C,[sim_APD; the_APD]);
hold on
grid on
title("Average Packet Deplay (MG1 queueing model)");
legend('Simulation','Theoretical', 'location', 'northeast')
xlabel('Link bandwidth (Mbps)');
ylabel('Average packet delay (ms)');
hold off

%% 1.e. 
% Develop a new version of Simulator1 to estimate 3 additional performance 
% parameters: the average packet delay of the packets of size 64, 110 and 
% 1518 Bytes, respectively. Consider the case of lambda = 1800 pps and 
% f = 1.000.000. Run the new version of Simulator1 50 times with a stopping 
% criterion of P = 10000 at each run and compute the estimated values and 
% the 90% confidence intervals of the 3 new average delay performance 
% parameters when C = 10, 20, 50 and 100 Mbps. Present the average packet 
% delay results in bar charts with the confidence intervals in error bars. 
% Justify these results and the differences between them and the results of
% 1.c. Take conclusions concerning the impact of the link capacity in the 
% obtained average packet delay of packets with different sizes.




%% LAB 1 %% AUXILIAR FUNCTIONS

function miu = Miu(C,size)
     miu=(C*10^6)/size;
 end

function avgMG1 = TheoAvgDelayMG1(lambda,C,size)
    es = ES(C);
    es2 = ES2(C);
    avgMG1 = ((lambda * es2 ) / (2 * (1 - lambda * es))) + es;
end

function es2 = ES2(C)
    k = (0.41/((109 - 65 + 1)+(1517 - 111 + 1)));
    es2 = 0.19 * ((64*8)/(C*10^6))^2 + 0.23 * ((110*8)/(C*10^6))^2 + 0.17 * ((1518*8)/(C*10^6))^2;
    for n = 65:109
        es2 = es2 + k * ((n * 8)/(C*10^6))^2;
    end
    for n = 111:1517
         es2 = es2 + k * ((n * 8)/(C*10^6))^2;
    end
end

function es = ES(C)
    k = (0.41/((109 - 65 + 1)+(1517 - 111 + 1)));
    es = 0.19 * ((64*8)/(C*10^6)) + 0.23 * ((110*8)/(C*10^6)) + 0.17 * ((1518*8)/(C*10^6));
    for n = 65:109
        es = es + k * ((n*8)/(C*10^6));
    end
    for n = 111:1517
         es = es + k * ((n*8)/(C*10^6));
    end
end

function mean = MeanPacketSize()
    mean = 0.19 * (64*8) + 0.23 * (110*8) + 0.17 * (1518*8);
    for n = 65:109
        mean = mean + ((0.41/((109 - 65 + 1)+(1517 - 111 + 1))) * (n*8));
    end
    for j = 111:1517
        mean = mean + ((0.41/((109 - 65 + 1)+(1517 - 111 + 1))) * (j*8));
    end
end