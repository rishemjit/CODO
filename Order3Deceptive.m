% order3deceptive(x) function is massively multimodal deceptive problem.
% Input : Vector of individual's attitudes 
% Output : scalar (fitness value) computed at x 

function [y]= Order3Deceptive(x)
% check to see the number of features
  No_of_Features = length(x);
     
%  Hamming_string to codeWords
  if ~isempty(x)
%  set codeWord size
     sizeCodeword = 3;
     noCodewords = No_of_Features/sizeCodeword;
     codeWords = zeros(noCodewords,sizeCodeword);
     x_index = 1 ;
%  array of codeWords
     for k = 1:sizeCodeword:(No_of_Features - sizeCodeword+1)
         first_value = k;
         last_value = k+(sizeCodeword-1);
         codeWords(x_index,:)= x(first_value:last_value);
         x_index = x_index + 1 ;
     end
  end
  
%  fitness values
  f=[-28;-26;-22;0;-14;0;0;-30];
  r=[];  
  for l = 1:noCodewords
      codeWord = int2str(codeWords(l,:));
%  convert binary value to decimal value
      dec_value = bin2dec(codeWord);
%  assigning fitness value according to decimal value  
      r = [r f(dec_value+1)];
  end
  y=sum(r);
end