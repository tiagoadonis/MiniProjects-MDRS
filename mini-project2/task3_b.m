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

% ------------------------------- TASK 3.b -------------------------------
% For each flow, compute another routing path given by the most available 
% path which is link disjoint with the previously computed routing path. 
% Compute the availability provided by each pair of routing paths. Present 
% all pairs of routing paths of each flow and their availability. Present 
% also the average service availability (i.e., the average availability 
% value among all flows of the service).
fprintf('\n------------------------------- 3.b -------------------------------\n');

% o percurso mais disponivel, segundo percurso mais disponivel disjunto do primeiro = calculateDisjointPaths
% a1= disponibilidade do primeiro percurso, a2= disponibilidade do segundo percurso
[sP1 a1 sP2 a2]= calculateDisjointPaths(logA,T);

sP1
clc
for i= 1:nFlows
    fprintf('Flow %d:\n',i);
    fprintf('   First path: %d',sP1{i}{1}(1));
    for j= 2:length(sP1{i}{1})
        fprintf('-%d',sP1{i}{1}(j));
    end
    if ~isempty(sP2{i}{1})
        fprintf('\n   Second path: %d',sP2{i}{1}(1));
        for j= 2:length(sP2{i}{1})
            fprintf('-%d',sP2{i}{1}(j));
        end
    end
    fprintf('\n   Availability of First Path= %.5f%%\n',100*a1(i));
    if ~isempty(sP2{i}{1})
        fprintf('   Availability of Second Path= %.5f%%\n',100*a2(i));
    end
end

fprintf('\nAverage Service availability of First Path= %.5f%%\n',mean(a1));
fprintf('Average Service availability of Second Path= %.5f%%\n',mean(a2));
