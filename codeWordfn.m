% codeWordfn divides the binary string into codewords of specified size
% Input : binary string and codeWord size
% Output : returns Codewords matrix [number of Codewords x size of Codeword]

function [codeWords]=codeWordfn(string,sizeCodeword)
  No_of_Features=length(string);
%  number of codewords
  noCodewords=No_of_Features/sizeCodeword;
  codeWords=zeros(noCodewords,sizeCodeword);
  x_index = 1 ;
%  array of codeWords
  for k=1:sizeCodeword:(No_of_Features-sizeCodeword+1)
      first_value= k;
      last_value = k+(sizeCodeword-1);
      codeWords(x_index,:)=string(first_value:last_value);
      x_index = x_index + 1 ;
  end
end