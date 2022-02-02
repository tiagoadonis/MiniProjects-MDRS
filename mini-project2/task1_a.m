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

% ------------------------------- TASK 1.1 -------------------------------
% With a k-shortest path algorithm (using the lengths of the links), 
% compute the number of different routing paths provided by the network to
% each traffic flow.
fprintf('------------------------------- 1.a -------------------------------\n');

% Compute up to n paths for each flow:
n= inf;
[sP nSP]= calculatePaths(L,T,n);    % quero todos os percursos, do mais curto para o mais longo

fprintf('With a k-shortest path algorithm (using the lengths of the links):\n');
for i = 1:nFlows
    fprintf('   Flow %d has %d different routing paths provided by the network.\n', i, nSP(i));
end