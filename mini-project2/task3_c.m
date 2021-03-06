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

MTBF= (450*365*24)./L;
A= MTBF./(MTBF + 24);
A(isnan(A))= 0;
logA= -log(A);

% ------------------------------- TASK 3.c -------------------------------
% Recall that the capacity of all links is 10 Gbps in each direction. 
% Compute how much bandwidth is required on each direction of each link to
% support all flows with 1+1 protection using the previous computed pairs 
% of link disjoint paths. Compute also the total bandwidth required on all 
% links. Register which links do not have enough capacity.
fprintf('------------------------------- 3.c -------------------------------\n');

% o percurso mais disponivel, segundo percurso mais disponivel disjunto do primeiro = calculateDisjointPaths
% a1= disponibilidade do primeiro percurso, a2= disponibilidade do segundo percurso
[sP1 a1 sP2 a2]= calculateDisjointPaths(logA,T);

% devolve o loads, indicando para cada ligacao e para cada sentido a carga necessaria
% 3coluna = Gb necessarios da origem para o destino
% 4coluna = Gb necessarios do destino para a origem 
% proteger todos exceto o fluxo 3 (pq so tem um percurso)

Loads= calculateLinkLoads1plus1(nNodes,Links,T,sP1,sP2);

for i= 1:nLinks
    fprintf('Link [%d %d]:\n',Loads(i,1), Loads(i,2));
    fprintf('   Bandwidth required on link %d-%d: %.4f Gbps\n',Loads(i,1), Loads(i,2), Loads(i,3));
    fprintf('   Bandwidth required on link %d-%d: %.4f Gbps\n',Loads(i,2), Loads(i,1), Loads(i,4));
    fprintf('   Total bandwidth required on link [%d %d]: %.4f Gbps\n',Loads(i,2), Loads(i,1), sum(Loads(i,3:4)));
    if Loads(i,3) > 10
        fprintf('   The link %d-%d does not have sufficient capacity\n', Loads(i,1), Loads(i,2));
    end
    if Loads(i,4) > 10
        fprintf('   The link %d-%d does not have sufficient capacity\n', Loads(i,2), Loads(i,1));
    end
end
fprintf('\nTotal bandwidth required on all links: %.4f Gbps\n', sum(sum(Loads(:,3:4))));
