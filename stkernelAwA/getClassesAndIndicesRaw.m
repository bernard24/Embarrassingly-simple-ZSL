here=pwd;
cd /home/bernard/Data/ABC/animals
attrClasses=dlmread('all-perclass.attributes');
indices=dlmread('split0.mask');
classes=dlmread('all.classid');
cd (here);

trainInstancesIndices=find(indices==1);
trainInstancesLabels=classes(indices==1);
trainClassesIndices=unique(trainInstancesLabels,'stable');

auxLabels=zeros(size(trainInstancesLabels));
for i=1:length(unique(trainInstancesLabels))
    c=find(trainInstancesLabels>0, 1);
    class=trainInstancesLabels(c);
    auxLabels(trainInstancesLabels==class)=i;
    trainInstancesLabels(trainInstancesLabels==class)=0;
end
trainInstancesLabels=auxLabels';

testInstancesIndices=find(indices==0);
testInstancesLabels=classes(indices==0);
testClassesIndices=unique(testInstancesLabels,'stable');

auxLabels=zeros(size(testInstancesLabels));
for i=1:length(unique(testInstancesLabels))
    c=find(testInstancesLabels>0, 1);
    class=testInstancesLabels(c);
    auxLabels(testInstancesLabels==class)=i;
    testInstancesLabels(testInstancesLabels==class)=0;
end
testInstancesLabels=auxLabels';

attrClasses=unique(attrClasses, 'rows', 'stable');
uniqueClasses=unique(classes, 'stable');
newAttrClasses=zeros(size(attrClasses));
for i=1:length(uniqueClasses)
    newAttrClasses(uniqueClasses(i),:)=attrClasses(i,:);
end
attrClasses=newAttrClasses;
