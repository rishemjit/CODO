% graph(a) is constructing a bi-partite graph for maxcut problem
% Input : nvars representing verticies of a graph 
% Output : [A] is adjacency matrix [nvars x nvars]
function [A]=graph(a)
  No_of_Vertex = a;
  i=1;
      for j = No_of_Vertex/2+1:No_of_Vertex-1 
          A(i,i+1) = 1;
          A(i+1,i) = 1;
          A(j,j+1) = 1;
          A(j+1,j) = 1;
          A(i,j+1) = 10;
          A(j+1,i) = 10;
          A(i+1,j) = 10;
          A(j,i+1) = 10;
          i=i+1;
      end
