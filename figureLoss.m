function imageData = figureLoss(losses, riskMeasures, imageWidth, imageHeight, fax)

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
histogram(fax,losses,100)
hold(fax,'on')
currentFig = fax;
height = currentFig.YAxis.Limits(2);
plot(fax,[riskMeasures.EL riskMeasures.EL],[0 height],'LineWidth',2);
plot(fax,[riskMeasures.VaR riskMeasures.VaR],[0 height],'LineWidth',2);
plot(fax,[riskMeasures.CVaR riskMeasures.CVaR],[0 height],'LineWidth',2);
plot(fax,[riskMeasures.Std riskMeasures.Std],[0 height],'LineWidth',2);

legend(fax,{'Losses', 'Expected Loss', 'Value at Risk', 'CVaR', 'Standard Deviation'})
xlabel(fax,'Losses ($)')
ylabel(fax,'Frequency')
currentFig.XAxis.FontSize = 14;
currentFig.YAxis.FontSize = 14;
currentFig.Legend.FontSize = 12;
currentFig.YAxis.Limits(2) = height; %enforce original y axis size
hold(fax,'off')

% deploying figures to Excel
imageData = fax;


