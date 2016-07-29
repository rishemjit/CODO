function [options] = generatepop(options,nvars,n)
if n == 3 % if the supplied dimension is 3
    % take the dimensions of user supplied population and fill the default population with this
    userpopulation = options.InitialPopulation ;
    [r,c,p] = size(userpopulation);
    options = createfcn(options,nvars);
    options.InitialPopulation(1:r,1:c,1:p) = userpopulation ;
   
elseif n == 2 % if the supplied dimension is 2
    % take the dimensions of user supplied population and fill the default
    % population with this
     userpopulation = options.InitialPopulation ;
     [r,c] = size(userpopulation);
     population = rand((options.SocietySize)^.2,nvars);
     population(1:r,1:c)= userpopulation ;
    
    % reshape it to 3-D Matrix
    options.InitialPopulation = [];
    options.InitialPopulation = reshape( population,options.SocietySize,options.SocietySize,nvars);

end
end