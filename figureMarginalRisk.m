function imageData = figureMarginalRisk(numBonds, EL, imageWidth, imageHeight, fax)

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

scatter(fax,numBonds, EL, 50, EL, 'filled', 'MarkerEdgeColor', [0 0 0])

currentFig = fax;
currentFig.XAxis.FontSize = 14;
currentFig.YAxis.FontSize = 14;
height = currentFig.YAxis.Limits(2);
currentFig.YAxis.Limits(1) = 0; 
currentFig.YAxis.Limits(2) = height; %enforce original y axis size

ylabel(fax,'Marginal Expected Loss ($)')
xlabel(fax,'# Bonds Held')

% deploying figures
imageData = fax;