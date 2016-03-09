
function generalscript(path, lambdas, sigmas, tasks)

addpath(path);

kernelFID=fopen('all.kernel');
A=fread(kernelFID, 'float');
K=reshape(A,[sqrt(length(A)),sqrt(length(A))]);

perclassattributes = dlmread('all-perclass.attributes');
load experimentIndices

A=unique(perclassattributes, 'rows');
if length(dir('attrClasses*'))>0
    load attrClasses
    A=attrClasses;
end
attributesInput=A(trainClassesIndices,:);
attributesOutput=A(testClassesIndices,:);
nAttrs=size(A,2);

nTrainingClasses=length(trainClassesIndices);
nTrainingInstances=length(trainInstancesIndices);


hist=[];
while 1>0


    newOrder=randperm(nTrainingClasses);
    miniTrainingClasses=newOrder(1:floor(nTrainingClasses*0.8));
    miniValClasses=newOrder(floor(nTrainingClasses*0.8)+1:end);

    miniAttributesInput=[];
    miniAttributesOutput=[];
    miniTrainInstancesIndices=[];
    miniValInstancesIndices=[];
    miniTrainInstancesLabels=[];
    miniValInstancesLabels=[];
    miniNTrainingClasses=length(miniTrainingClasses);
    for i=1:miniNTrainingClasses
        class=newOrder(i);
        miniAttributesInput=[miniAttributesInput; attributesInput(class,:)];
        indices=trainInstancesIndices(trainInstancesLabels==class);
        miniTrainInstancesIndices=[miniTrainInstancesIndices; indices];
        miniTrainInstancesLabels=[miniTrainInstancesLabels, i*ones(1,length(indices))];
    end
    for i=1:length(miniValClasses)
        class=newOrder(miniNTrainingClasses+i);
        miniAttributesOutput=[miniAttributesOutput; attributesInput(class,:)];
        indices=trainInstancesIndices(trainInstancesLabels==class);
        miniValInstancesIndices=[miniValInstancesIndices; indices];
        miniValInstancesLabels=[miniValInstancesLabels, i*ones(1, length(indices))];
    end

    miniNTrainingInstances=length(miniTrainInstancesIndices);

    Stest=attributesOutput;
    Sval=miniAttributesOutput;

    record=0;
    recordman=[];

    for t=1:length(tasks)
        nNewTasks=tasks(t);

        disp('Getting labels...');

        Y=zeros(miniNTrainingInstances,miniNTrainingClasses+nNewTasks);%-1;%-ones(nTrainingInstances,nTrainingClasses);%/(nTrainingClasses-1);
        for i=1:miniNTrainingInstances
            Y(i,miniTrainInstancesLabels(i))=1;
        end

        disp('Precalculating statistics...');
        KTrain=K(miniTrainInstancesIndices, miniTrainInstancesIndices);
        KK=KTrain'*KTrain;

        S=[miniAttributesInput; rand(nNewTasks, nAttrs)];
        KYS=KTrain*Y*S;

       for s=1:length(sigmas)
            sigma=sigmas(s);

            KYS_invSS=KYS/(S'*S+sigma*eye(size(S,2)));
            disp('Learning...');
            for lambdaIndex=1:length(lambdas)
                lambda=lambdas(lambdaIndex);

%                Alpha=(KK+lambda*KTrain)\KYS_invSS;
                Alpha=(KK+lambda*eye(size(KTrain)))\KYS_invSS;

                disp('Predicting...');
                KTest=K(miniValInstancesIndices,miniTrainInstancesIndices);

                pred=Sval*Alpha'*KTest';
                [scores, classPred]=max(pred',[],2);

                disp('Evaluating...');
                gt=miniValInstancesLabels;
                r=mean(gt==classPred');
                [r record]
                if r>record
                    record=r;
                    recordman=[lambda, sigma, nNewTasks];
                    disp(['Record! ', num2str(record)]);
                end
            end
        end
    end

    lambda=recordman(1);
    sigma=recordman(2);
    nNewTasks=recordman(3);

    Y=zeros(nTrainingInstances,nTrainingClasses+nNewTasks);
    for i=1:nTrainingInstances
        Y(i,trainInstancesLabels(i))=1;
    end

    disp('Precalculating statistics...');
    KTrain=K(trainInstancesIndices, trainInstancesIndices);
    KK=KTrain'*KTrain;

    S=[attributesInput; rand(nNewTasks, nAttrs)];
    KYS=KTrain*Y*S;
    KYS_invSS=KYS/(S'*S+sigma*eye(size(S,2)));
    disp('Learning...');

     Alpha=(KK+lambda*KTrain)\KYS_invSS;
%    Alpha=(KK+lambda*eye(size(KTrain)))\KYS_invSS;

    disp('Predicting...');
    KTest=K(testInstancesIndices,trainInstancesIndices);

    pred=Stest*Alpha'*KTest';
    [scores, classPred]=max(pred',[],2);

    disp('Evaluating...');
    gt=testInstancesLabels;
    r=mean(gt==classPred')
    keyboard
    hist=[hist, r];
    save('val_hist', 'hist');
end

end
