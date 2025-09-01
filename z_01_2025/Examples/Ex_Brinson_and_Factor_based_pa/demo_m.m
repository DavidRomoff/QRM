%% Portfolio Performance Attribution Analysis
% In this example, we show how simple and powerful it is to use Matlab (especailly 
% table operation) to perform Performance Attribution analysis.
%% Single Period Brinson Model
% _Brinson model: value added return_ can be segmented into the impact of assigning 
% the asset weight of the portfolio to various economic sectors and the impact 
% of selecting securities within those sectors.
% 
% $$R_{\textrm{ValueAdded}} =\sum_{i=1}^{N_s } R_{\textrm{Pi}} W_{\textrm{Pi}} 
% -\sum_{i=1}^{N_s } R_{\textrm{Bi}} W_{\textrm{Bi}}$$
% 
% $=\sum_{i=1}^{N_s } R_{\textrm{Bi}} \left(W_{\textrm{Pi}} -W_{\textrm{Bi}} 
% \right)$          Pure sector allocation, portfolio managers' responsibility
% 
% $+\;\;\sum_{i=1}^{N_s } \left(R_{\textrm{Pi}} -R_{\textrm{Bi}} \right)$$W_{\textrm{Bi}}$                 
% Within-sector selection, security analysts' responsibility
% 
% $+\;\;\sum_{i=1}^{N_s } \left(R_{\textrm{Pi}} -R_{\textrm{Bi}} \right)\left(W_{\textrm{Pi}} 
% -W_{\textrm{Bi}} \right)$          Allocation/selection interaction, joint effect
% 
% where 
% 
% $N_s$ is the total number of sectors
% 
% $R_{\textrm{Pi}}$ is the return of sector i in the portfolio
% 
% $W_{\textrm{Pi}}$ is the allocated weight for sector i in the portfolio
% 
% $R_{\textrm{Bi}}$ is the return of sector i in the benchmark 
% 
% $W_{\textrm{Bi}}$ is the allocated weight for sector i in the benchmark
% 
% $R_B$ is the overall benchmark return.  
% 
% 
% 
% $R_{\textrm{Pi}}$ ,$W_{\textrm{Pi}}$, $R_{\textrm{Bi}}$, $W_{\textrm{Bi}}$  
% are computed by aggregating all asset weights and returns in the given portfolio 
% and benchmark as follows:
% 
% $W_{\mathrm{Pi}} =\sum_j w_{\mathrm{pj}}$,$\;\;R_{\textrm{Pi}} =\frac{\sum_j 
% r_{\textrm{Pj}} w_{\textrm{Pj}} }{\sum_j w_{\textrm{pj}} }$,  $W_{\textrm{Bi}} 
% =\sum_j w_{\textrm{Bj}}$,$\;\;R_{\textrm{Bi}} =\frac{\sum_j r_{\textrm{Bj}} 
% w_{\textrm{Bj}} }{\sum_j w_{\textrm{Bj}} }$
% 
% where 
% 
% $r_{\textrm{Pj}}$, $w_{\textrm{Pj}}$  are the return and weight of asset 
% j that belongs to sector i in the portfolio 
% 
% $r_{\textrm{Bj}}$, $w_{\mathrm{Bj}}$  are the return and weight of asset 
% j that belongs to sector i in the benchmark.
% 
% 
%% Factor-based Performance Attribution
% Factor models decompose _asset returns_ into a systematic component that is 
% explained by factors and a residual component that is not. One big advantage 
% of this approach is that it allows one to define their own attribution model 
% by easily incorporating multiple variables (factors). 
% 
% $r_i =\sum_k X_{\mathrm{ik}} f_k +u_i$, 
% 
% where $X_{\textrm{ik}}$ is the exposure of stock i to factor k (or factor 
% loadings), $f_k$ is the return for factor k, $u_i$ is the residual return of 
% the stock. _It is assumed that the stock exposures are known at the start of 
% the evaluation period, and the factor returns are estimated by cross-sectional 
% regression at the end of the evaluation period. _Active return can be attributed 
% by aggregating asset returns to the factor level.
% 
% $$R_{\textrm{ValueAdded}} =\sum_k X_k^A f_k +\sum_i w_i^A u_i \;\;\;,$$
% 
% $$X_k^A =\sum_i w_i^A X_{\textrm{ik}} =\sum_i \left(w_{\mathrm{Pi}} {-w}_{\textrm{Bi}} 
% \right)X_{\textrm{ik}}$$
% 
% Where $w_i^A$ is the active weight of asset i, $X_k^A$ is the active exposure 
% to factor k for all assets in the portfolio.
%% Load data
% The dataset is simulated and used for demonstration purposes in this example.

