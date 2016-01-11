here=pwd;
cd /home/bernard/Data/ABC/apascal
attrs=dlmread('all-perimage.attributes');
classes=dlmread('all.classid');
cd (here);
classes=classes+1;

nClasses=length(unique(classes));
[nInstances, nAttrs]=size(attrs);

classesAttrs=zeros(nClasses,nAttrs);
counters=zeros(1,nClasses);

for i=1:nInstances
    class=classes(i);
    signature=attrs(i,:);
    classesAttrs(class,:)=classesAttrs(class,:)+signature;
    counters(class)=counters(class)+1;
end
for i=1:nClasses
    classesAttrs(i,:)=classesAttrs(i,:)/counters(i);
end
    