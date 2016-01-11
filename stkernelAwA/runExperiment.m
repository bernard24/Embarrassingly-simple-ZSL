
datasetPath='/home/bernard/HD1/ABC/animals';
addpath('..');
lambdas=10.^[-3:3];
gammas=10.^[-3:3];
tasks=[0];

validationClasses_generalscript(datasetPath, lambdas, gammas, tasks);
