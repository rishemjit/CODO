function options = createfcn (options,nvars)
for r = 1 : options.SocietySize
    for c = 1: options.SocietySize
        noOnes =  round( nvars* rand);
        onesIndices = 1+ round((nvars -1)* rand(noOnes,1));
        population(r,c,onesIndices) = 1;
    end

end

 options.InitialPopulation = population;
end