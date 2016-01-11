here=pwd;
cd /home/bernard/Data/ABC/apascal
attrClasses=dlmread('all-perclass.attributes');
indices=dlmread('split0.mask');
classes=dlmread('all.classid');
cd (here);

classes=classes+1;

trainInstancesIndices=find(indices==1);
trainInstancesLabels=classes(indices==1);
trainClassesIndices=unique(trainInstancesLabels,'stable');

% keyboard

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

newAttrClasses=[];
for i=1:length(unique(classes))
    newAttrClasses=[newAttrClasses; attrClasses(find(classes==i,1),:)];
end
attrClasses=newAttrClasses; %unique(attrClasses, 'rows', 'stable');
