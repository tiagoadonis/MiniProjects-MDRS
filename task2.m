%% MINI-PROJECT 1 %% TASK 2

% Consider the event driven simulators Simulator3 and Simulator4 developed 
% in Task 7 of the Practical Guide.

%% 2.a. 
% Consider the case of lambda = 1500 pps, C = 10 Mbps and f = 1.000.000 Bytes. 
% Run Simulator3 50 times with a stopping criterion of P = 10000 each run 
% and compute the estimated values and the 90% confidence intervals of the 
% average delay performance parameter of data packets and VoIP packets when 
% n = 10, 20, 30 and 40 VoIP flows. Present the average data packet delay 
% results in one figure and the average VoIP packet delay results in another
% figure (in both cases, in bar charts with the confidence intervals in 
% error bars). Justify the results and take conclusions concerning the impact 
% of the number of VoIP flows in the obtained average packet delay of each 
% service when both services (data and VoIP) are statistically multiPLdataexed 
% in a single FIFO queue.

lambda = 1500; 
C = 10;
f = 1000000;
P = 10000;
N = 50;
n = [10, 20, 30, 40];
alfa = 0.1;
PLdata = zeros(1,4);
APDdata = zeros(1,4);
MPDdata = zeros(1,4);
PLvoip = zeros(1,4);
APDvoip = zeros(1,4);
MPDvoip = zeros(1,4);
TT = zeros(1,4); 
mediaAPDdata = zeros(1,4);
termAPDdata = zeros(1,4);
mediaAPDvoip = zeros(1,4);
termAPDvoip = zeros(1,4);
for i= 1:length(n)
    for it= 1:N
        [PLdata(it), APDdata(it), MPDdata(it), TT(it), PLvoip(it), APDvoip(it), MPDvoip(it)] = Simulator3(lambda,C,f,P,n(i));
    end
    mediaAPDdata(i) = mean(APDdata);
    termAPDdata(i) = norminv(1-alfa/2)*sqrt(var(APDdata)/N);
    mediaAPDvoip(i) = mean(APDvoip);
    termAPDvoip(i) = norminv(1-alfa/2)*sqrt(var(APDvoip)/N);
end

figure(1);
h = bar(n,mediaAPDdata);
hold on
er = errorbar(n,mediaAPDdata,termAPDdata);
er.Color = [0 0 0];
er.LineStyle = 'none';
grid on
title('Average Data Packet Delay');
xlabel('n (number of Data packets flows)');
ylabel('Average Data packet delay (ms)');
hold off

figure(2);
h = bar(n,mediaAPDvoip);
hold on
er = errorbar(n,mediaAPDvoip,termAPDvoip);
er.Color = [0 0 0];
er.LineStyle = 'none';
grid on
title('Average VoIP Packet Delay');
xlabel('n (number of VoIP packets flows)');
ylabel('Average VoIP packet delay (ms)');
hold off

%% 2.b. 
% Repeat experiment 2.a but now with Simulator4. Justify these results and 
% the differences between them and the results of 2.a. Take conclusions 
% concerning the impact of the number of VoIP flows in the obtained average 
% packet delay of each service when VoIP service is supported with a priority 
% which is higher than the data service.

lambda = 1500; 
C = 10;
f = 1000000;
P = 10000;
N = 50;
n = [10, 20, 30, 40];
alfa = 0.1;
PLdata = zeros(1,4);
APDdata = zeros(1,4);
MPDdata = zeros(1,4);
PLvoip = zeros(1,4);
APDvoip = zeros(1,4);
MPDvoip = zeros(1,4);
TT = zeros(1,4); 
mediaAPDdata = zeros(1,4);
termAPDdata = zeros(1,4);
mediaAPDvoip = zeros(1,4);
termAPDvoip = zeros(1,4);
for i= 1:length(n)
    for it= 1:N
        [PLdata(it), APDdata(it), MPDdata(it), TT(it), PLvoip(it), APDvoip(it), MPDvoip(it)] = Simulator4(lambda,C,f,P,n(i));
    end
    mediaAPDdata(i) = mean(APDdata);
    termAPDdata(i) = norminv(1-alfa/2)*sqrt(var(APDdata)/N);
    mediaAPDvoip(i) = mean(APDvoip);
    termAPDvoip(i) = norminv(1-alfa/2)*sqrt(var(APDvoip)/N);
