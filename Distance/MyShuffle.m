function [Shuffledtrails,ShuffledCorrMat] = MyShuffle(trails)
    %Input Trial N*M, where N will be regared as the neuron number, M will
    %be regared as sample number.
    Shuffledtrails = Shuffle(trails');
    ShuffledCorrMat = cov(Shuffledtrails)./(std(Shuffledtrails)'*std(Shuffledtrails));
    Shuffledtrails = Shuffledtrails';
end