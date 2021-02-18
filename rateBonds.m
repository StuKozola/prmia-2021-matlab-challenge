function ratings = rateBonds(newBonds)

% pretrained boosted decision tree
load('ratingModel.mat')

% convert input into a table with column metadata
if ~istable(newBonds)
    bondTable = array2table(newBonds);
    bondTable.Properties.VariableNames = {'ID','WC_TA','RE_TA','EBIT_TA','MVE_BVTD','S_TA','Industry'};
else
    bondTable = newBonds;
end

% determine the ratings of the bonds in our portfolio
ratings = cellstr(ratingEngine.predictFcn(bondTable));

% pragma to include a specific function for deployment
%#function fitcensemble