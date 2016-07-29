% bin2real(codeWords,min,max) function converts the binary string to real
%         value in the specified range
% Input : codeWords matrix [number of Codewords x size of Codeword] and range is specified
% Output : row vector of real values

function [realValue]=bin2real(codeWords,min,max)
  sizeCodeword=size(codeWords,2);
  xmin = min;
  xmax = max;
  realValue=[];
  for l=1:size(codeWords,1)
      codeWord=codeWords(l,:);
%  function to convert binary string to decimal value
      dec_value=bin2decimal(codeWord); 
%  convert decimal value to real value in specified range      
      realValue(1,l)=xmin+dec_value*(xmax-xmin)/(2^(sizeCodeword)-1);
  end