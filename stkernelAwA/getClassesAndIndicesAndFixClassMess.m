here=pwd;

cd ../../data/Dinesh-Jayaraman/
load('AwA_finalFeat.mat');
attributesMatrix=load('predicate-matrix-binary.txt');
cd (here);
load classes

uniqueClassSource=unique(classSource, 'stable');
uniqueClassTarget=unique(classTarget, 'stable');

nClasses=length(uniqueClassSource);

y=classes;
testClassesIndices=[25 39 15 6 42 14 18 48 34 24];
trainClassesIndices=setdiff(1:50, testClassesIndices);

newTestClassesIndices=[];
newY=[];
newAttributesMatrix=[];
for i=1:nClasses
    targetClass=uniqueClassTarget(i);
    newAttributesMatrix=[newAttributesMatrix; attributesMatrix(targetClass,:)];
%     if find(targetClass==testClassesIndices)
%         newTestClassesIndices=[newTestClassesIndices, i];
%     end
    indices=find(classSource==targetClass);
    newY=[newY; ones(length(indices),1)*i];
end
% testClassesIndices=newTestClassesIndices;
y=newY;
attributesMatrix=newAttributesMatrix;

trainInstancesIndices=[];
trainInstancesLabels=[];
for i=1:length(trainClassesIndices)
    class=trainClassesIndices(i);
    indices=find(y==class)';
    trainInstancesIndices=[trainInstancesIndices, indices];
    trainInstancesLabels=[trainInstancesLabels, ones(1,length(indices))*i];
end

testInstancesIndices=[];
testInstancesLabels=[];
for i=1:length(testClassesIndices)
    class=testClassesIndices(i);
    indices=find (y==class)';
    testInstancesIndices=[testInstancesIndices, indices];
    testInstancesLabels=[testInstancesLabels, ones(1,length(indices))*i];
end

attrClasses=attributesMatrix;

% testClassesIndices=1:length(testClassesIndices);
% trainClassesIndices=1:length(trainClassesIndices);
