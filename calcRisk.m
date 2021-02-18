function [portMetrics, figLoss, figCounterparty, figMarginalRisk] = ... 
    calcRisk(VaRLevel, numScenarios, valuationDate, zeroRates, bonds, ...
    migrationPrices, transitionMat, factorExposures, factorCorr, figHandles)

% define random number generator seed for repeatability
rng default

% convert bonds to table to make it easier to manipulate
if ~istable(bonds)
    bonds = cell2table(bonds);
end
bonds.Properties.VariableNames = cellstr(["ID", "Pincipal", "Maturity", "CouponRate", "LGD", "Counterparty","NumberofBonds", "Industry", "Rating"]);
bonds.Counterparty = categorical(bonds.Counterparty); % creates easy filtering

migrationValues = migrationPrices .*  bonds.NumberofBonds;

creditModel = creditMigrationCopula(migrationValues, bonds.Rating, transitionMat, ...
    bonds.LGD, factorExposures, 'FactorCorrelation', factorCorr);

% define confidence interval for our calculated risk metrics (default = 95%)
creditModel.VaRLevel = VaRLevel;

% simulate scenarios 
creditModel = simulate(creditModel, numScenarios);

% generate a report for the portfolio risk (EL, Std, VaR, CVaR) 
riskMeasures = portfolioRisk(creditModel);

% price bonds using prbyzero and holdings to get current portfolio value
if ~isdatetime(valuationDate)
    valDate = datetime(valuationDate, 'ConvertFrom', 'Excel');
else
    valDate = valuationDate;
end
portfolioValue = calcPortfolioValue(bonds, valDate, zeroRates);

% display distribution of losses with risk measures overlayed
losses = portfolioValue - creditModel.PortfolioValues;

% calculate the additional risk each bond adds to the portfolio (EL & CVaR)
marginalRisks = riskContribution(creditModel);

% first determine the unique counterparties in our portfolio
allCounterparties = unique(bonds.Counterparty);
counterpartyRisk = zeros(length(allCounterparties), 2);

% filter and aggregate Expected Loss & CVaR for all counterparties
for i = 1:length(allCounterparties)
    myFilter = bonds.Counterparty == allCounterparties(i);
    counterpartyRisk(i,:) = sum(marginalRisks{myFilter,{'EL','CVaR'}});
end

% create a ranking filter of our marginal risk based on Expected Loss value
[sortedRisks,filter] = sortrows(marginalRisks,'EL','descend');

% display the aggregate risk results
riskSummary = [table(allCounterparties) array2table(counterpartyRisk)];
riskSummary.Properties.VariableNames = {'Counterparty', 'EL', 'CVaR'};

% outputs
EL = riskMeasures{1,1};
Std = riskMeasures{1,2}; 
VaR = riskMeasures{1,3};
CVaR = riskMeasures{1,4};

portMetrics = [EL, VaR, CVaR, Std, portfolioValue];

% figures to deploy
if ~exist('figHandles','var')
    figLoss = figureLoss(losses, riskMeasures);
    savefig('Loss.fig')
    figCounterparty = figureCounterparty(riskSummary.Counterparty, riskSummary.EL);
    savefig('Counterparty.fig')
    figMarginalRisk = figureMarginalRisk(bonds{filter,'NumberofBonds'}, sortedRisks.EL);
    savefig('MarginalRisk.fig')
else
    figLoss = figureLoss(losses, riskMeasures, 900, 350, figHandles(1));
    figCounterparty = figureCounterparty(riskSummary.Counterparty, riskSummary.EL, 900, 350, figHandles(2));
    figMarginalRisk = figureMarginalRisk(bonds{filter,'NumberofBonds'}, sortedRisks.EL, 900, 350, figHandles(3));
end


