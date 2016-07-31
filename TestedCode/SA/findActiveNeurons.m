function activeNeurons=findActiveNeurons(rasterAlltrials)
%   mNeurons=mean(rasterAlltrials,2);
%   stdNeurons=std(rasterAlltrials')';
%   thrshold=mNeurons+3*stdNeurons;
%   thrsholdMat=repmat(mNeurons+3*stdNeurons,1,size(rasterAlltrials,2));
  activeNeurons=zeros(size(rasterAlltrials,1),size(rasterAlltrials,2));
  for neuronInd=1:size(rasterAlltrials,1)
    thrsh = mean(rasterAlltrials(neuronInd,:))+2*std(rasterAlltrials(neuronInd,:));
    p = peakfinder(rasterAlltrials(neuronInd,:),0.5,thrsh,1,false,false);   
    activeNeurons(neuronInd,p)=1;
  end

%   
%   activeNeurons=rasterAlltrials-thrsholdMat;
%   activeNeurons(activeNeurons>0)=1;
%   activeNeurons(activeNeurons<=0)=0;
end