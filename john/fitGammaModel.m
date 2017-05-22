function params = fitGammaModel(Afull,Bfull)
    modelFit = fit(1:100,Bfull(1,1,1:100),@(a,b,c,d,e,x) gammaModel(Afull(1,1,1:100),a,b,c,d,e));
end