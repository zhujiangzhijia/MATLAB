function [x_mu, y_mu, sig, differ] = fitgauss2d(M,sigfix, showfig)
% [x_mu, y_mu, sig, differ] = fitgauss2d(M,sigfix, showfig)
% Fits isotropic gaussian to the each z-slice of hte matrix M.
% x_mu, y_mu : coordiantes of the fitted mean
% sig : fitted std
% differ : D -devergence between data and figure generated form gaussian
% 31/3/2011

nd=ndims(M);
sm=size(M);
switch nd
    case 2
        nslice =1;
        M(:,:,2)=eps;
        
    case 3
        nslice = size(M,3);
end


    M = max(abs(M),eps); %ensures positive values
    mM = max(max(M));
    indlin = find(bsxfun(@eq,M,mM));
    [xm,ym,z_mu]=ind2sub(sm,indlin);
    M = bsxfun(@rdivide,M,mM);
    if ~exist('sigfix','var')
        sigfix = [];
    end
for sl = 1:nslice    
    Mslice = M(:,:,sl);
    if isempty(sigfix)
        sguess = sum(sum(Mslice))/(sm(1)*sm(2))*sm(1);
        x = fminsearch(@(x) difference(x,Mslice),[ym(sl),xm(sl),sguess]);
        x_mu(sl) = x(1);
        y_mu(sl) = x(2);
        sig(sl) = x(3);
    else
        x = fminsearch(@(x) difference_sigfix(x,Mslice,sigfix),[ym(sl),xm(sl)]);
        x_mu(sl) = x(1);
        y_mu(sl) = x(2);
        sig(sl) = sigfix;
    end
    
    differ = difference(x,Mslice);
end

if exist('showfig','var')
    if showfig == 1
        
        %         ims(gauss2d(size(M), [x_mu y_mu], sig,1));
        ims(M, 'gray');
        hold on
        scatter (x_mu, y_mu, 80 , 'xr');
        [x,y,z] = cylinder(sig,200);
        plot(x(1,:) + x_mu, y(1,:) + y_mu,'r')
    end
end