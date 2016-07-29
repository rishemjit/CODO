% for CODO PopulationType is doublevector

% options= sitooptimset('variant','CODO','PopulationType','doubleVector','Diversityfactor',1,'MaxIteration',300);
% [x,fVal]  = Sito(@RastriFun, 2, options);

% for other variants PopulationType is bitString
options= sitooptimset('variant','Osito','Diversityfactor',0.9,'MaxIteration',30);
[x,fVal]  = Sito(@OneMax, 4, options);

