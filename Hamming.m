% Hamming(x) function computes the hamming distance
% Input : Vector of individual's attitudes 
% Output : scalar (fitness value) computed at a

function y = Hamming(inp)
% check to see the number of features
No_of_Features = length(inp);
centre1 = zeros(No_of_Features/2,1);
centre2 = ones(No_of_Features/2,1);
% the default string
centre = [centre1; centre2];
% computes the difference between individual's attitudes with the default string
Hamming_string = xor(inp, centre) ;
y = length(find(Hamming_string))/ No_of_Features;
end