end
figure(3);
h = bar(n,mediaAPDdata);
hold on
er = errorbar(n,mediaAPDdata,termAPDdata);
er.Color = [0 0 0];
er.LineStyle = 'none';
grid on
title('Average Data Packet Delay');
xlabel('n (number of Data packets flows)');
ylabel('Average Data packet delay (ms)');
hold off
figure(4);
h = bar(n,mediaAPDvoip);
hold on
er = errorbar(n,mediaAPDvoip,termAPDvoip);
er.Color = [0 0 0];
er.LineStyle = 'none';
grid on
title('Average VoIP Packet Delay');
xlabel('n (number of VoIP packets flows)');
ylabel('Average VoIP packet delay (ms)');
hold off

%% 2.c. 
% Consider that the system is modelled by a M/G/1 queueing model with 
% priorities. Determine the theoretical values of the average data packet 
% delay and average VoIP packet delay using the M/G/1 model for all cases 
% of 2.b. Compare the theoretical values with the simulation results of 
% experiments 2.b and take conclusions.

lambda = 1500; 
C = 10;
f = 1000000;
P = 10000;
N = 50;
n = [10, 20, 30, 40];
alfa = 0.1;
PLdata = zeros(1,4);
APDdata = zeros(1,4);
MPDdata = zeros(1,4);
PLvoip = zeros(1,4);
APDvoip = zeros(1,4);
MPDvoip = zeros(1,4);
TT = zeros(1,4); 
sim_mediaAPDdata = zeros(1,4);
sim_mediaAPDvoip = zeros(1,4);
the_mediaAPDdata = zeros(1,4);
the_mediaAPDvoip = zeros(1,4);
the_mediaAPDdata_2 = zeros(1,4);
the_mediaAPDvoip_2 = zeros(1,4);
for i= 1:length(n)
    for it= 1:N
        [PLdata(it), APDdata(it), MPDdata(it), TT(it), PLvoip(it), APDvoip(it), MPDvoip(it)] = Simulator4(lambda,C,f,P,n(i));
        [the_mediaAPDvoip_2, the_mediaAPDdata_2] =  TheoAvgDelayMG1_priorities(lambda, C, n(i));
    end
    sim_mediaAPDdata(i) = mean(APDdata);
    sim_mediaAPDvoip(i) = mean(APDvoip);
    the_mediaAPDdata(i) = mean(the_mediaAPDdata_2);
    the_mediaAPDvoip(i) = mean(the_mediaAPDvoip_2);
end
figure(3);
h = bar(n,[sim_mediaAPDdata; the_mediaAPDdata]);
hold on
grid on
title('Average Data Packet Delay');
legend('Simulation','Theoretical', 'location', 'northwest');
xlabel('n (number of Data packets flows)');
ylabel('Average Data packet delay (ms)');
hold off
figure(4);
h = bar(n,[sim_mediaAPDvoip; the_mediaAPDvoip]);
hold on
grid on
title('Average VoIP Packet Delay');
legend('Simulation','Theoretical', 'location', 'northwest');
xlabel('n (number of VoIP packets flows)');
ylabel('Average VoIP packet delay (ms)');
hold off


%% 2.d. 
% Consider the case of lamda = 1500 pps, C = 10 Mbps and f = 10.000 Bytes. 
% Run Simulator3 50 times with a stopping criterion of P = 10000 each run 
% and compute the estimated values and the 90% confidence intervals of the 
% average delay and packet loss performance parameters of data packets and 
% VoIP packets when n = 10, 20, 30 and 40 VoIP flows. Present the results 
% of each of the 4 performance parameters (average data packet delay, average 
% VoIP packet delay, data packet loss and VoIP packet loss) in different 
% figures (in all cases, in bar charts with the confidence intervals in 
% error bars). Justify the results and take conclusions concerning the 
% impact of the number of VoIP flows in the obtained average packet delay 
% and packet loss of each service when both services (data and VoIP) are 
% statistically multiPLdataexed in a single FIFO queue of small size.

