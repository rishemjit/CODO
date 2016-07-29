% ecc(x) function is Error correcting code design problem in which minimum
%        Hamming distance is maximized.
% Input : Vector of individual's attitudes (1 x 1 x nvars)
% Output : scalar (fitness value) computed at x

function [y]= Ecc(x)
% check to see the number of features
No_of_Features = size(x,3);
sizeCodeword = 12;
value = mod(No_of_Features,sizeCodeword);
if (value~=0) || (No_of_Features <= sizeCodeword)
    error('Invalid Input Number of features must be multiple of sizeCodeword ''(%d)'' and be more than  sizeCodeword ''(%d)', sizeCodeword);
end
String = reshape(x,1,No_of_Features);
%  Hamming_string to codeWords

noCodeword = No_of_Features/sizeCodeword;
codeWords = codeWordfn(String,sizeCodeword);
%  Hamming_distance
Hamming_distance =[];
for k = 1:noCodeword
    for l = 1:noCodeword
        if k ~= l
            Hamming_string = xor(codeWords(k,:),codeWords(l,:));
            Hamming_distance = [Hamming_distance sum(Hamming_string)];
        end
    end
end
%  Society_fitness
y = -(1/sum((Hamming_distance).^-2));
end