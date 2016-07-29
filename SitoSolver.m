function x = SitoSolver(funct,nvars,options)

% PopulationType', 'bitString', ...
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

%   Society_Attitude = round(rand(row,row,No_of_Features));% randomly initialize attitude matrix(20,20,No_of_Features )

%%
x = OsitoSolver(Society_Attitude,funct,dispFlag);

end

