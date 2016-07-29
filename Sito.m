function [x,fVal]  = Sito(funct, nvars, options)
%   X = SITO(FITNESSFCN,NVARS) finds a local unconstrained minimum X to the
%   FITNESSFCN using SITO. NVARS is the dimension (number of design
%   variables) of the FITNESSFCN. 
%   Right now pass a fitness function for your problem 
%   Please pass functions having binary inputs i.e {0,1} for bettar results..
%   We will be folowing with a continuous version too.


%% create default options if no option has been provided
close all
clc
defaultopt = struct('PopulationType', 'bitString', ...
    'PopInitRange', [0;1], ...
    'SocietySize', 7, ...
    'DiversityFactor',0.95,...
    'NeighbourhoodSize',2,...
    'InitialPopulation',[], ...
    'CreationFcn',[], ...
    'Display', 'on', ...
    'MaxIteration', 100, ...
    'FitnessLimit',[],...
    'Tolerance', [],...
    'Variant','Osito');

% Check number of input arguments
errmsg = nargchk(1,3,nargin);
if ~isempty(errmsg)
    error('SITO:numberOfInputs',...
        [errmsg,' SITO requires at least 1 input argument.']);
end

% If just 'defaults' passed in, return the default options in X
if nargin == 1 && nargout <= 1 && isequal(funct,'defaults')
    x = defaultopt;
    return
end

if nargin < 3
    options = [];
end

% One input argument is for problem structure
if nargin == 1
   if isa(funct,'struct')
      [funct,nvars,options] = separateOptimStruct(funct);
        
   else % Single input and non-structure.
       error('SITO:invalidStructInput',['The input should be a structure with valid'... 
      'fields or provide at least two arguments to SITO.'] );
   end
end

% not handling cell arrray because we find it to be weird way of
% calling function
FitnessFcn = funct;
% Only function handles is allowed for FitnessFcn
if isempty(FitnessFcn) ||   ~isa(FitnessFcn,'function_handle')
   error('SITO:needFunctionHandle','Fitness function must be a function handle.');
end

                                               % nvars checking before we call SITO solver
valid = isnumeric(nvars) && isscalar(nvars)&& (nvars > 0) ...
    && (nvars == floor(nvars));
if ~valid
    error('SITO:notValidNvars','Number of variables (NVARS) must be a positive integer.');
end

% user_options = options;

% Use default options if options structure is empty
if ~isempty(options) && ~isa(options,'struct')
   error('SITO:optionsNotAStruct','Third input argument must be a valid structure created with SITOOPTIMSET.');
elseif isempty(options)
   options = defaultopt;
end
% Take defaults for parameters that are not in options structure

avg_neighbors = 5 ;
variant = lower(options.Variant);
if strcmp(variant,'gsito')
   if isempty(options.Group)
       No_of_Individuals = (options.SocietySize)^2;
       options.Group = ceil(No_of_Individuals/avg_neighbors);
   end
end

options = SitoOptimset(defaultopt,options);
funcname = str2func(options.Variant);

% call SITOVALIDATE
[options] = SitoValidate(FitnessFcn,nvars,options);

% call SITOSOLVER
[x,fVal] = feval(funcname,FitnessFcn,nvars,options);
