function [x,fVal] = Osito(funct,nvars,options)
% Osito(funct,nvars,options) is Original Distance based SITO Algorithm.
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
No_of_Individuals = (options.SocietySize).^2; 
row = sqrt(No_of_Individuals);

No_of_Features = nvars ; % passed by user here
Max_Iter = options.MaxIteration ; % goes in options structure
Neighbourhood = options.NeighbourhoodSize; % goes in options structure

exponent = 2; % exponent for distance (Lp and Ls)

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

%   Society_Attitude = round(rand(row,row,No_of_Features));% randomly initialize attitude matrix(20,20,No_of_Features )

%%
i = 1 ; % iterator
flag = 'done';
while ( strcmp(flag,'done'))

    for j = 1:row
        for k = 1:column
            Society_Fitness(j,k) = funct(reshape(Society_Attitude(j,k,:), No_of_Features,1));
        end
    end
    
    fMin= min(min(Society_Fitness));
    fAvg = mean(mean(Society_Fitness));
    fMax= max(max(Society_Fitness));

    if dispFlag % if Dispaly Flag is ON 
        subplot(2,1,1); plot(i,fMax,'*') ;hold on
        subplot(2,1,1); plot(i,fMin,'.'); hold on
        subplot(2,1,1); plot(i,fAvg,'s'); hold on
        title(sprintf('max fitness = %f; avg fitness = %f; min fitness = %f ', fMax, fAvg, fMin ));
    end
    
    Prev_Society_Strength = Society_Strength ;
    if fMax == fMin
        Society_Strength  = Prev_Society_Strength  ;
    else
        Society_Strength = (fMax -Society_Fitness)/(fMax-fMin);
    end
  
    maxStrength = max(max(Society_Strength));

    if dispFlag % if Dispaly Flag is ON 
        figure(1); subplot(2,1 ,2 );   imshow( Society_Strength );
        colormap(jet);
    end

    for r = 1:row
        for c = 1:column
            distance=[];
            for d = 1: No_of_Features
                distance = [];
%   function to compute the neighbourhood of particular individual               
                [row_index1,row_index2,column_index1,column_index2] = NeighbourIndex(r,c,row,column,Neighbourhood);
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

 % euclideanDistance function to  calculate euclidean distance for individual neighbourhood
              [distance] = euclideanDistance(r,c,row_index1,row_index2,column_index1,column_index2);
              Individual_position = find(distance==0);

              temp = find(Supporter_Index==Individual_position);
              Supporter_Index(temp) = [];

              if Ns ~= 0
                 Ls =   (sum(Neighbourhood_Strength(Supporter_Index) ./...
                       distance(Supporter_Index).^exponent))/ sqrt(Ns); % supportive impact
              else
                 Ls =  0 ;
              end
              if No ~= 0
                 Lp =    (sum(Neighbourhood_Strength(Sources_Index) ./...
                       distance(Sources_Index).^exponent))/ sqrt(No) ; % persuasive impact
              else
                 Lp =  0 ;
              end

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
    i = i + 1 ; 
    
    if i > Max_Iter
        exitflag = 1 ; % say it came out because of iterations. 
        flag = 'done' ;
        output.iterations = i ;
        break ;
    end
end

[rbest,cbest] = find(Society_Strength==maxStrength);
x = reshape(Society_Attitude(rbest(1),cbest(1),:),1,No_of_Features);
fVal = Society_Fitness(rbest(1),cbest(1));
end