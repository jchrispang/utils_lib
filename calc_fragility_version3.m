function [fragility,wiring_cost_mean,wiring_cost_std,P_mean,S_mean,S_std,W_fracs,hubs] = calc_fragility_version3(W,fiberdist,thrs,nfracs,nhubs,nruns,thrs_hub)
% calc_fragility_version3.m
%
% Calculating the probability of each hub to remain a hub after
% randomizing only a fraction of the edges.
%
% The fragility of hub is defined as the fraction of edges required to
% reduce the probability of a node to remain a hub by less then 0.8%
%
% Dependencies: strength_correct and geombinsurr_partial
%
% Inputs:  W              : weighted connectivity matrix [NxN]
%          fiberdist      : fiber distance matrix [NxN]
%          thrs           : maximun density of the brain to be considered [float]
%                          (the connectivity matrix will be thresholded at this level) 
%          nfracs         : number of points between 0 and 1 
%                           shuffle this fraction of edges [float]
%          nhubs          : number of hubs in the connectivity matrix [float]
%          nruns          : number of rewiring iterations [float]
%          thrs_hub       : threshold for the probability of hub to remain a hub to
%                           compute the fragility  [float]
%
% Outputs: fragility      : fragility of a hub [1 x nhubs]
%          wiring_cost_mean   : mean of weight times distance [N x N x nfracs]
%          wiring_cost_std    : std of weight times distance [N x N x nfracs]
%          P_mean         : mean of probability of each hub to remain a hub [nhubs x nfracs]
%          S_mean         : mean of strength of all nodes across randomizations [N x nfracs]
%          S_std          : std of strength of all nodes across randomizations [N x nfracs]
%          W_fracs        : randomized connectivity matrices for the last trial only [N x N x nfracs]
%          hubs           : list of hub nodes [1 x nhubs]
%
% Original: Leonardo Gollo
% Edited: James Pang, QIMR Berghofer, 2020
% Version 2: James Pang, QIMR Berghofer, 2021

%%

N = size(W, 2);             % number of nodes

% suggested default values
if nargin < 7
    thrs_hub = 0.8;
end
if nargin < 6
    nruns = 1000;   % or 5000, 10000, 100000
end
if nargin < 5
    nhubs = ceil(N*0.15);
end
if nargin < 4
    nfracs = 51;    % or 101, 201
end
if nargin < 3
    thrs = 0.3;
end

% threshold matrix
Wt = threshold_proportional(W,thrs);

% finding hubs in terms of node strength
S = sum(Wt,2); 
[~,I] = sort(S,'descend');
hubs = I(1:nhubs);

fracs = linspace(0, 1, nfracs);

wiring_cost_mean = zeros(N,N,nfracs);
wiring_cost_std = zeros(N,N,nfracs);
S_mean = zeros(N,nfracs);
S_std = zeros(N,nfracs);
hubs_again = zeros(nhubs,nfracs,nruns);
W_fracs = zeros(N,N,nfracs); 

for frac_ind=1:nfracs
    wiring_cost_temp = zeros(N,N,nruns);
    nodes_strength_temp = zeros(N,nruns);
        
    for run_ind=1:nruns
        % randomize network
        [~,Gs,~] = geombinsurr_partial(W,fiberdist,fracs(frac_ind),100,'equalwidth'); 
        
        % save randomized network for the last run
        if run_ind==nruns
            W_fracs(:,:,frac_ind)= Gs;
        end
        
        % wiring cost
        wiring_cost_temp(:,:,run_ind) = Gs.*fiberdist;
        
        % threshold randomized network
        Gs_t = threshold_proportional(Gs,thrs);
        
        % calculate node strengths
        nodes_strength_temp(:,run_ind) = sum(Gs_t,2);

        % check whether original hubs are still hubs
        S = sum(Gs_t, 2);  
        [~,I] = sort(S,'descend');
        haux = I(1:nhubs);
        hubs_again(:,frac_ind,run_ind) = ismember(hubs,haux);      
    end
    
    % calculate mean and std of wiring cost
    wiring_cost_mean(:,:,frac_ind) = mean(wiring_cost_temp,3);
    wiring_cost_std(:,:,frac_ind) = std(wiring_cost_temp,0,3);
    
    % calculate mean and std of node strengths
    S_mean(:,frac_ind) = mean(nodes_strength_temp,2);
    S_std(:,frac_ind) = std(nodes_strength_temp,0,2);
end

% calculate mean and std probability that hubs remain as hubs
P_mean = mean(hubs_again,3);
% P_std = std(hubs_again,0,3);


% % calculate probability that strength increases/decreases by 0,0.01,0.05,0.1,0.2
% P_strength_thresholds = [0, 0.01, 0.05, 0.1, 0.2];
% P_strength_pos = zeros(N, nfracs, length(P_strength_thresholds));
% P_strength_neg = zeros(N, nfracs, length(P_strength_thresholds));
% for j=1:length(P_strength_thresholds)
%     P_strength_pos(:,:,j) = mean((bsxfun(@rdivide, nodes_strength, nodes_strength(:,1,:)) - 1)>P_strength_thresholds(j), 3);
%     P_strength_neg(:,:,j) = mean((bsxfun(@rdivide, nodes_strength, nodes_strength(:,1,:)) - 1)<(-P_strength_thresholds(j)), 3);
% end

% calculate resilience, which is minimum fraction of rewired edges that
% satisfies threshold defined for the probability of hub to remain a hub
resilience = ones(1,length(hubs));
for jj=1:nhubs
    xres = find(P_mean(jj,:)<thrs_hub);
    if (isempty(xres)==0)
        resilience(jj) = fracs(min(xres));
    end
end

% fragility = 1 - resilience
fragility = 1-resilience;
