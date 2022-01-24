clear all;
close all;

% task 2 module 4
% quando se pretende minimizar a carga maxima

Nodes= [20 60
       250 30
       550 150
       310 100
       100 130
       580 230
       120 190
       400 220
       220 280];
   
Links= [1 2
        1 5
        2 4
        3 4
        3 6
        3 8
        4 5
        4 8
        5 7
        6 8
        7 8
        7 9
        8 9];

T= [1  3  1.0 1.0
    1  4  0.7 0.5
    2  7  3.4 2.5
    3  4  2.4 2.1
    4  9  2.0 1.4
    5  6  1.2 1.5
    5  8  2.1 2.7
    5  9  2.6 1.9];

nNodes= 9;
nLinks= size(Links,1);
nFlows= size(T,1);

co= Nodes(:,1)+j*Nodes(:,2);

% Square matrix with arc lengths (in Km)
% matriz com os comprimentos de cada ligacao ij ou infinito se a ligacao nao existir, com a diagonal a zeros
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

% Compute up to n paths for each flow:
n= inf;     % n=6, para os 6 fluxos
[sP nSP]= calculatePaths(L,T,n);    % quero todos os percursos, do mais curto para o mais longo

tempo= 10;

% Optimization algorithm with greedy randomized to minimize max load:
t= tic;
bestLoad= inf;  % valor da melhor solucao
allValues= [];  % vetor onde se guarda os valores de todas as solucoes
while toc(t)<tempo  % controla o tempo 
    % escolher uma ordem aleatoria, para cada fluxo por essa ordem, escolher a funcao objetivo
    ax2= randperm(nFlows);
    sol= zeros(1,nFlows);   % dimensao = nº de fluxos, conteudo = 2, segundo percurso (p.e)
    for i= ax2
        k_best= 0;
        best= inf;
        for k= 1:nSP(i)     % nSp(i) = numero de percursos para o fluxo i
            sol(i)= k;      
            Loads= calculateLinkLoads(nNodes,Links,T,sP,sol);   % calcular as cargas
            load= max(max(Loads(:,3:4)));   % calcular a carga maxima
            if load<best    % guardar o melhor valor
                k_best= k;
                best= load;
            end
        end
        sol(i)= k_best;     % funcao objetivo = minimizar as cargas
    end
    load= best;
    allValues= [allValues load];
    if load<bestLoad
        bestSol= sol;
        bestLoad= load;
    end
end
plot(sort(allValues));  % a melhor solucao e' 5.1, conseguiu atingir o pior nos 8
fprintf('GREEDY RANDOMIZED:\n');
fprintf('   Best load = %.2f Gbps\n',bestLoad);
fprintf('   No. of solutions = %d\n',length(allValues));
fprintf('   Av. quality of solutions = %.2f Gbps\n',mean(allValues));


% Optimization algorithm with multi start hill climbing to minimize max load:

% começo com a menor solucao a inf, depois vou repetir ate acabar o tempo,
% em que primeiro constroi-se uma solucao (greedy randomize); ja se tem um
% percurso escolhido, solucoes para a troca de um percurso, parando quando
% nenhuma das trocas individuais sao melhores, estando num minimo local

% cada iterecao vai demorar mais tempo
t= tic;
bestLoad= inf;
allValues= [];
contadortotal= [];
while toc(t)<tempo
    
    %GREEDY RANDOMIZED:
    ax2= randperm(nFlows);
    sol= zeros(1,nFlows);
    for i= ax2
        k_best= 0;
        best= inf;
        for k= 1:nSP(i)
            sol(i)= k;
            Loads= calculateLinkLoads(nNodes,Links,T,sP,sol);
            load= max(max(Loads(:,3:4)));
            if load<best
                k_best= k;
                best= load;
            end
        end
        sol(i)= k_best;
    end
    load= best;
    
    %HILL CLIMBING:
    continuar= true;
    while continuar
        i_best= 0;
        k_best= 0;
        best= load;
        for i= 1:nFlows % a cada percurso e a cada fluxo, memorizo o percurso atual para depois repor, e troco o percurso por k
            for k= 1:nSP(i)
                if k~=sol(i)
                    aux= sol(i);
                    sol(i)= k;
                    Loads= calculateLinkLoads(nNodes,Links,T,sP,sol);
                    load1= max(max(Loads(:,3:4)));
                    if load1<best
                        i_best= i;
                        k_best= k;
                        best= load1;
                    end
                    sol(i)= aux;
                end
            end
        end
        if i_best>0     % se nao for >0, nao houve troca
            sol(i_best)= k_best;
            load= best;
        else
            continuar= false;
        end
    end
    allValues= [allValues load];
    if load<bestLoad
        bestSol= sol;
        bestLoad= load;
    end
end
hold on
plot(sort(allValues));
legend('Greedy Randomized','Hill Climbing', 'Location','northwest');

fprintf('MULTI START HILL CLIMBING:\n');
fprintf('   Best load = %.2f Gbps\n',bestLoad);
fprintf('   No. of solutions = %d\n',length(allValues));
fprintf('   Av. quality of solutions = %.2f Gbps\n',mean(allValues));


% foram igualmente eficientes, a melhor solucao com o mesmo valor
% hill gera muito menos solucoes com melhor qualidade
% greedy gera mais solucoes com pior qualidade


