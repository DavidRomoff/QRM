function Example_BacktestPlot(x,y0,y,xStr,yStr,titleStr,tags,loc)
%EXAMPLE_BACKTESTPLOT Plots backtesting data for three alternative methods
%
% Syntax:
%
%   Example_BacktestPlot(x,y0,y,xStr,yStr,titleStr,tags,loc)
%
% Description:
%
%   This is a helper function for the default rates forecasts example to
%   visualize the performance of three alternative prediction methods in a
%   backtesting exercise.
%
% Input Arguments:
%
%          x - Horizontal axis data, years (size nYears x 1)
%
%         y0 - Either an empty array, or an array containing the benchmark
%              data (size nYears x 1) 
%
%          y - Data for three alternative methods (size nYears x 3)
%
%       xStr - String, label for horizontal axis
%
%       yStr - String, label for vertical axis
%
%   titleStr - String, plot title
%
%       tags - Cell array of strings with legend labels for y0 and y 
%
%        loc - String, legend location
%

% Copyright 2011 The MathWorks, Inc.

figure
if ~isempty(y0)
   plot(x,y0,'ko','LineWidth',1.5,'MarkerSize',10,'MarkerFaceColor','g')
end
hold on
plot(x,y(:,1),'b-s','LineWidth',1.2,'MarkerSize',10)
plot(x,y(:,2),'m:.','LineWidth',1.2)
plot(x,y(:,3),'r-..','LineWidth',1.2)
hold off
xlabel(xStr);
ylabel(yStr);
title(titleStr)
legend(tags,'location',loc);
