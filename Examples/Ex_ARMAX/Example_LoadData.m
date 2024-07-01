%EXAMPLE_LOADDATA Load corporate macro and credit migration data
%
% Syntax:
%
%   Example_LoadData
%
% Description:
%
%   This script loads corporate macro variables and credit migrations data
%   for the default rates forecasts example. The following variables are
%   preprocessed in this script and subsequently used in the example:
%
%         Years - Years in the sample
%
%        nYears - Number of years in the sample
%
%      TransMat - Transition matrix for each year in the sample
%
%      nIssuers - Number of issuers per rating at the beginning of each
%                 year in the sample
%
%   nNewIssuers - Number of new issuers entering the sample each year, per
%                 rating
%
%           CPF - Corporate profits forecast for each year in the sample
%
%           SPR - Corporate spread at the end of each year in the sample
%
%    Recessions - Logical variable indicating recession years
%

% Copyright 2011 The MathWorks, Inc.

% Corporate macro predictors
load Data_CorpMacro

Years = dates;
nYears = length(Years);
CPF = Data(:,1);
SPR = Data(:,2);
Recession = logical(Data(:,3));

% Transition matrices and number of issuers per rating beginning of year
fid = fopen('Data_Transitions.dat');
nIssuers = zeros(nYears,7);
TransMat = zeros(7,9,nYears);
textscan(fid,'%*[^\n]',4); % General header
for t = 1:nYears
   textscan(fid,'%*[^\n]',2); % Year header
   data = textscan(fid,'%*s %d %f %f %f %f %f %f %f %f %f',7);
   nIssuers(t,:) = data{1,1}';
   for j = 1:9
      TransMat(:,j,t) = data{1,j+1};
   end
end
fclose(fid);

% Number of new issuers per rating
fid = fopen('Data_NewIssuers.dat');
textscan(fid,'%*[^\n]',6);
data = textscan(fid,'%*d %d %d %d %d %d %d %d %*d %*f %*f',nYears);
nNewIssuers = double(cell2mat(data));
fclose(fid);
