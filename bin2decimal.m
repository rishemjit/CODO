% bin2decimal(string) function converts the binary string to decimal value
% Input : row vector(binary string)
% Output : returns scalar(decimal value of string)

function [decimalValue]=bin2decimal(string)
         decimalValue=0; count=0;
         for x=length(string):-1:1
             if string(x)==1 
                decimalValue=decimalValue+2^count;
             end   
             count=count+1;
         end
end