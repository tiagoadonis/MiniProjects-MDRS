% 8a, 8b

function [sP1 a1 sP2 a2]= calculateDisjointPaths(L,T)
    nFlows= size(T,1);
    for i=1:nFlows
        [shortestPath, totalCost] = kShortestPath(L,T(i,1),T(i,2),1);
        sP1{i}= shortestPath;
        a1(i)= exp(-totalCost);
        path1= shortestPath{1};
        Laux= L;    % Laux = L original, onde se colocam a inf as ligaçoes usadas no primeiro percurso
        for j=2:length(path1)
            Laux(path1(j),path1(j-1))= inf;
            Laux(path1(j-1),path1(j))= inf;
        end
        [shortestPath, totalCost] = kShortestPath(Laux,T(i,1),T(i,2),1);
        if length(shortestPath)>0
            sP2{i}= shortestPath;
            a2(i)= exp(-totalCost);
        else
            sP2{i}= {[]};
            s2(i)= 0;
        end
    end
end

% d = a*b
% d = exp(log(a*b)) = exp(log(a)+log(b)) = -log(a)-log(b)