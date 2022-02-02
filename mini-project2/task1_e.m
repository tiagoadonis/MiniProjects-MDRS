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
L= round(L);  %Km


% ------------------------------- TASK 1.b -------------------------------
% Run a random algorithm during 10 seconds, using all possible routing paths.

fprintf('RANDOM STRATEGY\n');
n = inf;
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
fprintf('   Worst load = %.2f Gbps\n', bestLoad);
fprintf('   No. of solutions = %d\n', length(allValues));
fprintf('   Av. quality of solutions = %.2f Gbps\n\n', mean(allValues));
figure(1);
hold on
plot(sort(allValues)); 


% ------------------------------- TASK 1.c -------------------------------
% Run a greedy randomized algorithm during 10 seconds, using all possible routing paths. 

fprintf('GREEDY RANDOMIZED STRATEGY\n');
n= inf;
[sP nSP] = calculatePaths(L,T,n);
sol = ones(1,nFlows);
Loads = calculateLinkLoads(nNodes,Links,T,sP,sol);
maxLoad = max(max(Loads(:,3:4)));
time= 10;
t = tic;
bestLoad = inf;  
allValues = []; 
while toc(t) < time
    ax2 = randperm(nFlows);   
    sol = zeros(1,nFlows); 
    for i = ax2
        k_best = 0;
        best = inf;
        for k = 1:nSP(i)  
            sol(i) = k;      
            Loads = calculateLinkLoads(nNodes,Links,T,sP,sol);  
            load = max(max(Loads(:,3:4)));   
            if load < best     
                k_best = k;
                best = load;
            end
        end
        sol(i) = k_best;    
    end
    load = best;
    allValues = [allValues load];   
    if load < bestLoad
        bestSol = sol;
        bestLoad = load;
    end
end
fprintf('   Worst load = %.2f Gbps\n', bestLoad);
fprintf('   No. of solutions = %d\n', length(allValues));
fprintf('   Av. quality of solutions = %.2f Gbps\n\n', mean(allValues));
figure(1);
hold on
plot(sort(allValues)); 


% ------------------------------- TASK 1.d -------------------------------
% Run a multi start hill climbing algorithm during 10 seconds, using all possible routing paths.

fprintf('MULTI START HILL CLIMBING STRATEGY\n');
n = inf;
[sP nSP] = calculatePaths(L,T,n); 
sol = ones(1,nFlows);
Loads = calculateLinkLoads(nNodes,Links,T,sP,sol);
maxLoad = max(max(Loads(:,3:4)));
time = 10;
t = tic;
bestLoad = inf; 
allValues = [];    
contadortotal = [];
while toc(t) < time    
    % Greedy Randomized
    ax2 = randperm(nFlows);   
    sol = zeros(1,nFlows);   
    for i = ax2
        k_best = 0;
        best = inf;
        for k = 1:nSP(i)                  
            sol(i) = k;      
            Loads = calculateLinkLoads(nNodes,Links,T,sP,sol);   
            load = max(max(Loads(:,3:4)));     
            if load < best               
                k_best = k;
                best = load;
            end
        end
        sol(i) = k_best; 
    end
    load = best;
    % Multi start Hill CLimbing
    continuar = true;
    while continuar
        i_best = 0;
        k_best = 0;
        best = load;
        for i = 1:nFlows 
            for k = 1:nSP(i)
                if k ~= sol(i)
                    aux = sol(i);
                    sol(i) = k;
                    Loads = calculateLinkLoads(nNodes,Links,T,sP,sol);
                    load1 = max(max(Loads(:,3:4)));
                    if load1 < best
                        i_best = i;
                        k_best = k;
                        best = load1;
                    end
                    sol(i) = aux;
                end
            end
        end
        if i_best > 0 
            sol(i_best) = k_best;
            load = best;
        else
            continuar = false;
        end
    end
    allValues = [allValues load]; 
    if load < bestLoad
        bestSol = sol;
        bestLoad = load;
    end
end
fprintf('   Worst load = %.2f Gbps\n', bestLoad);
fprintf('   No. of solutions = %d\n', length(allValues));
fprintf('   Av. quality of solutions = %.2f Gbps\n\n', mean(allValues));
figure(1);
hold on
plot(sort(allValues));

title({'Efficiency of the two heuristic algorithms'}, {'to minimize the worst link load (using all possible routing paths)'});
title({'Efficiency of the three heuristic algorithms'}, {'to minimize the worst link load (using all possible routing paths)'});
xlabel('No. of solutions');
ylabel('Worst Load (Gbps)');   
legend('Greedy Randomized algorithm','Multi start Hill CLimbing algorithm','Location','southeast');
legend('Random algorithm','Greedy Randomized algorithm','Multi start Hill CLimbing algorithm','Location','southeast');