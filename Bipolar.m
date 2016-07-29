% bipolar(x) function is massively multimodal deceptive problem.
% Input : Vector of individual's attitudes (1 x 1 x nvars)
% Output : scalar (fitness value) computed at x 

function [y]= Bipolar(x)
% check to see the number of features
  No_of_Features = size(x,3);
  sizeCodeword = 6;
  value = mod( No_of_Features,sizeCodeword );
  if ( value ~= 0) || (No_of_Features <= sizeCodeword )
    error('Invalid Input Number of features must be multiple of sizeCodeword ''(%d)'' and be more than  sizeCodeword ''(%d)', sizeCodeword);
  end
  String = reshape(x,1,No_of_Features);   
%  Hamming_string to codeWords
%  set codeWord size
     
     noCodewords = No_of_Features/sizeCodeword;
     codeWords = codeWordfn(String,sizeCodeword);
%  fitness values
  fitnessValue=[-.9 ;-.8 ; 0 ;-1];
  y =[];  
  for l = 1 : noCodewords
      codeWord = codeWords(l,:);
      no_ones = sum(codeWord);
%  u is number of ones
%  bipolar-6function = 3orderdeceptivefunction(|3-u|)
      fitnessIndex = abs(3-no_ones);
      y = [y fitnessValue(fitnessIndex+1)];
  end
  y = sum(y);
end