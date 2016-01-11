here=pwd;
cd /home/bernard/Data/ABC/apascal
attrs=dlmread('all-perimage.attributes');
classes=dlmread('all.classid');
cd (here);

nClasses=length(unique(classes));
nAttrs=size(attrs, 2);
V=zeros(nClasses,nAttrs);
B=zeros(nClasses,nAttrs);
for i=1:nClasses
    classi=classes(i);
    indices=find(classes==classi);
%     keyboard
    B(i,:)=mean(attrs(indices,:));
    V(i,:)=std(attrs(indices,:));
end
ra=std(B)./mean(V)
ra=ra(~isnan(ra));
mean(ra)