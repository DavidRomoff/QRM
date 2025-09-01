%EXAMPLE_RECESSIONBANDS Add recession bands to an existing plot
%
% Syntax:
%
%   Example_RecessionBands
%
% Description:
%
%   This script is used to enhance visualizations in the default rates
%   forecasts example. It adds shaded bands to an existing plot indicating
%   recession years. 
%

% Copyright 2011 The MathWorks, Inc.

for t=1:nYears
   if Recession(t)
      fill([Years(t)-0.5 Years(t)-0.5 Years(t)+0.5 Years(t)+0.5],...
         [get(gca,'YLim') fliplr(get(gca,'YLim'))],'b',...
         'FaceAlpha',0.1,'EdgeColor','none');
   end
end
