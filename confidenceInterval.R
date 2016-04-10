
setwd("~/Documents/StatisticalLearning/")

graphics.off()

rm(list = ls())

N = 1e5

trueMean = 5

noise = rnorm(N)

population = trueMean + noise
populationMean = mean(population)
populationStd = sd(population)

n = 100

scale = 1.959964

runs = 1e4

confInterval = matrix(0, runs, 2)

count = 0

outIdx = numeric(0)

for(kk in 1:runs) {
  
  sampled = sample(population, n)
  sampleMean = mean(sampled)
  sampleStd = sd(sampled)
  
  marginError = scale * sampleStd/sqrt(n);
  
  confInterval[kk, ] = c(sampleMean-marginError, sampleMean+marginError)
  
  if (confInterval[kk,1] < populationMean && confInterval[kk,2] > populationMean) {
    count = count + 1;
  } else {
    outIdx = c(outIdx, kk)
  }
  
}

probability = count/runs*100

cat("The probability that the sample mean falls between an error margin is: ", probability)

confInterval <- data.frame(confInterval)

colnames(confInterval) = c("lower", "upper")

confInterval$idx = 1:runs

confInterval = confInterval[, c("idx", "lower", "upper")]

confInterval$trueMean = trueMean

require(ggplot2)
p2 = ggplot(confInterval, aes(x = idx, y = trueMean)) +
  geom_point(size = 1) +
  geom_errorbar(aes(ymax = upper, ymin = lower)) +
  xlab("Experiment") + ylab("Confidence Interval") + 
  xlim(0, 100) + ylim(trueMean - 0.5, trueMean + 0.5)
