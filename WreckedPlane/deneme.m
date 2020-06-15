X = num2cell(randi(20, 1, 316));  %demo data. Why is it in a cell array?
Y = num2cell(randi(10, 1, 316));  %demo data. Why is it in a cell array?
NoOfBins = 20; %or whatever you want
X = cell2mat(X); Y = cell2mat(Y);  %There is no point having X and Y in cell array. Convert to matrix for easier use
[gridprob, xedges, yedges] = histcounts2(X, Y, NoOfBins, 'Normalization', 'probability');
surf(mean(xedges([1:end-1;2:end])), mean(yedges([1:end-1;2:end])), gridprob)
%or use
%histogram2(X, Y, NoOfBins, 'Normalization', 'probability')