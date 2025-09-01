function Example_StressTestPlot(gridx,gridy,data,obsx,obsy,xStr,yStr,titleStr,showEndPoint)
%EXAMPLE_STRESSTESTPLOT Display contours for a risk measure
%
% Syntax:
%
%   Example_StressTestPlot(gridx,gridy,data,obsx,obsy,xStr,yStr,titleStr)
%   Example_StressTestPlot(gridx,gridy,data,obsx,obsy,xStr,yStr,titleStr,showEndPoint)
%
% Description:
%
%   This is a helper function for the default rates forecasts example to
%   visualize the contours of a risk measure that is defined as a function
%   of two risk factors. It also displays historical or simulated
%   observations of the risk factors as scattered points in the same figure.
%
% Input Arguments:
%
%      gridx - Grid points for the first risk factor (size 1 x n1)
%
%      gridy - Grid points for the second risk factor (size 1 x n2)
%
%       data - Value of risk measure at each point of grid (size n1 x n2)
%
%       obsx - Historical or simulated data for first risk factor (size nObs x 1)
%
%       obsy - Historical or simulated data for second risk factor (size nObs x 1)
%
%       xStr - String, label for first risk factor
%
%       yStr - String, label for second risk factor
%
%   titleStr - String, plot title
%
% showEndPoint - Boolean, flag to highlight the last (obsx,obsy) pair in red
%

% Copyright 2011 The MathWorks, Inc.

if (nargin<9)
  showEndPoint = true;
end

figure

% Determine contour levels
lmin = floor(min(data(:)));
lmax = ceil(max(data(:)));
level_step=0.25;
while ((lmax-lmin)/level_step>15)
  level_step=level_step*2;
end
v = lmin:level_step:lmax;

% Plot countours, filled, and change colormap
[C,h]=contourf(gridx',gridy,data',v);
colormap cool

% Label every other contour level
set(h,'ShowText','on','TextList',v(1:2:length(v)))

% Show fewer, larger labels
clabel(C,h,'LabelSpacing',200)
clabel(C,h,'FontSize',11)

% Axes labels and title
xlabel(xStr)
ylabel(yStr)
title(titleStr)

% Plot observed data
hold on
plot(obsx,obsy,'o','MarkerSize',10,'MarkerFaceColor','g')
if showEndPoint
  scatter(obsx(end),obsy(end),'LineWidth',1.2,'MarkerFaceColor','r')
end
hold off
