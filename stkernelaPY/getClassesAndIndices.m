here=pwd;
cd ../../data/Dinesh-Jayaraman/
load('Farhadi_PCA105.mat')
cd (here);

y=classes;
testClassesIndices=%[25 39 15 6 42 14 18 48 34 24];
trainClassesIndices=%setdiff(1:50, testClassesIndices);

testIndices=randperm(2644);
trainIndices=[2645:size(features,1)];

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

testClassesIndices=1:length(testClassesIndices);
trainClassesIndices=1:length(trainClassesIndices);
