function [state,options]= SitoCheckInitpop(nvars,options)
% This function checks the initial popumlation entered by the user
% primarily it checks the dimensions and
% other obvious error conditions


initialPopulation  = options.InitialPopulation ;
% if no initial population has been used then just get out nothing to check
if isempty(initialPopulation )
    state = 2;
    return 
end
popSize = (options.SocietySize).^2 ;

%% check if the initial population supplied is of how many dimensions
m = size(initialPopulation);
n = size(m,2); % check how many columns the dimension has
if n  == 3 % if the matrix supplied is 3-D
    % check if the third dimension is same as number of features
    thirdD = size(initialPopulation,3);
    if thirdD > nvars
        msg = sprintf('Warning: initialPopulation size greater than number of features(NVARS)clipping values upto number of features') ;
        disp(msg);
        % clip the population
        options.InitialPopulation = initialPopulation(:,:,nvars);
    elseif thirdD < nvars
        msg = sprintf('Warning: initialPopulation size lesser than number of features(NVARS) generating values upto number of features') ;
        disp(msg);
        % create the population upto societysize
        options = generatepop(options,nvars,n);
    end

end
if n == 2 % if the matrix supplied is 2-D
    % check if the second dimension is same as number of features or
    % 1st dimension is same as societySize^2
    [frstD,secondD] = size(initialPopulation);
    if ((frstD > popSize) || (secondD > nvars) )
        msg = sprintf('Warning: initialPopulation size greater than number of individuals(SOCIETYSIZE)or featueres clipping values upto number of number of individuals and features') ;
        disp(msg);
        % clip the population
        options.InitialPopulation = initialPopulation(popSize,nvars);

    elseif (frstD < popSize) 
        msg = sprintf('Warning: initialPopulation size greater than number of individuals(SOCIETYSIZE)generating values upto number of number of individuals') ;
        disp(msg);
        % create the population upto societysize
        flag  = 1 ;
        
    elseif (secondD < nvars)
        msg = sprintf('Warning: initialPopulation size lesser than number of features(NVARS) generating values upto number of features') ;
        disp(msg);
        % create the population upto societysize
       flag  = 1 ;
        
    end
    if flag  == 1
        options = generatepop(options,nvars,n);

    end
end
%% put state to different values accordingly
state  = 1; 



end