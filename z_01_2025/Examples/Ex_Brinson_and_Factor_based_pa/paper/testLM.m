%% compute the allocation effect

% formulate asset exposure to factors
Xsectors = assetTable.Sector;
Xik = Xsectors==sectors';

% regression to get the factor return: r_i = Xik * f_k
ri = assetTable.AssetRetn;
mdl = fitlm(Xik, ri);
fk = mdl.Coefficients.Estimate(2:end);  % first ele is the intercept or residual
% Note that: active sector wgt matches (results.PortWgt-results.BenchWgt)
R_allc = (assetTable.ActiveWgt'*Xik)*fk  


%% computing the selection effect

% regression to get factor return in port and benchmark
ri = portData.AssetRetn;
Xsectors = portData.Sector;
Xik = Xsectors==sectors';
fk_port = Xik\ri;

ri = benchmarkData.AssetRetn;
Xsectors = benchmarkData.Sector;
Xik = Xsectors==sectors';
fk_bench = Xik\ri;

% aggreate benchmark weight for each sector
sectorWgt_bench = (benchmarkData.AssetWgt'*Xik);

% Selection contribution
R_selec = sectorWgt_bench*(fk_port - fk_bench)


%% simple linear regression to get factor return in port and benchmark
ri = portData.AssetRetn;
Xsectors = portData.Sector;
Xik = Xsectors==sectors';
fk_port = [Xik ones(size(portData,1), 1)]\ri;
fk_port = fk_port(2:end);

ri = benchmarkData.AssetRetn;
Xsectors = benchmarkData.Sector;
Xik = Xsectors==sectors';
fk_bench = [Xik ones(size(benchmarkData,1), 1)]\ri;
fk_bench = fk_bench(2:end);

% aggreate benchmark weight for each sector
sectorWgt_bench = (benchmarkData.AssetWgt'*Xik);

% Selection contribution
R_selec = sectorWgt_bench*(fk_port - fk_bench)

%% lm regression to get factor return in port and benchmark
ri = portData.AssetRetn;
Xsectors = portData.Sector;
Xik = Xsectors==sectors';
mdl = fitlm(Xik, ri);
fk_port = mdl.Coefficients.Estimate(2:end);

ri = benchmarkData.AssetRetn;
Xsectors = benchmarkData.Sector;
Xik = Xsectors==sectors';
mdl = fitlm(Xik, ri);
fk_bench = mdl.Coefficients.Estimate(2:end);

% aggreate benchmark weight for each sector
sectorWgt_bench = (benchmarkData.AssetWgt'*Xik);

% Selection contribution
R_selec = sectorWgt_bench*(fk_port - fk_bench)

%% lm regression to get factor return in port and benchmark with defined residual
ri = portData.AssetRetn;
Xsectors = portData.Sector;
Xik = Xsectors==sectors';
mdl = fitlm([Xik ones(size(portData,1), 1)], ri);
fk_port = mdl.Coefficients.Estimate(2:end-1);

ri = benchmarkData.AssetRetn;
Xsectors = benchmarkData.Sector;
Xik = Xsectors==sectors';
mdl = fitlm([Xik ones(size(benchmarkData,1), 1)], ri);
fk_bench = mdl.Coefficients.Estimate(2:end-1);

% aggreate benchmark weight for each sector
sectorWgt_bench = (benchmarkData.AssetWgt'*Xik);

% Selection contribution
R_selec = sectorWgt_bench*(fk_port - fk_bench)