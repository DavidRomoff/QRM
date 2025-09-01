function Example_DisplayTransitions(Mat,Vec,LabelsRows,LabelsCols)
%EXAMPLE_DISPLAYTRANSITIONS Display credit migration information
%
% Syntax:
%
%   Example_DisplayTransitions(Mat,Vec,LabelsRows,LabelsCols)
%
% Description:
%
%   This is a helper function for the default rates forecasts example. Given a
%   matrix of transition probabilities or transition counts between
%   ratings, it displays the information as a table with row and column
%   labels. If an optional vector of initial counts is passed as input,
%   this is displayed in the first column of the table.
%
% Input Arguments:
%
%          Mat - Either a transition matrix, or a matrix of transition
%                counts between ratings (size nRatings1 x nRatings2)
%          Vec - Either an empty array or a vector of initial counts per
%                rating (size nRatings1 x 1)
%   LabelsRows - Cell array, ratings labels for rows (size nRatings1 x 1)
%   LabelsCols - Cell array, ratings labels for columns (size nRatings2 x 1)
%

% Copyright 2011 The MathWorks, Inc.

[m,n] = size(Mat);
bVec = ~isempty(Vec);

fprintf('%6s ','');
if bVec
   fprintf('%6s ','Init');
end
for j=1:n
   fprintf('%6s ',LabelsCols{j});
end
fprintf('\n');

for i=1:m
   fprintf('%6s ',LabelsRows{i});
   if bVec
      fprintf('%6s ',num2str(round(100*Vec(i))/100));
   end
   for j=1:n
      fprintf('%6s ',num2str(round(100*Mat(i,j))/100));
   end
   fprintf('\n');
end
