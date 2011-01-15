function imstiled (imagein,handlefig,cmap,titleon,sizevec)
% imstiled (imagein,handlefig,cmap,titleon,sizevec)

d3 = size(imagein,3);


if nargin<2 handlefig=0; end
if nargin<3 cmap=[]; end
if nargin<4
    titleshow = 0;
else
    if length(titleon) == 1
        titleshow = titleon;
        titlename = num2cell(1:d3); % default title - number of figure
    else %specified ttile as a vector...
        titleshow = 1;
        titlename = num2cell(titleon); 
    end
end


if nargin<5 % automatic
    a = round(sqrt(d3));
    b = ceil(d3/a);
else % defined
    a = sizevec(1);
    b = sizevec(2);
end

if handlefig; figure(handlefig); end

for ii=1:d3
    subplot(a,b,ii)
    ims(imagein(:,:,ii),cmap,0,1);
    if titleshow
%         title(num2str(titlename{ii}));
        xlabel(num2str(titlename{ii}));
    end
end