load('demo_data.mat');
portData(1:7, :)
benchmarkData(1:7, :)
%% Some analysis and visualization
%  Use the above data which is on the asset level, and group them to the sector 
% level, and conduct the performance analysis.

unique(portData.Sector)
format compact
summary(portData)
summary(benchmarkData)
%% 
% Very easy to query from the table, e.g. find me the assets with Sector 
% in 'Engery', or sort by 'AssetRetn':

rows = portData.Sector=='Energy';
portData(rows, :)
sortrows(portData, 'Sector')
%% Brinson attribution analysis
% Let's analyze the performance by sector: need to group assets by sector for 
% both the given portfolio and benchmark, and compute the sector weghts and returns. 
% This can be easily done using _findgroups_ for table operations. 'pa_brinson' 
% function implements the single period brinson model.

 results = pa_brinson(portData, benchmarkData)
%% 
% The last row shows the total portfolio return and benchmark return, also 
% the total effects of sector allocation and stock selection.

results(end, :)
%% 
% We can also plot the active returns resulting from allocation/selection/interaction 
% effects for each sector.

f=figure;
f.Position(3)= 3*f.Position(3);
subplot(1,3,1);
bar(results.Sector, results.PureSectorAllocation); 
title('Pure Sector Allocation');
subplot(1,3,2);
bar(results.Sector, results.WithinSectorSelection);
title('Within Sector Selection');
subplot(1,3,3);
bar(results.Sector, results.AllocSelecInteraction); 
title('Allocation Selection Interaction');
%% 
%% Factor-based Analysis
% We can acutally think of the Brinson sector-based attribution analysis as 
% a special case of factor-based analysis. This is done by considering the different 
% sectors as different factors driving the active portfolio returns. Our assumption 
% is that the factor loadings $X_{\textrm{ik}}$ are known at the beginning; here 
% in our case $X_{\textrm{ik}}$ is 1, if stock i belongs to sector k. So, we need 
% to run regression to get the factor returns.
% 
% To replicate the results from the Brinson model, we note that the factor 
% returns are different between the portfolio and benchmark, due to the difference 
% in the underlying strategies.

% formulate active weight for each asset from the given dataset.
assetTable = outerjoin(portData, benchmarkData, 'MergeKeys',true,'type', 'right', ...
    'LeftKey', 'AssetTicker', 'RightKey', 'AssetTicker', ...
    'LeftVariables', {'AssetTicker', 'AssetWgt'}, 'RightVariables', {'AssetWgt', 'AssetRetn', 'Sector'});
assetTable = fillmissing(assetTable, 'constant', 0, 'DataVariables',{'AssetWgt_portData'});
assetTable.ActiveWgt = assetTable.AssetWgt_portData - assetTable.AssetWgt_benchmarkData;
sectors = unique(assetTable.Sector);
assetTable(1:7,:)
%% 
% _Sector Allocation effect:_ we can use factor-based analysis to compute 
% the allocation effect in the Brinson model. In this case, we would like to use 
% weighted regression to find benchmark factor return and active exposure for 
% each factor.
% 
% 1) Formulate asset exposure to factors, should usually be predefined. We 
% see that the entry in Xik is 1 if asset i belongs to sector k.

Xik_B = (benchmarkData.Sector==sectors');
Xik_B(1:5,:);
%% 
% 2) Run weighted regression to get the benchmark factor return fk: r_i 
% = Xik * f_k. 

warning('off');
mdl = fitlm(Xik_B, benchmarkData.AssetRetn, 'Intercept', false, 'Weights', benchmarkData.AssetWgt)
%% 
% The factor returns are the coefficents from the trained model. We can 
% see that they exactly match the benchmark sector returns obtained from Brinson 
% model.

fk_B = mdl.Coefficients.Estimate(1:end); 
[fk_B*100, results.BenchRetn(1:end-1)]
%% 
% 3) Compute the factor contribution for allocation effects: 
% 
% $$R_{\textrm{Allocation}} =\sum_k X_k^A f_k$$

X_act_exposure = assetTable.ActiveWgt'*(assetTable.Sector==sectors');
R_allc = X_act_exposure*fk_B;
%% 
% We can see that R_allc matches the total 'pure sector allocation effect' 
% from Brinson model, by comparing the values below:

R_allc*100
results.PureSectorAllocation(end)
%% 
% _Within-Sector Selection effect_: We can use factor-based regression analysis 
% to replicate the within-sector selection effects in Brinson model. In this case, 
% both portfolio factor returns and benchmark factor returns are needed.

