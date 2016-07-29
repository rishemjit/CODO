% NeighbourIndex function finds individual's neighbours. 
% Input Parameters  : [r,c] specifies particular individual.
%                     Neighbourhood is set in options structure 
% Output Parameters : [row_index1,row_index2,column_index1,column_index2]
%                     specifies indicies to retrieve neighbors around an indvidual.                       

function [row_index1,row_index2,column_index1,column_index2] = NeighbourIndex(r,c,row,column,Neighbourhood)           

         row_index1 = r - Neighbourhood ;
         if row_index1 <= 0
            row_index1 =1 ;
         end
         row_index2 = r + Neighbourhood ;
         if row_index2 > row
            row_index2 = row ;
         end
         column_index1 = c - Neighbourhood ;
         if column_index1 <= 0
            column_index1 =  1 ;
         end
         column_index2 = c + Neighbourhood ;
         if column_index2 > column
            column_index2 =  column ;
         end             
end