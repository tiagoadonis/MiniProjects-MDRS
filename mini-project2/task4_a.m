clear all;
close all;

Nodes = [30 70
        350 40
        550 180
        310 130
        100 170
        540 290
        120 240
        400 310
        220 370
        550 380];
   
Links = [1 2
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

T = [1  3  1.0 1.0
     1  4  0.7 0.5
     2  7  2.4 1.5
     3  4  2.4 2.1
     4  9  1.0 2.2
     5  6  1.2 1.5
     5  8  2.1 2.5
     5  9  1.6 1.9
     6 10  1.4 1.6];

nNodes = 10;
nLinks = size(Links,1);
nFlows = size(T,1);
co = Nodes(:,1) + j * Nodes(:,2);

% Square matrix with arc lengths (in Km) : matriz com os comprimentos de 
% cada ligacao ij ou infinito se a ligacao nao existir, com a diagonal a zeros
L = inf(nNodes);   
for i = 1:nNodes
    L(i,i) = 0;
end
for i = 1:nLinks
    d = abs(co(Links(i,1)) - co(Links(i,2)));
    L(Links(i,1),Links(i,2)) = d+5; %Km
    L(Links(i,2),Links(i,1)) = d+5; %Km
end
L = round(L);  %Km

% ------------------------------- TASK 4.a) -------------------------------
% For each flow, compute 10 pairs of link disjoint paths in the following way. With a k-shortest path 
% algorithm, first compute the k = 10 most available routing paths provided by the network to each 
% traffic flow. Then, compute the most available path which is link disjoint with each of the k previous paths.
fprintf('------------------------------- TASK 4.a) -------------------------------\n');
cost = zeros(nNodes,nFlows);

% Para calcular os n percursos mais disponiveis
for i = 1:nFlows
    [shortestPath, totalCost] = kShortestPath(L,T(i,1),T(i,2),nNodes);
    sP{i} = shortestPath;
    cost(:,i) = totalCost;
end

% Para cada fluxo
for i = 1:nFlows
    % Para os n percurso encontrados do fluxo i
    for j = 1:nNodes
        sP1{i}{j} = sP{i}{j};         % shortestPath
        a1(i,j) = exp(-cost(j,i));    % totalCost
        path1 = sP{i}{j};             % shortestPath
        Laux = L;
        %calcular os custos das ligações para uma matriz de custos disjunta
        for k = 2:length(path1)
            Laux(path1(k),path1(k-1)) = inf;
            Laux(path1(k-1),path1(k)) = inf;
        end
    
        % Obtenção do percurso disjunto ao anterior
        [shortestPath, totalCost] = kShortestPath(Laux,T(i,1),T(i,2),1); 
    
        % Se tiver solução quer dizer que existe
        if length(shortestPath) > 0       
            sP2{i}{j} = shortestPath{1};     % shortestPath
            a2(i,j) = exp(-totalCost);       % totalCost
        % Se não há percurso, é vazio e o custo é zero
        else 
            sP2{i}{j} = [];
            s2(i,j) = 0;
        end
    end
end
fprintf('Computation Done!\n');
%sP1, a1, sP2, a2
