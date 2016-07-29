clc 
clear all 
close all
No_of_Individuals = 49; % it should have proper square root
row = sqrt(No_of_Individuals);
No_Dim = 2;
No_of_Features = 120; % 
Max_Iter = 500;
Neighbourhood_initial = 2;
Neighbourhood_final = 2;
M_neigh =  (Neighbourhood_initial - Neighbourhood_final)/ (1- Max_Iter);
Const_neigh  = Neighbourhood_initial -M_neigh;
exponent = 2; % exponent for distance (Lp and Ls)

% K_initial = 0.9;
% K_final = 0.01;
% w1 = 0.5 ;
% w2 = 0.5 ;
%  M = (K_initial - K_final) / (1- Max_Iter);
%  const = K_initial + M ; 
K = 0.97;
column= row;
Society_Strength = [] ;
tic
for r = 1 : row
    for c = 1: column
        noOnes =  round(No_of_Features * rand);   
        onesIndices = 1+ round((No_of_Features -1)* rand(noOnes,1));
        Society_Attitude(r,c,onesIndices) = 1;       
    end

end
%   Society_Attitude = round(rand(row,row,No_of_Features));% randomly initialize attitude matrix(20,20,No_of_Features )

centre1 = zeros(1,No_of_Features/2);
centre2 = ones(1,No_of_Features/2);
centre = [centre1 centre2];
% %centre = [  1 0 1 0 1 0 1 0 1 0 1 0];
% Adamancy = rand(row,row); 
%  
 
for i = 1:Max_Iter
    
    Neighbourhood = round(M_neigh * i + Const_neigh) ; 
    for j = 1:row
       for k= 1:column
               Society_Fitness(j,k)=bipolarfn(Society_Attitude(j,k,:));
%            Hamming_string = xor(reshape(Society_Attitude(j,k,:),1,No_of_Features), centre) ;
%            Society_Fitness(j,k) = length(find(Hamming_string))/No_of_Features; 
%           Society_Attitude_1d = reshape(Society_Attitude(j,k,:),1,No_of_Features);
%            Float_Attitude = bin2float(Society_Attitude_1d,No_Dim);
%            Society_Fitness(j,k) = rastriginsfcn(Float_Attitude) ;
       end
    end
        
   fMax= max(max(Society_Fitness));
   fMin= min(min(Society_Fitness));
   fAvg =mean(mean(Society_Fitness));
   figure(1), subplot(2,1,1); plot(i,fMax,'*') ;hold on
              subplot(2,1,1); plot(i,fMin,'.'); hold on
              subplot(2,1,1); plot(i,fAvg,'s'); hold on
   Prev_Society_Strength = Society_Strength ;
   if fMax == fMin  
        Society_Strength  = Prev_Society_Strength  ;
   else
   Society_Strength = (fMax -Society_Fitness)/(fMax-fMin);
   end
   maxStrength = 1 ;
    %maxStrength = max(max(Society_Strength));
   
    figure(1); subplot(2,1 ,2 );   imshow( Society_Strength );
    colormap(jet);
    
     
   for r = 1:row
        for c = 1:column
            distance=[];
            for d = 1: No_of_Features
                
                
                
                distance = [];
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
                Individual_Value = Society_Attitude(r,c,d);
                Individual_Neighbourhood = Society_Attitude(row_index1 : row_index2,column_index1 : column_index2 ,d );
                Neighbourhood_Strength = Society_Strength(row_index1 : row_index2,column_index1 : column_index2);
                Size_Individual_Neighbourhood = size(Individual_Neighbourhood,1)* size(Individual_Neighbourhood,2);
                [Supporter_Index]  =  find(Individual_Neighbourhood==Individual_Value);% positions of supporters
                [Sources_Index]  =  find(Individual_Neighbourhood==~Individual_Value); % positions of opposers
                
                Ns = length(Supporter_Index)- 1 ; % no of supporters excluding itself
                
                No   = length(Sources_Index);
                
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
                
                Individual_position = find(distance==0);
                
                
                temp = find(Supporter_Index==Individual_position);
                Supporter_Index(temp) = [];
                
                
                if Ns ~= 0
                    Ls =   (sum(Neighbourhood_Strength(Supporter_Index) ./ distance(Supporter_Index).^exponent))/ sqrt(Ns); %+ w1*Individual_Value; % supportive impact
                    
                else
                    Ls =  0 ;
                end
                if No ~= 0
                    Lp =    (sum(Neighbourhood_Strength(Sources_Index) ./ distance(Sources_Index).^exponent))/ sqrt(No) ;%+ w2*(~Individual_Value ); % persuasive impact
                    
                else
                    Lp =  0 ;
                end
                
                
                %                 if Lp > Ls && (Society_Strength(r,c) < 1)
                %                     Society_Attitude_temp(r,c,d) = ~Society_Attitude(r,c,d);
                %                     else
                %                     Society_Attitude_temp(r,c,d) = Society_Attitude(r,c,d);
                %                 end
                
                if  Lp >= Ls  && (Society_Strength(r,c) <  maxStrength)
                    ra= rand;
                    if ra >= 1-K
                        Society_Attitude_temp(r,c,d) = ~Society_Attitude(r,c,d);
                    else
                        Society_Attitude_temp(r,c,d) = Society_Attitude(r,c,d);
                    end
                elseif (Lp < Ls) && (Society_Strength(r,c) <   maxStrength)
                    ra= rand;
                    if ra >= K
                        Society_Attitude_temp(r,c,d) = ~Society_Attitude(r,c,d);
                    else
                        Society_Attitude_temp(r,c,d) =  Society_Attitude(r,c,d);
                    end
                end
                
            end
            
        end
        
    end
    Society_Attitude = Society_Attitude_temp;
end
toc