lambda = 1500; 
C = 10;
f = 10000;
P = 10000;
N = 50;
n = [10, 20, 30, 40];
alfa = 0.1;
PLdata = zeros(1,4);
APDdata = zeros(1,4);
MPDdata = zeros(1,4);
PLvoip = zeros(1,4);
APDvoip = zeros(1,4);
MPDvoip = zeros(1,4);
TT = zeros(1,4); 
mediaAPDdata = zeros(1,4);
termAPDdata = zeros(1,4);
mediaAPDvoip = zeros(1,4);
termAPDvoip = zeros(1,4);
mediaPLdata = zeros(1,4);
termPLdata = zeros(1,4);
mediaPLvoip = zeros(1,4);
termPLvoip = zeros(1,4);
for i= 1:length(n)
    for it= 1:N
        [PLdata(it), APDdata(it), MPDdata(it), TT(it), PLvoip(it), APDvoip(it), MPDvoip(it)] = Simulator3(lambda,C,f,P,n(i));
    end
    mediaPLdata(i) = mean(PLdata);
    termPLdata(i) = norminv(1-alfa/2)*sqrt(var(PLdata)/N);
    mediaPLvoip(i) = mean(PLvoip);
    termPLvoip(i) = norminv(1-alfa/2)*sqrt(var(PLvoip)/N);
    mediaAPDdata(i) = mean(APDdata);
    termAPDdata(i) = norminv(1-alfa/2)*sqrt(var(APDdata)/N);
    mediaAPDvoip(i) = mean(APDvoip);
    termAPDvoip(i) = norminv(1-alfa/2)*sqrt(var(APDvoip)/N);
end
figure(5);
h = bar(n,mediaPLdata);
hold on
er = errorbar(n,mediaPLdata,termPLdata);
er.Color = [0 0 0];
er.LineStyle = 'none';
grid on
title('Data Packet Loss');
xlabel('n (number of Data packets flows)');
ylabel('Data packet loss (%)');
hold off
figure(6);
h = bar(n,mediaPLvoip);
hold on
er = errorbar(n,mediaPLvoip,termPLvoip);
er.Color = [0 0 0];
er.LineStyle = 'none';
grid on
title('VoIP Packet Loss');
xlabel('n (number of VoIP packets flows)');
ylabel('VoIP packet loss (%)');
hold off
figure(7);
h = bar(n,mediaAPDdata);
hold on
er = errorbar(n,mediaAPDdata,termAPDdata);
er.Color = [0 0 0];
er.LineStyle = 'none';
grid on
title('Average Data Packet Delay');
xlabel('n (number of Data packets flows)');
ylabel('Average Data packet delay (ms)');
hold off
figure(8);
h = bar(n,mediaAPDvoip);
hold on
er = errorbar(n,mediaAPDvoip,termAPDvoip);
er.Color = [0 0 0];
er.LineStyle = 'none';
grid on
title('Average VoIP Packet Delay');
xlabel('n (number of VoIP packets flows)');
ylabel('Average VoIP packet delay (ms)');
hold off

%% 2.e. 
% Repeat experiment 2.d but now with Simulator4. Justify these results and 
% the differences between them and the results of 2.d. Take conclusions 
% concerning the impact of the number of VoIP flows in the obtained average
% packet delay and packet loss of each service when VoIP service is supported 
% with a priority which is higher than the data service and the queue is of 
% small size.

