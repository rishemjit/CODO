% MaxCut(x) function is Maximum cut of a graph problem
% Input : Vector of individual's attitudes (1 x 1 x nvars)
% Output : scalar (fitness value) computed at a

function [y]= MaxCut(x)

% check to see the number of features
  No_of_Features = size(x,3);
  partitions  = 2 ; 
  value = mod(No_of_Features,partitions);
  if (value ~= 0) || (No_of_Features < partitions)
    error('SITO:InvalidInput','Number of features must be multiple of number of partitions ''%d''', partitions ,...
    'and to construct a graph number of verticies should be more than partitions ''%d''''+1', partitions );
  end
  String = reshape(x,1,No_of_Features);   
  n = No_of_Features;
  A = zeros(n,n);
%   assigning zeros to vertex set v
  v = find( String == 0 );
%   assigning ones to vertex set V
  V = find( String == 1 );
%   call to graph function 
  [A]= graph(n);
  w = A;
  f=0;
  for k = 1 : n-1
      for l = k+1 : n
%  to check k and l are in different partitions
          if find( k == v )~= 0
              a(k) = 1;
          elseif find( k == V )~= 0
              a(k) = -1;
          end
          if find( l == v)~= 0
              a(l) = 1;
          elseif find( l == V )~=0
              a(l) = -1;
          end
%   if k and l are in different partitions only then w(k,l) contributes to the sum
        if a(k)~= a(l)
           f = f + w(k,l)*(a(k)*(1-a(l))+a(l)*(1-a(k)));
        end
      end
  end
  y = -f/2;
 end