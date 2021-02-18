function portValue = calcPortfolioValue(bonds, valuationDate, zeroRates)
% This requires that the bonds have initial ratings in order to price

% copyright 2021 MathWorks, Inc

zeroDates = valuationDate + calyears(0:size(zeroRates,1)-1)';

ratingNames = {'AAA','AA','A','BBB','BB','B','CCC','Default'};

bondPrices = zeros(size(bonds, 1), 1);

for i = 1:size(zeroRates,2)

    % creates a filter to find bonds of a specific rating (e.g. AAA bonds)
    filter = categorical(bonds{:,9}) == ratingNames{i}; 
    
    % extract just the Maturity & Coupon Rate for the bonds of that rating
    bondData = bonds(filter,3:4);
    
    % price the bonds with a zero curve
    bondPrices(filter) = prbyzero([bondData(:,1) bondData(:,2)], valuationDate, zeroRates(:,i), zeroDates);
end

% calculate the total portfolio value by weighting & summing by # of bonds
portValue = bondPrices' * bonds{:,7};