lambda = 1500; 
C = 10;
f = 10000;
P = 10000;
N = 50;
n = [10, 20, 30, 40];
alfa = 0.1;
PLdata = zeros(1,4);
APDdata = zeros(1,4);
MPDdata = zeros(1,4);
PLvoip = zeros(1,4);
APDvoip = zeros(1,4);
MPDvoip = zeros(1,4);
TT = zeros(1,4); 
mediaAPDdata = zeros(1,4);
termAPDdata = zeros(1,4);
mediaAPDvoip = zeros(1,4);
termAPDvoip = zeros(1,4);
mediaPLdata = zeros(1,4);
termPLdata = zeros(1,4);
mediaPLvoip = zeros(1,4);
termPLvoip = zeros(1,4);
for i= 1:length(n)
    for it= 1:N
        [PLdata(it), APDdata(it), MPDdata(it), TT(it), PLvoip(it), APDvoip(it), MPDvoip(it)] = Simulator4(lambda,C,f,P,n(i));
    end
    mediaPLdata(i) = mean(PLdata);
    termPLdata(i) = norminv(1-alfa/2)*sqrt(var(PLdata)/N);
    mediaPLvoip(i) = mean(PLvoip);
    termPLvoip(i) = norminv(1-alfa/2)*sqrt(var(PLvoip)/N);
    mediaAPDdata(i) = mean(APDdata);
    termAPDdata(i) = norminv(1-alfa/2)*sqrt(var(APDdata)/N);
    mediaAPDvoip(i) = mean(APDvoip);
    termAPDvoip(i) = norminv(1-alfa/2)*sqrt(var(APDvoip)/N);
end
figure(9);
h = bar(n,mediaPLdata);
hold on
er = errorbar(n,mediaPLdata,termPLdata);
er.Color = [0 0 0];
er.LineStyle = 'none';
grid on
title('Data Packet Loss');
xlabel('n (number of Data packets flows)');
ylabel('Data packet loss (%)');
hold off
figure(10);
h = bar(n,mediaPLvoip);
hold on
er = errorbar(n,mediaPLvoip,termPLvoip);
er.Color = [0 0 0];
er.LineStyle = 'none';
grid on
title('VoIP Packet Loss');
xlabel('n (number of VoIP packets flows)');
ylabel('VoIP packet loss (%)');
hold off
figure(11);
h = bar(n,mediaAPDdata);
hold on
er = errorbar(n,mediaAPDdata,termAPDdata);
er.Color = [0 0 0];
er.LineStyle = 'none';
grid on
title('Average Data Packet Delay');
xlabel('n (number of Data packets flows)');
ylabel('Average Data packet delay (ms)');
hold off
figure(12);
h = bar(n,mediaAPDvoip);
hold on
er = errorbar(n,mediaAPDvoip,termAPDvoip);
er.Color = [0 0 0];
er.LineStyle = 'none';
grid on
title('Average VoIP Packet Delay');
xlabel('n (number of VoIP packets flows)');
ylabel('Average VoIP packet delay (ms)');
hold off

%% 2.f. 
% Develop a new version of Simulator4 to consider that VoIP packets are 
% always accepted in the queue (if there is enough space) but data packets 
% are accepted in the queue only if the total queue occupation does not become 
% higher than 90% (a simPLdataified version of WRED – Weighted Random Early 
% Discard). Repeat experiment 2.e but now with the new version of Simulator4. 
% Justify these results and the differences between them and the results of 
% 2.e. Take conclusions concerning the impact of the number of VoIP flows in 
% the obtained average packet delay and packet loss of each service when 
% (i) VoIP service is supported with a priority which is higher than the 
% data service and (ii) the packet acceptance in the queue is differentiated.

lambda = 1500; 
C = 10;
f = 10000;
P = 10000;
N = 50;
n = [10, 20, 30, 40];
alfa = 0.1;
PLdata = zeros(1,4);
APDdata = zeros(1,4);
MPDdata = zeros(1,4);
PLvoip = zeros(1,4);
APDvoip = zeros(1,4);
MPDvoip = zeros(1,4);
TT = zeros(1,4); 
mediaAPDdata = zeros(1,4);
termAPDdata = zeros(1,4);
mediaAPDvoip = zeros(1,4);
termAPDvoip = zeros(1,4);
mediaPLdata = zeros(1,4);
termPLdata = zeros(1,4);
mediaPLvoip = zeros(1,4);
termPLvoip = zeros(1,4);
for i= 1:length(n)
    for it= 1:N
        [PLdata(it), APDdata(it), MPDdata(it), TT(it), PLvoip(it), APDvoip(it), MPDvoip(it)] = Simulator4New(lambda,C,f,P,n(i));
    end
    mediaPLdata(i) = mean(PLdata);
    termPLdata(i) = norminv(1-alfa/2)*sqrt(var(PLdata)/N);
    mediaPLvoip(i) = mean(PLvoip);
    termPLvoip(i) = norminv(1-alfa/2)*sqrt(var(PLvoip)/N);
    mediaAPDdata(i) = mean(APDdata);
    termAPDdata(i) = norminv(1-alfa/2)*sqrt(var(APDdata)/N);
    mediaAPDvoip(i) = mean(APDvoip);
    termAPDvoip(i) = norminv(1-alfa/2)*sqrt(var(APDvoip)/N);
