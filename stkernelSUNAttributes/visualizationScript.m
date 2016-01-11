here=pwd;
load infoPrediction
nClasses=max(gt);
nInstancesPerClass=20;
newSize=[70,70];
testClasses={'archive', 'art school', 'chemical plant', 'flea market', 'inn','lab classroom', 'lake', 'mineshaft', 'outhouse', 'shoe shop'};


imMatrix=uint8(255+zeros(([newSize*nClasses,3])));

cd('~/Dropbox/Data/SUNAttributes');
listDirs=dir();

for i=1:nClasses
    cd (listDirs(i+2).name);
    classPredAux=classPred((i-1)*nInstancesPerClass+1:i*nInstancesPerClass);
    listImages=dir('*.jpg');
    for j=1:nClasses
        index=find(classPredAux==j);
        if isempty(index)
            continue
        end
        index=index(floor(rand*length(index))+1);
        im=imread(listImages(index).name);
        im=imresize(im, newSize);
        imMatrix(newSize(1)*(i-1)+1:newSize(1)*i,newSize(2)*(j-1)+1:newSize(2)*j,:)=im;
    end
    cd ..
end
        
cd(here);
imshow(imMatrix);
for i=1:10
    annotation('textbox',...
    [0.01 i/11.5+0.065 0.1 0.01],...
    'String', testClasses{11-i}, ...
    'LineStyle','none');
end
for i=1:10
    xlim=get(gca,'XLim');
    ylim=get(gca,'YLim');
    
    name=testClasses{i};
    if length(name)>7
        name=name(1:7);
    end
    ht = text(i/10*xlim(2)-40,0.1*ylim(1)+1.11*ylim(2),name);
    set(ht,'Rotation',90)
end
