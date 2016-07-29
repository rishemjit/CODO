function [options ] = SitoValidate(funct,nvars,options)

% set the output struct
% output.iterations = 0;
% output.funccount   = 0;
% output.message   = '';
% Validate options and fitness function
if ~strncmpi(options.PopulationType,'bitstring',2)&& ~strncmpi(options.PopulationType,'doubleVector',2) % added doublevector to it 5/3/2013
    options.PopulationType = [];
    error('SITO:WrongPopulationType','currently only PopulationType bitString or doublevector is supported');
end

if strncmpi(options.Variant,'CODO',2)&&~strncmpi(options.PopulationType,'doubleVector',2)
    error('For CODO variant, population type should be doublevector');
end


[m,n] = size(options.PopInitRange);

if ~((m & n) == 1) && ~strncmpi(options.PopulationType,'bitstring',2)% changed 5/3/2013
    options.PopInitRange = [] ;
    error('SITO:WrongPopInitRange','for bitstring population type only [0;1] PopInitRange is supported');
end

if ~((m * n) == 2) && ~strncmpi(options.PopulationType,'doubleVector',2)% changed 5/3/2013
    options.PopInitRange = [] ;
    error('SITO:WrongPopInitRange','for doublevector population type only [xmin , xmax] PopInitRange is supported');
end


if (isinf(options.SocietySize) )
    options.DiversityFactor = [] ;
    error('SITO:WrongSocietySize','SocietySize should not be Infinite');
end

if ~strncmpi(options.Variant,'CODO',2)
    if ~(options.DiversityFactor >= 0 && options.DiversityFactor <=1)
        options.DiversityFactor = [] ;
        error('SITO:WrongDiversityFactor','DiversityFactor should be between 0 and 1');
    end
end
if ~(options.NeighbourhoodSize < options.SocietySize && options.NeighbourhoodSize ~= 0)
    options.NeighbourhoodSize = [] ;
    error('SITO:NeighbourhoodSize','NeighbourhoodSize should be > 0 and less than SocietySize');
end

No_of_Individuals = (options.SocietySize)^2;
variant = lower(options.Variant);
if strcmp(variant,'gsito')
    if ~(options.Group < No_of_Individuals && options.Group ~= 0)
        options.Group = [] ;
        error('SITO:Group','Group should be > 0 and less than Number of Individuals');
    end
else
    disp('Group field in SitoOptimset is used only for GSITO. Simulation is running ignoring the GROUP field. ');
end
%% check initial population if given by user
[state,options]= SitoCheckInitpop(nvars,options);

%% check creationFcn Handle
%     'CreationFcn',[], ...
%     'Display', [], ...
%     'MaxIteration', [], ...
%     'FitnessLimit',[],...
%     'Tolerance', []);
% check if creationFcn is empty, yes get out code will handle it
if isempty(options.CreationFcn)
    return 
end
if    ( ischar(options.CreationFcn) ||  isa(options.CreationFcn,'function_handle'))
    if ischar(options.CreationFcn)
        funcname = lower(options.CreationFcn);
        if ~exist(funcname,'file')
            error('MATLAB:sitoOptimset:FcnNotFoundOnPath', ...
                'the function ''%s'' does not exist on the path.',funcname);
        end
    elseif isa(options.CreationFcn,'function_handle')
        funcname = func2str(options.CreationFcn);
        
        if ~exist(funcname,'file')
            error('MATLAB:sitoOptimset:FcnNotFoundOnPath', ...
                'the function ''%s'' does not exist on the path.',funcname);
        end
    end
    

else
    error('SITO:needFunctionHandleorFunctionName','Fitness function must be a function handle or FunctionName.');
end

%% other options I guess have been checked in optimset

%%

end