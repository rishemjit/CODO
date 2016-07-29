% onemax(x) function counts the number of ones in the string
% Input : Vector of individual's attitudes 
% Output : scalar (fitness value) computed at x

function [y]= OneMax(x)
% check to see the number of features
    No_of_Features = length(x);
    
    count_ones = sum( x );
    count_zeros = No_of_Features - count_ones;
    y = count_zeros;
end