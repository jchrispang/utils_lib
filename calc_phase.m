function signal_phase = calc_phase(signal)
% calc_phase.m
%
% Calculates the instantaneous node phases
%
% Input: signal         : signal [NxT]
%
% Output: signal_phase  : instantaneous phases [NxT]
%
% Original: James Roberts
% Edited: James Pang, QIMR Berghofer, 2020

%%

if size(signal,2) > size(signal,1)
    flip = 1;
    signal = signal';
end

if length(signal)<200000
    % short but inefficient with memory
    
    % calculate phase
    signal_phase = unwrap(angle(hilbert(bsxfun(@minus,signal,mean(signal)))));
else
    % inelegant but uses less memory
    
    signal_phase = zeros(size(signal));
    nn = size(signal,2);
    for jj=1:nn
        y = signal(:,jj);
        signal_phase(:,jj) = unwrap(angle(hilbert(y-mean(y))));
    end
end

if flip
    signal_phase = signal_phase';
end
