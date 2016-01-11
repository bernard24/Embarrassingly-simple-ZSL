
function generalscript(path, lambdas, sigmas, tasks)

addpath(path);

kernelFID=fopen('all.kernel');
A=fread(kernelFID, 'float');
K=reshape(A,[sqrt(length(A)),sqrt(length(A))]);

perclassattributes = dlmread('all-perclass.attributes');
S = dlmread('all-perimage.attributes');
load experimentIndices

A=unique(perclassattributes, 'rows');
if length(dir('attrClasses*'))>0
    load attrClasses
    A=attrClasses;
end
% keyboard
attributesInput=A(trainClassesIndices,:);
attributesOutput=A(testClassesIndices,:);
nAttrs=size(A,2);
% allClass = dlmread('all.classid')+1;

% keyboard

nTrainingClasses=length(trainClassesIndices);
nTrainingInstances=length(trainInstancesIndices);

hist=[];
S=S(trainInstancesIndices,:);
Stest=attributesOutput;
% Stest(Stest==0)=-1;
% for i=1:size(Stest,1)
%     Stest(i,:)=Stest(i,:)-mean(Stest(i,:));
%     Stest(i,:)=Stest(i,:)/norm(Stest(i,:));
% end

for t=1:length(tasks)
    nNewTasks=tasks(t);

    disp('Getting labels...');

%     Y=zeros(nTrainingInstances,nTrainingClasses+nNewTasks);%-1;%-ones(nTrainingInstances,nTrainingClasses);%/(nTrainingClasses-1);
%     for i=1:nTrainingInstances
%         Y(i,trainInstancesLabels(i))=1;
%     end

    disp('Precalculating statistics...');
    KTrain=K(trainInstancesIndices, trainInstancesIndices);
    KK=KTrain'*KTrain;
    
%     S=[attributesInput; rand(nNewTasks, nAttrs)];
%     S=[attributesInput; sign(rand(nNewTasks, nAttrs)-0.5)];
%     S(S==0)=-1;
%     for i=1:size(S,1)
%         S(i,:)=S(i,:)-mean(S(i,:));
%         S(i,:)=S(i,:)/norm(S(i,:));
%     end
    
    KYS=KTrain*S;
    SS=S'*S;

    % keyboard
    for s=1:length(sigmas)
        sigma=sigmas(s);
        KYS_invSS=KYS/(SS+sigma*eye(size(S,2)));


        disp('Learning...');
        % step=10^-8;
        % for t=1:500
        % %     keyboard
        %     W = W - step * (XX*W*SS -XYS + lambda*W);
        % end
        for lambdaIndex=1:length(lambdas)
            lambda=lambdas(lambdaIndex);

            Alpha=(KK+lambda*KTrain)\KYS_invSS;

            disp('Predicting...');
            KTest=K(testInstancesIndices,trainInstancesIndices);

            pred=Stest*Alpha'*KTest';
            [scores, classPred]=max(pred',[],2);

            disp('Evaluating...');
            gt=testInstancesLabels;
            r=mean(gt==classPred')
%             confusionmat(gt, classPred')
            hist=[hist; [lambda, sigma, nNewTasks, r]];
        %     break;
            save('hist4', 'hist');
        end
    end
end
end
