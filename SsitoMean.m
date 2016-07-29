function [x,fVal] = SsitoMean(funct,nvars,options)
% Osito(funct,nvars,options) is Simplified SITO Algorithm which uses Mean rule as
%          update rule.
% Input : funct is handle to fitness function.
%         nvars is positive integer value representing number of features.
%         options is structure of parameters as specified by user
% Output: x is row vector of best individual's atitudes.
%         fVal is the value of the fitness function at x.

%     'PopulationType', 'bitString', ...
%     'PopInitRange', [0;1], ...
%     'SocietySize', 7, ...
%     'DiversityFactor',0.95,...
%     'NeighbourhoodSize',2,...
%     'InitialPopulation',[], ...
%     'CreationFcn',[], ...
%     'Display', [], ...
%     'MaxIteration', [], ...
%     'FitnessLimit',[],...
%     'Tolerance', []);


% It is populationSize in options structure
No_of_Individuals = (options.SocietySize).^2; % it should have proper square root
row = sqrt(No_of_Individuals);

No_of_Features = nvars ; % passed by user here
Max_Iter = options.MaxIteration ; % goes in options structure
Neighbourhood = options.NeighbourhoodSize; % goes in options structure

exponent = 0; % exponent for distance (Lp and Ls)

K = options.DiversityFactor ;
column= row;
Society_Strength = [] ;
disp = {'off','on'};
lowArg = lower(options.Display);
dispFlag = strmatch(lowArg,disp)-1;

% check if InitialPopulation and CreationFcn are empty than run the default

if (isempty(options.InitialPopulation)&& isempty(options.CreationFcn))
    % creation function this is the default one
    for r = 1 : row

        for c = 1: column
            noOnes =  round(No_of_Features * rand);
            onesIndices = 1+ round((No_of_Features -1)* rand(noOnes,1));
            Society_Attitude(r,c,onesIndices) = 1;
        end

    end

elseif (isempty(options.InitialPopulation)&& ~( isempty(options.CreationFcn)))
    options = feval(options.CreationFcn,options);
    Society_Attitude = options.InitialPopulation ;

else
    Society_Attitude = options.InitialPopulation ;
end

% check to see if Fitness Function exists in the path
funcname = func2str(funct);
if ~exist(funcname,'file')
    error('MATLAB:sitoOptimset:FcnNotFoundOnPath', ...
        'the function ''%s'' does not exist on the path.',funcname);
end


%%

i = 1 ; % iterator
flag='done';
while ( strcmp(flag,'done'))

    for j = 1:row
        for k= 1:column
            
            Society_Fitness(j,k) = funct(reshape(Society_Attitude(j,k,:), No_of_Features,1));
      
        end
    end

    fMax= max(max(Society_Fitness));
    fMin= min(min(Society_Fitness));
    fAvg = mean(mean(Society_Fitness));
    
    if dispFlag % if Dispaly Flag is ON 

        subplot(2,1,1); plot(i,fMax,'*') ;hold on
        subplot(2,1,1); plot(i,fMin,'.'); hold on
        subplot(2,1,1); plot(i,fAvg,'s'); hold on
        title(sprintf('max fitness = %f; avg fitness = %f; min fitness = %f ', fMax, fAvg, fMin ));
    end
       
     for r = 1:row
         for c = 1:column
             for d = 1: No_of_Features
                 [row_index1,row_index2,column_index1,column_index2] = NeighbourIndex(r,c,row,column,Neighbourhood);                           
                 Individual_Fitness = Society_Fitness(r,c);
                 Individual_Value = Society_Attitude(r,c,d);
                 Individual_Neighbourhood = Society_Attitude(row_index1 : row_index2,column_index1 : column_index2 ,d );
%  Social Strength associated with pair of Individuals  
                 Neighbourhood_Strength = max(Individual_Fitness-(Society_Fitness(row_index1 : row_index2,column_index1 : column_index2)),0);
                 [Supporter_Index]  =  find(Individual_Neighbourhood==Individual_Value);% positions of supporters
                 [Sources_Index]  =  find(Individual_Neighbourhood==~Individual_Value); % positions of opposers
                 Ns = length(Supporter_Index) ; % no of supporters excluding itself
                 No = length(Sources_Index);
              
                 if Ns ~= 0
                    Ls =  (sum(Neighbourhood_Strength(Supporter_Index)))/Ns;% supportive impact
                 else
                    Ls = 0 ;
                 end

                 if No ~= 0
                    Lp = (sum(Neighbourhood_Strength(Sources_Index)))/No;% persuasive impact
                 else
                    Lp = 0 ;
                 end
              
 %   Comparing supportive impact and persuasive impact 
                 if (Lp > Ls)&&(Society_Fitness(r,c)>fMin)
                     ra = rand;
                     if ra >= 1-K
                        Society_Attitude_temp(r,c,d) = ~Society_Attitude(r,c,d);
                     else
                        Society_Attitude_temp(r,c,d) = Society_Attitude(r,c,d);
                     end
                 elseif (Lp <= Ls)&&(Society_Fitness(r,c)>fMin)
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
      if dispFlag % if Dispaly Flag is ON 
      figure(1); 
      axes('position',[.35  .15  .35  .3]);
      imagesc( Society_Fitness );
      end
        

    Society_Attitude = Society_Attitude_temp;
    i = i + 1 ; 
    
    if i > Max_Iter
        exitflag = 1 ; % say it came out because of iterations. 
        flag = 'done' ;
        output.iterations = i ;
        break ;
    end
end

[rbest,cbest] = find(Society_Fitness==fMin);
x= reshape(Society_Attitude(rbest(1),cbest(1),:),1,No_of_Features);
fVal = Society_Fitness(rbest(1),cbest(1));
end

