function [x,fVal] = CODO(funct,nvars,options)

% CODO(funct,nvars,options) is coontinous opinion dynamics optimizer published in NAture Scientific Reports.
% Input : funct is handle to fitness function.
%         nvars is positive integer value representing number of features.
%         options is structure of parameters as specified by user
% Output: x is row vector of best individual's atitudes.
%         fVal is the value of the fitness function at x.

%     'PopulationType', 'doubleVector', ...
%     'PopInitRange', [-1;1], ...
%     'SocietySize', 7, ...
%     'DiversityFactor',0.95,...
%     'NeighbourhoodSize',2,...
%     'InitialPopulation',[], ...
%     'CreationFcn',[], ...
%     'Display', [], ...
%     'MaxIteration', [], ...
%     'FitnessLimit',[],...
%     'Tolerance', []);

rand('state',sum(100*clock));
% It is populationSize in options structure
No_of_Individuals = (options.SocietySize).^2; %No of individuals in the society or society size.
Neighbourhood = options.NeighbourhoodSize; % goes in options structure;Moore neighbourhood size
K = options.DiversityFactor ; % strength of disintegrating forces

%%
row = sqrt(No_of_Individuals);

No_of_Features = nvars ; % passed by user here;% dimensions of search space or no of features
Max_Iter = options.MaxIteration ; % goes in options structure
Max_FE = Max_Iter*No_of_Individuals ; % max no of function evaluations
range = options.PopInitRange;
Xmin= range(1);
Xmax = range(2);
column= row;
Society_Strength  = [] ;
disp = {'off','on'};
lowArg = lower(options.Display);
dispFlag = strmatch(lowArg,disp)-1;

% check if InitialPopulation and CreationFcn are empty than run the default

if (isempty(options.InitialPopulation)&& isempty(options.CreationFcn))
    % creation function this is the default one
    Society_Attitude = Xmin+(Xmax-Xmin).*rand(row, row,No_of_Features,1);

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


FE =0;
%%
i=1; % iterator
flag = 'done';
while ( strcmp(flag,'done'))
    FE=FE+No_of_Individuals;
    for j = 1:row
        for k = 1:column
            Society_Fitness(j,k) = funct(reshape(Society_Attitude(j,k,:), No_of_Features,1));
        end
    end

    fMin= min(Society_Fitness(:));
    fAvg = mean(Society_Fitness(:));
    fMax= max(Society_Fitness(:));

    if dispFlag % if Dispaly Flag is ON
        subplot(2,1,1); plot(i,fMax,'*') ;hold on
        subplot(2,1,1); plot(i,fMin,'.'); hold on
        subplot(2,1,1); plot(i,fAvg,'s'); hold on
        title(sprintf('max fitness = %f; avg fitness = %f; min fitness = %f ', fMax, fAvg, fMin ));
    end

    Society_Fitness1d = reshape(Society_Fitness, No_of_Individuals,1);
    UniqueIndFit = unique(Society_Fitness(:));
    for conStr = 1: length(UniqueIndFit)
        indexFit =find(Society_Fitness(:)==UniqueIndFit(conStr));
        Society_Strength1d(indexFit) =length(UniqueIndFit)- conStr +1;
    end

    Society_Strength =reshape(Society_Strength1d, row, column);
    maxStrength = max(Society_Strength1d) ;









    maxStrength = max(Society_Strength1d);

    if dispFlag % if Dispaly Flag is ON
        figure(1); subplot(2,1 ,2 );   imshow( Society_Fitness);
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
                 Neighbourhood_Fitness = Society_Fitness(row_index1 : row_index2,column_index1 : column_index2);
                Neighbourhood_Strength = Society_Strength(row_index1 : row_index2,column_index1 : column_index2);
                Size_Individual_Neighbourhood = size(Individual_Neighbourhood,1)* size(Individual_Neighbourhood,2);
                %                 [Supporter_Index]  =  find(Individual_Neighbourhood==Individual_Value);% positions of supporters
                %                 [Sources_Index]  =  find(Individual_Neighbourhood==~Individual_Value); % positions of opposers
                %
                %                 Ns = length(Supporter_Index)- 1 ; % no of supporters excluding itself
                %
                %                 No   = length(Sources_Index);
                %
                %                 x_index = 1 ; % x_index for distance matrix
                %                 y_index = 1 ; % y_index for distance matrix

                % euclideanDistance function to  calculate euclidean distance for individual neighbourhood
                [distance] = euclideanDistance(r,c,row_index1,row_index2,column_index1,column_index2);
                distance = distance(:);
                Neighbourhood_Strength = Neighbourhood_Strength(:);
                Individual_Neighbourhood = Individual_Neighbourhood(:);
                Individual_position = find(distance==0);
                Individual_Neighbourhood(Individual_position) = [];
                IndStrength = Neighbourhood_Strength(Individual_position);
                IndFitness = Neighbourhood_Fitness(Individual_position);
                Neighbourhood_Fitness(Individual_position) = [];
                Neighbourhood_Strength(Individual_position)= [];
                distance(Individual_position)=[];


                weights = Neighbourhood_Strength./ distance;

                %     weights = exp(-((Neighbourhood_Strength -IndStrength ).^2)./distance);

                deltaAtt =  (sum((Individual_Neighbourhood - Individual_Value).*weights))./(sum(weights));
                %                 if(fitcount <= 10000)
                noiseStdDev = K*sum(exp(-abs(Neighbourhood_Fitness -IndFitness ))) ;

                if (Society_Strength(r,c) ~=   maxStrength)
                    addnoise = noiseStdDev*randn ;
                    %                          addnoise = 0;
                    Society_Attitude_temp(r,c,d) =  Society_Attitude(r,c,d) +deltaAtt+addnoise;
                    if(Society_Attitude_temp(r,c,d) >Xmax)
                        Society_Attitude_temp(r,c,d) = Xmax;
                    elseif (Society_Attitude_temp(r,c,d) <Xmin)
                        Society_Attitude_temp(r,c,d) = Xmin;
                    end
                elseif(mean(mean(Society_Strength))==1)

                    addnoise = noiseStdDev*randn ;
                    %                          addnoise = 0;
                    Society_Attitude_temp(r,c,d) =  Society_Attitude(r,c,d) +deltaAtt+addnoise;
                    if(Society_Attitude_temp(r,c,d) >Xmax)
                        Society_Attitude_temp(r,c,d) = Xmax;
                    elseif (Society_Attitude_temp(r,c,d) <Xmin)
                        Society_Attitude_temp(r,c,d) = Xmin;
                    end
                else
                    Society_Attitude_temp(r,c,d) =  Society_Attitude(r,c,d);

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