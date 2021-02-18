function migrationPrices = migrationScenarios(valuationDate, zeroRates, bonds)

% copyright 2021 MathWorks, Inc

if ~isdatetime(valuationDate)
    valDate = datetime(valuationDate, 'ConvertFrom', 'Excel');
else
    valDate = valuationDate;
end

% assumes zero rates are yearly starting from the valuation date
zeroDates = valDate + calyears(0:size(zeroRates,1)-1)';

% convert bonds to a table
if ~istable(bonds)
    bonds = cell2table(bonds);
end

% add default column and initialize bondPrices
% this assumes we get back a fraction of the initial bond price as definied 
% by the loss given default times the initial bond price 
migrationPrices = 100*ones(size(bonds,1), size(zeroRates,2)+1); 

% generate prices for each bond for each possible rating 
for rating = 1:size(zeroRates,2)
    migrationPrices(:,rating) = prbyzero([bonds(:,3) bonds(:,4)], valDate, zeroRates(:,rating), zeroDates);
end

