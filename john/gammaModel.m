function y = gammaModel(t,x,alpha,beta,A,B,C)
    assert(isvector(x),'y must be a vector'); % TODO : relax
    
    n = numel(t);
    x = interp1(1:100,x,t);
    
    gamma = t(:).^(alpha-1).*exp(-beta*t);
    gamma = gamma/sum(gamma);
    
    y = max(0,conv2(x,A*gamma)-B)+C;
    
    y = y(1:n); % TODO : causality?
%     deviation=deviation+sqrt(sum((squeeze(Afull(i,j,:))-preds).^2));
end