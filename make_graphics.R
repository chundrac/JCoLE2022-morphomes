require(rstan)
require(bayesplot)
require(tikzDevice)
require(gridExtra)

files <- dir('output')
files <- files[endsWith(files,'.Rdata')]
fit.full <- list()

for (fn in files) {
  load(paste('output/',fn,sep=''))
  load(fn)
  fit.full <- append(fit.full,stanfit)
}

fit.full <- sflist2stanfit(fit.full)

x <- as.matrix(fit.full,pars=c('beta_s_lemma','beta_s_pattern','beta_p_lemma','beta_p_pattern'))

x <- cbind(x[,1:3],x[,2]+x[,3],x[,4:6],x[,5]+x[,6])

colnames(x) <- c("$\\beta^{s,lemma}$",
                 "$\\beta^{s,pattern}_{L-N}$",
                 "$\\beta^{s,pattern}_{P-L}$",
                 "$\\beta^{s,pattern}_{P-N}$",
                 "$\\beta^{\\pi,lemma}$",
                 "$\\beta^{\\pi,pattern}_{L-N}$",
                 "$\\beta^{\\pi,pattern}_{P-L}$",
                 "$\\beta^{\\pi,pattern}_{P-N}$"
                 )

x <- x[,c(1,2,4,5,6,8)]

#apply(x,2,function(x){length(which(x>0))/length(x)})

plot1 <- mcmc_intervals(x[,1:3],prob=.85,prob_outer=.95)+xlim(-1.5,3.5)+
  annotate('text',x=3.2,y=c(1:3),label=rev(c('60\\% $>$ 0','95\\% $>$ 0','73\\% $>$ 0')),size=3,family='serif')

plot2 <- mcmc_intervals(x[,4:6],prob=.85,prob_outer=.95)+xlim(-1,2.1)+
  annotate('text',x=1.8,y=c(1:3),label=rev(c('100\\% $>$ 0','99\\% $<$ 0','100\\% $<$ 0')),size=3,family='serif')

grid.arrange(plot1, plot2, ncol=2)

tikz(file='cred-intervals.tex',width=10*.575,height=2*.575)
grid.arrange(plot1, plot2, ncol=2)
dev.off()