Xik_P = (portData.Sector==sectors');
mdl_P = fitlm(Xik_P, portData.AssetRetn, 'Intercept', false, 'Weights', portData.AssetWgt);
fk_P = mdl_P.Coefficients.Estimate;
[fk_P*100 results.PortRetn(1:end-1)]
%% 
% We have already found the benchmark factor returns fk_B. It is shown that 
% R_wss matches the within-sector selection effect in the Brinsion model.
% 
% $$R_{\mathrm{Selection}} =\sum_k X_k^B \left(f_k^P -f_k^B \right)$$

R_wss = (benchmarkData.AssetWgt'*Xik_B)*(fk_P - fk_B);
R_wss*100
results.WithinSectorSelection(end)
%% 
% In summary, We have shown how to conduct Brinson and factor-based analysis 
% for performance attribution. We also showed that Brinson model is a special 
% case of factor-based performance analysis, using sectors as the factors. To 
% perform factor-based attribution analysis, we need to have predefined factor 
% loading Xik and asset return ri, so that we can extract the factor return fk. 
% Together with the portfolio and benchmark specifications, we can then find how 
% the portfolio returns are actively driven by the underlying factors.
%% Supporting function:
%%
function resultsPort = pa_brinson(portData, benchmarkData)
overallBenchRetn = benchmarkData.AssetRetn'*benchmarkData.AssetWgt*100; % a scalar

% aggregate Benchmark asset data up to sector level (group)
[G, resultsBench] = findgroups(benchmarkData(:,'Sector'));
resultsBench.SectorRetn = splitapply(@(x, y) x'*y*100/sum(y), benchmarkData.AssetRetn, benchmarkData.AssetWgt, G);
resultsBench.SectorWgt = splitapply(@(y) sum(y)*100, benchmarkData.AssetWgt, G);

% aggregate Portfolio asset data up to sector level (group)
[G, resultsPort] = findgroups(portData(:,'Sector'));
resultsPort.SectorRetn = splitapply(@(x, y) x'*y*100/sum(y), portData.AssetRetn, portData.AssetWgt, G);
resultsPort.SectorWgt = splitapply(@(y) sum(y)*100, portData.AssetWgt, G);

% fill in 0 for categories not invested in Portfolio
resultsPort = outerjoin(resultsPort, resultsBench, 'key', 'Sector','MergeKeys',true, ...
    'RightVariables', {}, 'LeftVariables', {'Sector', 'SectorRetn', 'SectorWgt'});
resultsPort.SectorRetn(isnan(resultsPort.SectorRetn)) = 0.0;
resultsPort.SectorWgt(isnan(resultsPort.SectorWgt)) = 0.0;

% compute the three terms in value-added return
resultsPort.PureSectorAllocation = (resultsPort.SectorWgt - resultsBench.SectorWgt).*...
    (resultsBench.SectorRetn - overallBenchRetn)/100;
resultsPort.WithinSectorSelection = (resultsBench.SectorWgt).*...
    (resultsPort.SectorRetn - resultsBench.SectorRetn)/100;
resultsPort.AllocSelecInteraction = (resultsPort.SectorWgt - resultsBench.SectorWgt).*...
    (resultsPort.SectorRetn - resultsBench.SectorRetn)/100;

resultsPort.Properties.VariableNames{'SectorRetn'} = 'PortRetn';
resultsPort.Properties.VariableNames{'SectorWgt'} = 'PortWgt';
resultsBench.Properties.VariableNames{'SectorRetn'} = 'BenchRetn';
resultsBench.Properties.VariableNames{'SectorWgt'} = 'BenchWgt';

resultsPort = [resultsPort(:, 1:2), resultsBench(:, 2), resultsPort(:, 3), resultsBench(:, 3), ...
    resultsPort(:, end-2: end)];

% adding the conclusion row: total portfolio
resultsPort.TotalValueAdded = resultsPort.PureSectorAllocation + resultsPort.WithinSectorSelection + ...
    resultsPort.AllocSelecInteraction;
totalPortRetn = resultsPort.PortRetn'*resultsPort.PortWgt/100;
totalBenchRetn = resultsPort.BenchRetn'*resultsPort.BenchWgt/100;
total = array2table([totalPortRetn, totalBenchRetn, sum(resultsPort{:,4:end})], ...
    'VariableNames', resultsPort.Properties.VariableNames(2:end));
totalPort = [table({'Summary'}, 'VariableNames', resultsPort.Properties.VariableNames(1)), total];
resultsPort = [resultsPort; totalPort];

end
%% 
% 
% 
% References:
% 
% * <https://cran.r-project.org/web/packages/pa/vignettes/pa.pdf https://cran.r-project.org/web/packages/pa/vignettes/pa.pdf>
% * <http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.170.7676&rep=rep1&type=pdf 
% http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.170.7676&rep=rep1&type=pdf>
% 
%