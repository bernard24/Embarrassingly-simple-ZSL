
datasetPath='/home/bernard/HD1/ABC/sun';
addpath('..');
lambdas = 10.^[-3:3];
sigmas=10.^[-3:3];
tasks=[0];

validationClasses_generalscript(datasetPath, lambdas, sigmas, tasks);
