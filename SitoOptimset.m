function options  = SitoOptimset(varargin)
%  SITOOPTIMSET Create/alter SITO OPTIONS structure.
%   SITOOPTIMSET returns a listing of the fields in the options structure as
%   well as valid parameters and the default parameter.
%   
%   OPTIONS = SITOOPTIMSET('PARAM',VALUE) creates a structure with the
%   default parameters used for all PARAM not specified, and will use the
%   passed argument VALUE for the specified PARAM.
%
%   OPTIONS = SITOOPTIMSET('PARAM1',VALUE1,'PARAM2',VALUE2,....) will create a
%   structure with the default parameters used for all fields not specified.
%   Those FIELDS specified will be assigned the corresponding VALUE passed,
%   PARAM and VALUE should be passed as pairs.
%   
%  SITOOPTIMSET PARAMETERS
%
%   PopulationType      - The type of Population being entered
%                       [ {'bitstring'} | 'doubleVector'] # changes for
%                       CODO 04_03_2014
%   PopInitRange        - Initial range of values a population may have
%                       [  {[0;1]} ]
%   SocietySize         - Positive scalar indicating the Society Size. The 
%                         user should input a positive scalar number indicating
%                         row or column of square topology.EG: SocietySize of 7 
%                         indicates a Society of 49 individuals in 7 X 7   
%                       [ positive scalar ]
%   NeighbourhoodSize    - size of the MOORE neighbourhood, value should be less than or equal to SocietySize [positive scalar] 
%   DiversityFactor     - Positive scalar indicating the diversity factor;
%                         strength of disintegrating forces in case of CODO
%                       [ positive scalar(fraction between 0 and 1) ]
%   InitialPopulation   - The initial population used in seeding the SITO
%                         algorithm; 
%                       [ Matrix | {[]} ]
%   CreationFcn         - Function used to generate initial population
%   Display             - Level of display 
%                       [ ''off'/'on'' ]
%   MaxIteration        - Positive scalar indicating the maximum iterations desired
%                       [ positive scalar ]
%   FitnessLimit        - Minimum fitness function value desired 
%                       [ scalar | {-Inf} ]
%   Tolerance           - Termination tolerance on fitness function value
%                       [ positive scalar ]
%   Variant             - [''Osito''/''SsitoSum''/''Gsito''/''SsitoMean''/''CODO''] 
%                           #added CODO 04_03_2014
%   Group               - Positive scalar indicating the number of groups
%                       [ positive scalar ]

%   Copyleft 2012 Ritesh Rishem Amol. copy it use it but cite us.
%   $Revision: 1.1.1.1 $  $Date: 2012/02/10 12:40 IST $

%% pull in everything when no argument is put

if (nargin == 0) && (nargout == 0)
    fprintf('          PopulationType: [ ''bitstring'' ]\n');
    fprintf('          PopInitRange: [  [0;1] ]\n');
    fprintf('          SocietySize: [ positive scalar ]\n');
    fprintf('          DiversityFactor: [ positive scalar fraction ([0 1])]\n');
    fprintf('          NeighbourhoodSize: [ positive scalar]\n');
    fprintf('          InitialPopulation: [ matrix  | {[]} ]\n');
    fprintf('          CreationFcn: [ function_handle ]\n');
    fprintf('          Display: [ ''on/off'']\n');
    fprintf('          MaxIteration : [ positive scalar ]\n');
    fprintf('          FitnessLimit: [ scalar | {-Inf} ]\n');
    fprintf('          Tolerance: [ positive scalar  | {1e-6} ]\n\n');
    fprintf('          Variant: [''Osito''/ ''SsitoSum''/''Gsito''/''SsitoMean''/''CODO'']\n');
    fprintf('          if Variant used Gsito then Group: [ positive scalar ]\n ');
    return; 
end    
%%
numberargs = nargin ; 

%% Return options with default values and return it when called with one output argument
options = struct('PopulationType', [], ...
               'PopInitRange', [], ...
               'SocietySize', [], ...
               'DiversityFactor',[],...
               'NeighbourhoodSize',[],...
               'InitialPopulation',[], ...
               'CreationFcn',[], ...
               'Display', [], ...
               'MaxIteration', [], ...
               'FitnessLimit',[],...
               'Tolerance', [],...
               'Variant', [],...
               'Group',[]);
               
%% If we pass in a function name then return the defaults.
if (numberargs==1) && (ischar(varargin{1}) || isa(varargin{1},'function_handle') )
    if ischar(varargin{1})
        funcname = lower(varargin{1});
        if ~exist(funcname,'file')
            error('MATLAB:sitoOptimset:FcnNotFoundOnPath', ...
                'No default options available: the function ''%s'' does not exist on the path.',funcname);
        end
    elseif isa(varargin{1},'function_handle')
        funcname = func2str(varargin{1});
    end
    try 
        optionsfcn = feval(varargin{1},'defaults');
    catch HERE
        error('MATLAB:optimset:NoDefaultsForFcn', ...
            'No default options available for the function ''%s''.',funcname);
    end
    % The defaults from the optim functions don't include all the fields
    % typically, so run the rest of optimset as if called with
    % optimset(options,optionsfcn)
    % to get all the fields.
    varargin{1} = options;
    varargin{2} = optionsfcn;
    numberargs = 2;
