% rastriginfn(x) function is binary encoded continuous benchmark function using the 
%           precision 4 places after decimal point.
% Input : Vector of individual's attitudes 
% Output : scalar (fitness value) computed at a 

function [f]=Rastriginfn(a)
% check to see the number of features
  No_of_Features=length(a);
  value = mod(No_of_Features,17);
  if (value~=0) || (No_of_Features < 17)
    error('SITO:InvalidInput','Number of features must be multiple of 17 and be more than 17');
  end
  
  sizeCodeword=17;
% convert string to codewords
  codeWords = codeWordfn(a,sizeCodeword);
% specifying the range 
  xmax = 5.12;
  xmin = -5.12;
% convert binary strings to  respective real values
  realValue=bin2real(codeWords,xmin,xmax);
% rastrigin function
  f=sum(realValue.^2,2)-10.*sum(cos(2*pi*realValue),2);
  f=f+10*size(realValue,2);
end