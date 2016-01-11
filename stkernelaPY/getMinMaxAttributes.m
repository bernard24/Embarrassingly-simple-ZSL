here=pwd;
cd /home/bernard/Data/ABC/apascal
attrs=dlmread('all-perimage.attributes');
classes=dlmread('all.classid');
cd (here);
classes=classes+1;

nClasses=length(unique(classes));
[nInstances, nAttrs]=size(attrs);

classesAttrs=zeros(nClasses*3,nAttrs);
classesCells=cell(1,nClasses);

for i=1:nInstances
    class=classes(i);
    signature=attrs(i,:);
    classesCells{class}=[classesCells{class}; signature];
end
counter=1;
for class=1:nClasses
    classesAttrs(counter,:)=mean(classesCells{class});
    classesAttrs(counter+1,:)=mean(classesCells{class})+0.5*std(classesCells{class});
    classesAttrs(counter+2,:)=mean(classesCells{class})-0.5*std(classesCells{class});
    counter=counter+3;
end