end
Names = fieldnames(options);
m = size(Names,1);
names = lower(Names);
%% structure assigning
i = 1;
while i <= numberargs
    arg = varargin{i};
    if ischar(arg)                        % arg is an option name
        break;
    end
    if ~isempty(arg)                      % [] is a valid options argument
        if ~isa(arg,'struct')
            error('SITOOPTIMSET:invalidArgument',['Expected argument %d to be a string parameter name ' ...
                    'or an options structure\n created with SITOOPTIMSET.'], i);
        end
        for j = 1:m
            if any(strcmp(fieldnames(arg),Names{j,:}))
                val = arg.(Names{j,:});
            else
                val = [];
            end
            if ~isempty(val)
                if ischar(val)
                    val = deblank(val);
                end
                [valid, errmsg] = checkfield(Names{j,:},val);
                if valid
                    options.(Names{j,:}) = val;
                else
                    error('SITOOPTIMSET:invalidOptionField',errmsg);
                end
            end
        end
    end
    i = i + 1;
end

%% parse name-value pairs.
if rem(numberargs-i+1,2) ~= 0
    error('SITOOPTIMSET:invalidArgPair','Arguments must occur in name-value pairs.');
end
expectval = 0;                          % start expecting a name, not a value
while i <= numberargs
    arg = varargin{i};
    
    if ~expectval
        if ~ischar(arg)
            error('SITOOPTIMSET:invalidArgFormat','Expected argument %d to be a string parameter name.', i);
        end
        
        lowArg = lower(arg);
        j = strmatch(lowArg,names);
        if isempty(j)                       % if no matches
            error('SITOOPTIMSET:invalidParamName','Unrecognized parameter name ''%s''.', arg);
        elseif length(j) > 1                % if more than one match
            % Check for any exact matches (in case any names are subsets of others)
            k = strmatch(lowArg,names,'exact');
            if length(k) == 1
                j = k;
            else
                msg = sprintf('Ambiguous parameter name ''%s'' ', arg);
                msg = [msg '(' Names{j(1),:}];
                for k = j(2:length(j))'
                    msg = [msg ', ' Names{k,:}];
                end
                msg = sprintf('%s).', msg);
                error('SITOOPTIMSET:ambiguousParamName',msg);
            end
        end
        expectval = 1;                      % we expect a value next
        
    else           
        if ischar(arg)
            arg = (deblank(arg));
        end
        [valid, errmsg] = checkfield(Names{j,:},arg);
        if valid
            options.(Names{j,:}) = arg;
        else
            error('SITOOPTIMSET:invalidParamVal',errmsg);
        end
        expectval = 0;
    end
    i = i + 1;
end

if expectval
    error('SITOOPTIMSET:invalidParamVal','Expected value for parameter ''%s''.', arg);
end


%% This part is pretty much same as what is there in gaopimset checkfield

function [valid, errmsg] = checkfield(field,value)
%CHECKFIELD Check validity of structure field contents.
%   [VALID, MSG] = CHECKFIELD('field',V) checks the contents of the specified
%   value V to be valid for the field 'field'. 
%

valid = 1;
errmsg = '';
% empty matrix is always valid
if isempty(value)
    return
end

switch field
    case {'PopulationType'}
        if ~isa(value,'char') 
            valid=0;
            errmsg = sprintf('Invalid value for OPTIONS parameter %s.',field);
        end
        
    case {'CreationFcn'}
        if iscell(value) ||  isa(value,'function_handle')
            valid = 1;
        else
            valid = 0;
            errmsg = sprintf('Invalid value for OPTIONS parameter %s.',field);
        end
        
    case {'Tolerance','FitnessLimit','DiversityFactor'} 
        if ~isa(value,'double')  
            valid = 0;
            if ischar(value)
                errmsg = sprintf('Invalid value for OPTIONS parameter %s: must be a real positive number (not a string).',field);
            else
                errmsg = sprintf('Invalid value for OPTIONS parameter %s: must be a real positive number.',field);
            end
        end

    case {'PopInitRange','InitialPopulation'}
        valid = 1;
    
    case {'Display'}
        if ~isa(value,'char') || ~any(strcmpi(value,{'off','on'}))
            valid=0;
            errmsg = sprintf('Invalid value for OPTIONS parameter %s: must be ''off'', or ,''on''.',field);
        end
               
    case {'SocietySize'} % integer including inf or default string
        if ~(isa(value,'double') && all(value(:) >= 0)&& (rem(value,1)==0) ) && ...
                ~strcmpi(value,'15*numberOfVariables')
            valid = 0;
            if ischar(value)
                errmsg = sprintf('Invalid value for OPTIONS parameter %s: must be a positive numeric (not a string).',field);
            else
                errmsg = sprintf('Invalid value for OPTIONS parameter %s: must be a positive numeric and whole number.',field);
            end
        end 
    case {'Variant'}
        if ~isa(value,'char') || ~any(strcmpi(value,{'osito','ssitosum','gsito','ssitomean','codo'})) % added codo 4/3/2014
            valid=0;
            errmsg = sprintf('Invalid value for OPTIONS parameter %s: must be ''osito'',''CODO'', ''ssito'',''ssitomean'' or ,''gsito''.',field);
        end
    case {'Group','NeighbourhoodSize','MaxIteration'}
       if ~(isa(value,'double') && all(value(:) >= 1) && (rem(value,1)==0)) && ...
                ~strcmpi(value,'15*numberOfVariables')
            valid = 0;
            if ischar(value)
                errmsg = sprintf('Invalid value for OPTIONS parameter %s: must be a positive numeric (not a string).',field);
            else
                errmsg = sprintf('Invalid value for OPTIONS parameter %s: must be a positive numeric and whole number.',field);
            end
        end 
        
                   
    otherwise
        error('SITOOPTIMSET:unknownOptionsField','Unknown field name for Options structure.')
end    
%%

