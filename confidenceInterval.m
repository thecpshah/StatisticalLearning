clear all
clc
close all

N = 10e6;

trueMean = 5;

noise = randn(1,N);

population = trueMean + noise;
populationMean = mean(population);
populationStd = std(population);

n = 100;

scale = 1.959964;

confInterval = zeros(100, 2);

count = 0;

runs = 1e2;

outIdx = [];

for kk = 1:runs
    
    idx = randi([1 N], 1, n);
    
    sample = population(idx);
    sampleMean = mean(sample);
    sampleStd = std(sample);
    
    marginError = scale * sampleStd/sqrt(n);
    
    confInterval(kk, :) = [sampleMean-marginError sampleMean+marginError];
    
    if (confInterval(kk,1) < populationMean && confInterval(kk,2) > populationMean)
        count = count + 1;
    else
        outIdx = [outIdx kk];
    end
    
end

probability = count/runs*100;

sprintf('The probability that the sample mean falls between an error margin is %0.2f%%', probability)

% Plot
cIndex = 1:runs;
tempIdx = ismember(cIndex, outIdx);

figure
plot(cIndex, ones(1,length(cIndex))*trueMean, 'k-', 'markersize', 5)                % plot the mean
hold on;
plot(cIndex(~tempIdx), confInterval(~tempIdx, 1), '^', 'markersize', 10)            % plot lower CI boundary
plot(cIndex(~tempIdx), confInterval(~tempIdx, 2), 'v', 'markersize', 10)            % plot upper CI boundary
hold on;
plot(cIndex(tempIdx), confInterval(tempIdx, 1), '^', 'markersize', 10)              % plot lower CI boundary
plot(cIndex(tempIdx), confInterval(tempIdx, 2), 'v', 'markersize', 10)              % plot upper CI boundary
hold on;

for I = cIndex                                        % connect upper and lower bound with a line
line([I I],[confInterval(I, 1) confInterval(I, 2)])
hold on;
end;

grid
axis([0 60 trueMean-1 trueMean+1])
xlabel('Experiments')
ylabel('Confidence Interval Pair')
set(gca, 'XTick', outIdx)

