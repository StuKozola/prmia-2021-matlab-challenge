function imageData = figureCounterparty(counterparty, expectedLoss, imageWidth, imageHeight, fax) 

if nargin < 3
    imageWidth = 900;
end
if nargin < 4
    imageHeight = 350;
end

if nargin < 5
    if isdeployed
        f = figure('Visible', 'off'); 
    else
        f = figure;
    end
    figPosition = get(f,'DefaultFigurePosition');
    set(f,'Position',[figPosition(1:2) imageWidth imageHeight],'Name','LossDistribution');
    fax = gca;
end

bar(fax, counterparty, expectedLoss, 'FaceColor', [0.4 0.66667 0.84314]);
currentFig = fax;
currentFig.YAxis.FontSize = 14;

ylabel(fax,'Counterparty Expected Loss ($)')
xlabel(fax,'Counterparty')

% deploying figures
imageData = fax;


