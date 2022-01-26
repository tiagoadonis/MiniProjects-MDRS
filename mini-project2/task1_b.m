clear all;
close all;

Nodes= [30 70
       350 40
       550 180
       310 130
       100 170
       540 290
       120 240
       400 310
       220 370
       550 380];
   
Links= [1 2
        1 5
        2 3
        2 4
        3 4
        3 6
        3 8
        4 5
        4 8
        5 7
        6 8
        6 10
        7 8
        7 9
        8 9
        9 10];

T= [1  3  1.0 1.0
    1  4  0.7 0.5
    2  7  2.4 1.5
    3  4  2.4 2.1
    4  9  1.0 2.2
    5  6  1.2 1.5
    5  8  2.1 2.5
    5  9  1.6 1.9
    6 10  1.4 1.6];

nNodes= 10;
nLinks= size(Links,1);
nFlows= size(T,1);
co= Nodes(:,1)+j*Nodes(:,2);

% Square matrix with arc lengths (in Km) : matriz com os comprimentos de 
% cada ligacao ij ou infinito se a ligacao nao existir, com a diagonal a zeros
L= inf(nNodes);   
for i=1:nNodes
    L(i,i)= 0;
end
for i=1:nLinks
    d= abs(co(Links(i,1))-co(Links(i,2)));
    L(Links(i,1),Links(i,2))= d+5; %Km
    L(Links(i,2),Links(i,1))= d+5; %Km
end
L= round(L);

% ------------------------------- TASK 1.b -------------------------------
% Run a random algorithm during 10 seconds in three cases: 
% (i) using all possible routing paths, 
% (ii) using the 10 shortest routing paths, and 
% (iii) using the 5 shortest routing paths. 
% For each case, register the worst link load value of the best solution, 
% the number of solutions generated by the algorithm and the average 
% quality of all solutions. On a single figure, plot for the three cases 
% the worst link load values of all solutions in an increasing order.
fprintf('\n------------------------------- 1.b -------------------------------\n');
fprintf('RANDOM STRATEGY\n');

fprintf('   Using all possible routing paths:\n');
n = inf;
% Compute up to n paths for each flow:
[sP nSP] = calculatePaths(L,T,n);                                    % nSP(i) = nº de percursos num fluxo
% Compute the link loads using the first (shortest) path of each flow:
sol = zeros(1,nFlows);
Loads = calculateLinkLoads(nNodes,Links,T,sP,sol);
maxLoad = max(max(Loads(:,3:4)));
% Optimization algorithm resorting to the RANDOM strategy
time = 10;
t = tic;
bestLoad = inf;                                                        % valor da melhor solucao 
sol = zeros(1,nFlows);   
allValues = [];                                                         % vetor onde se guarda os valores de todas as solucoes
while toc(t) < time                                                     % percorrer ate a condicao time ser atingida
    for i = 1:nFlows                                                    % gerar multiplas solucoes random
        sol(i) = randi(nSP(i));  
    end
    Loads = calculateLinkLoads(nNodes,Links,T,sP,sol);                  % calcular as cargas da solucao gerada
    load = max(max(Loads(:,3:4)));                                      % verificar o maior valor das cargas entre a 3 e 4 colunas
    allValues = [allValues load];                                       % guardar todos os valores de carga maxima de todas as solucoes
    if load < bestLoad                                                 % ficar com a melhor solucao de todas 
        bestSol = sol;
        bestLoad = load;
    end
end
fprintf('      Best load = %.2f Gbps\n', bestLoad);
fprintf('      No. of solutions = %d\n', length(allValues));
fprintf('      Av. quality of solutions = %.2f Gbps\n\n', mean(allValues));
figure(1);
hold on
plot(sort(allValues)); 


fprintf('   Using 10 shortest routing paths:\n');
n = 10;
[sP nSP] = calculatePaths(L,T,n);
sol = zeros(1,nFlows);
Loads = calculateLinkLoads(nNodes,Links,T,sP,sol);
maxLoad = max(max(Loads(:,3:4)));
time = 10;
t = tic;
bestLoad = inf;
sol = zeros(1,nFlows);   
allValues = [];
while toc(t) < time 
    for i = 1:nFlows
        sol(i) = randi(nSP(i));  
    end
    Loads = calculateLinkLoads(nNodes,Links,T,sP,sol);
    load = max(max(Loads(:,3:4)));
    allValues = [allValues load];
    if load < bestLoad   
        bestSol = sol;
        bestLoad = load;
    end
end
fprintf('      Best load = %.2f Gbps\n', bestLoad);
fprintf('      No. of solutions = %d\n', length(allValues));
fprintf('      Av. quality of solutions = %.2f Gbps\n\n', mean(allValues));
figure(1);
hold on
plot(sort(allValues)); 
    

fprintf('   Using 5 shortest routing paths:\n');
n = 5;
[sP nSP] = calculatePaths(L,T,n);
sol = zeros(1,nFlows);
Loads = calculateLinkLoads(nNodes,Links,T,sP,sol);
maxLoad = max(max(Loads(:,3:4)));
time = 10;
t = tic;
bestLoad = inf; 
sol = zeros(1,nFlows);   
allValues = []; 
while toc(t) < time  
    for i = 1:nFlows  
        sol(i) = randi(nSP(i));  
    end
    Loads = calculateLinkLoads(nNodes,Links,T,sP,sol); 
    load = max(max(Loads(:,3:4)));  
    allValues = [allValues load];  
    if load < bestLoad      
        bestSol = sol;
        bestLoad = load;
    end
end
fprintf('      Best load = %.2f Gbps\n', bestLoad);
fprintf('      No. of solutions = %d\n', length(allValues));
fprintf('      Av. quality of solutions = %.2f Gbps\n\n', mean(allValues));
figure(1);
hold on
plot(sort(allValues)); 

title({'Random algorithm'}, {'to minimize the worst link load'});
xlabel('No. of solutions');
ylabel('Best Load (Gbps)');  
legend('All possible routing paths','10 shortest routing paths','5 shortest routing paths','Location','northwest');
