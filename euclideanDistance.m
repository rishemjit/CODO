% euclideanDistance function calculates the eucledian distance between individuals.
% Input Parameters  : [r,c] specifies particular individual.
% Output Parameters : distance matrix specifies calculated distance between
%                     individual and its neighbors.

function [distance] = euclideanDistance(r,c,row_index1,row_index2,column_index1,column_index2)           
         x_index = 1 ; % x_index for distance matrix
         y_index = 1 ; % y_index for distance matrix

         % euclidean distance calculation for individual neighbourhood
         for row_index = row_index1 : row_index2
             y_index = 1 ;
             for column_index =  column_index1 : column_index2
                 distance(x_index ,y_index) = sqrt((r - row_index)^2  + (c - column_index)^2) ; % distance finding
                 y_index = y_index + 1 ;
             end
             x_index = x_index + 1 ;
         end
end
