%% % for CODO PopulationType is doublevector

options= sitooptimset('variant','CODO','PopulationType','doubleVector','Diversityfactor',1,'MaxIteration',300);
[x,fVal]  = Sito(@RastriFun, 2, options);



%% Example 2 Hamming string by setting options
%  options  = SitoOptimset('Variant','Osito','PopulationType', 'bitstring',...
%    'SocietySize', 7,'NeighbourhoodSize', 3,'DiversityFactor',1.3,'Display','on',...
%      'MaxIteration',10);
%  [x,fval]  = Sito(@Hamming, 32, options);
%%
% %% Example 3 Hamming string without setting options
%  [x,fval] = Sito(@Hamming, 32);
%% 
% Example 4 If variant set in options structure is Gsito than Group field can be set in options structure
% options  = SitoOptimset('Variant','Gsito','Group',48,'PopulationType', 'bitstring',...
%     'SocietySize', 7,'NeighbourhoodSize', 3,'DiversityFactor',0.9,'Display','on',...
%     'MaxIteration',100);
%  [x,fval] = Sito(@Hamming, 32,options);
%% 
% %% Example 5 using rastrigin function, a continous real valued fitness function
% % options  = SitoOptimset('Variant','Osito','MaxIteration',200); 
%  [x,fval] = Sito(@rastriginfn,34,options);


%% 
