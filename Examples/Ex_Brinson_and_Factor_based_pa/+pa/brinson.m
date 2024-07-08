function resultsPort = brinson(portData, benchmarkData)

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

if nargout == 0
    f=figure;
    f.Position(3)= 3*f.Position(3);
    subplot(1,3,1);
    bar(resultsPort.Sector, resultsPort.PureSectorAllocation); 
    title('Pure Sector Allocation');
    subplot(1,3,2);
    bar(resultsPort.Sector, resultsPort.WithinSectorSelection);
    title('Within Sector Selection');
    subplot(1,3,3);
    bar(resultsPort.Sector, resultsPort.AllocSelecInteraction); 
    title('Allocation Selection Interaction');    
end