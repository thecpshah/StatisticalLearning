clear all
clc
close all

N = 1e5;                                            % Population size

trueMean = 5;                                       % True mean of the population

noise = randn(1,N);                                 % Gaussian noise, with zero mean, unit variance

population = trueMean + noise;                      % Population data
populationMean = mean(population);                  % Population mean (should be equal to trueMean)
populationStd = std(population);                    % Population standard deviation

n = 100;                                            % Sample size

scale = 1.959964;                                   % Scale factor for 95% confidence interval

runs = 1e4;                                         % Number of experiments

confInterval = zeros(100, 2);                       

count = 0;                                         

outIdx = [];

for kk = 1:runs
    
    idx = randi([1 N], 1, n);                       % Generate random samples
        
    sample = population(idx);                       % Obtain random samples from Population
    sampleMean = mean(sample);                      % sample mean
    sampleStd = std(sample);                        % Sample standard deviation
    
    marginError = scale * sampleStd/sqrt(n);        % Margin of Error
    
    % Confidence Interval
    confInterval(kk, :) = [sampleMean-marginError sampleMean+marginError];
    
    % Check if the CI contains trueMean
    if (confInterval(kk,1) < trueMean && confInterval(kk,2) > trueMean)
        count = count + 1;
    else
        outIdx = [outIdx kk];
    end
    
end

% Final probability
probability = count/runs*100;

sprintf('The probability that the sample mean falls between an error margin is %0.2f%%', probability)

% Plot
cIndex = 1:runs;
tempIdx = ismember(cIndex, outIdx);

figure
plot(cIndex, ones(1,length(cIndex))*trueMean, 'k-', 'markersize', 5)                % plot the mean
hold on;
plot(cIndex(~tempIdx), confInterval(~tempIdx, 1), '^', 'markersize', 5)             % plot lower CI boundary
plot(cIndex(~tempIdx), confInterval(~tempIdx, 2), 'v', 'markersize', 5)             % plot upper CI boundary
hold on;
plot(cIndex(tempIdx), confInterval(tempIdx, 1), '^', 'markersize', 10)              % plot lower CI boundary
plot(cIndex(tempIdx), confInterval(tempIdx, 2), 'v', 'markersize', 10)              % plot upper CI boundary
hold on;

for I = 1:100                                                                       % connect first 100 upper and lower bound with a line
line([I I],[confInterval(I, 1) confInterval(I, 2)])
hold on;
end;

grid
axis([0 100 trueMean-0.5 trueMean+0.5])
xlabel('Experiments')
ylabel('Confidence Interval')
set(gca, 'XTick', outIdx)

