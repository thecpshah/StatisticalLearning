
setwd("~/Documents/StatisticalLearning/")

graphics.off()

rm(list = ls())

# Population size
N = 1e5

# True mean
trueMean = 5

# Gaussian noise, with zero mean, unit variance
noise = rnorm(N)

# Population
population = trueMean + noise

# Population mean
populationMean = mean(population)

# Population standard deviation
populationStd = sd(population)

# Sample size
n = 100

# Scale factor for 95% confidence interval
scale = 1.959964

# Number of experiments
runs = 1e4

confInterval = matrix(0, runs, 2)

count = 0

outIdx = numeric(0)

for(kk in 1:runs) {
  
  # Obtain random sample from Population
  sampled = sample(population, n)
  
  # Sample mean
  sampleMean = mean(sampled)
  
  #Sample standard deviation
  sampleStd = sd(sampled)
  
  # Margin of error
  marginError = scale * sampleStd/sqrt(n);
  
  # Confidence interval
  confInterval[kk, ] = c(sampleMean-marginError, sampleMean+marginError)
  
  # Check if the CI contain trueMean
  if (confInterval[kk,1] < trueMean && confInterval[kk,2] > trueMean) {
    count = count + 1;
  } else {
    outIdx = c(outIdx, kk)
  }
  
}

# Final probability
probability = count/runs*100

cat("The probability that the sample mean falls between an error margin is: ", probability)

confInterval <- data.frame(confInterval)

colnames(confInterval) = c("lower", "upper")

confInterval$idx = 1:runs

confInterval = confInterval[, c("idx", "lower", "upper")]

confInterval$trueMean = trueMean

require(ggplot2)
p = ggplot(confInterval, aes(x = idx, y = trueMean)) +
  geom_point(size = 1) +
  geom_errorbar(aes(ymax = upper, ymin = lower)) +
  xlab("Experiment") + ylab("Confidence Interval") + 
  scale_x_continuous(limits = c(0, 99), breaks = outIdx)