end
figure(13);
h = bar(n,mediaPLdata);
hold on
er = errorbar(n,mediaPLdata,termPLdata);
er.Color = [0 0 0];
er.LineStyle = 'none';
grid on
title('Data Packet Loss');
xlabel('n (number of Data packets flows)');
ylabel('Data packet loss (%)');
hold off
figure(14);
h = bar(n,mediaPLvoip);
hold on
er = errorbar(n,mediaPLvoip,termPLvoip);
er.Color = [0 0 0];
er.LineStyle = 'none';
grid on
title('VoIP Packet Loss');
xlabel('n (number of VoIP packets flows)');
ylabel('VoIP packet loss (%)');
hold off
figure(15);
h = bar(n,mediaAPDdata);
hold on
er = errorbar(n,mediaAPDdata,termAPDdata);
er.Color = [0 0 0];
er.LineStyle = 'none';
grid on
title('Average Data Packet Delay');
xlabel('n (number of Data packets flows)');
ylabel('Average Data packet delay (ms)');
hold off
figure(16);
h = bar(n,mediaAPDvoip);
hold on
er = errorbar(n,mediaAPDvoip,termAPDvoip);
er.Color = [0 0 0];
er.LineStyle = 'none';
grid on
title('Average VoIP Packet Delay');
xlabel('n (number of VoIP packets flows)');
ylabel('Average VoIP packet delay (ms)');
hold off


%% LAB 1 %% AUXILIAR FUNCTIONS

function [W1, W2] = TheoAvgDelayMG1_priorities(lambda, C, n)
    meanPacketVoipSize = (110+130)/2;
    bytesVoip = 110:130;
    lambdaVoip = (1/(20*10^3))*n;
    lambdaData = lambda;
    [esData, es2Data] =  ES_data(C);
    [esVoip, es2Voip] = ES_voip(C,bytesVoip);
    uVoip = (C*10^6) / (meanPacketVoipSize*8);
    uData = (C*10^6) / (esData);
    p1 = lambdaVoip / uVoip;
    p2 = lambdaData / uData;
    WQ1 = ((lambdaVoip*es2Voip) + (lambdaData.*es2Data)) / (2*(1-p1));
    WQ2 = ((lambdaVoip*es2Voip) + (lambdaData.*es2Data)) / (2*(1-p1)*(1-p1-p2));
    W1 = (WQ1 + esVoip) * 1000;
    W2 = (WQ2 + esData) * 1000;
end

function [es, es2] = ES_data(C)
    k = (0.41/((109 - 65 + 1)+(1517 - 111 + 1)));
    es = 0.19 * ((64*8)/(C*10^6)) + 0.23 * ((110*8)/(C*10^6)) + 0.17 * ((1518*8)/(C*10^6));
    es2 = 0.19 * ((64*8)/(C*10^6))^2 + 0.23 * ((110*8)/(C*10^6))^2 + 0.17 * ((1518*8)/(C*10^6))^2;
    for n = 65:109
        es = es + k * ((n*8)/(C*10^6));
        es2 = es2 + k * ((n * 8)/(C*10^6))^2;
    end
    for n = 111:1517
         es = es + k * ((n*8)/(C*10^6));
         es2 = es2 + k * ((n * 8)/(C*10^6))^2;
    end
end

function [es, es2] = ES_voip(C, v)
    es = 0;
    es2 = 0;
    for i = 1:size(v, 2)
        es = es + (((v(i)*8)/(C*10^6)))*(1/21);
        es2 = es2 + (( (v(i)*8)/(C*10^6))^2)*(1/21);
    end
end
