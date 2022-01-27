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

% ------------------------------- TASK 3.a -------------------------------
% For each flow, compute one of its routing paths given by the most available path. 
fprintf('\n------------------------------- 3.a -------------------------------\n');

MTBF= (450*365*24)./L;
A= MTBF./(MTBF + 24);
A(isnan(A))= 0;
logA= -log(A);

[sP nSP]= calculatePaths(logA,T,1);     % nSP deixa de fazer sentido porque e' sempre 1

count= 1;
ava=ones(1,length(sP));
for i=1:length(sP)
    fprintf('Flow %d: ',i);
    path=sP{i}{1};   % obter todos os paths do sP
    aux = 1;
    for j=1:(length(path)-1)
        initialNode = path(j);
        nextNode = path(j+1);
        ava(i)= ava(i)*A(initialNode,nextNode);
    end
    fprintf('availability of Path ');
    fprintf('%d ', path);
    fprintf('= %.5f%%\n', ava(i))
end


%% ------------------------------- TASK 3.b -------------------------------
% For each flow, compute another routing path given by the most available 
% path which is link disjoint with the previously computed routing path. 
% Compute the availability provided by each pair of routing paths. Present 
% all pairs of routing paths of each flow and their availability. Present 
% also the average service availability (i.e., the average availability 
% value among all flows of the service).
fprintf('\n------------------------------- 3.b -------------------------------\n');


%% ------------------------------- TASK 3.c -------------------------------
% Recall that the capacity of all links is 10 Gbps in each direction. 
% Compute how much bandwidth is required on each direction of each link to
% support all flows with 1+1 protection using the previous computed pairs 
% of link disjoint paths. Compute also the total bandwidth required on all 
% links. Register which links do not have enough capacity.
fprintf('------------------------------- 3.c -------------------------------\n');

%% ------------------------------- TASK 3.d -------------------------------
% Compute how much bandwidth is required on each link to support all flows 
% with 1:1 protection using the previous computed pairs of link disjoint
% paths. Compute also the total bandwidth required on all links. Register 
% which links do not have enough capacity and the highest bandwidth value 
% required among all links.
fprintf('------------------------------- 3.d -------------------------------\n');
