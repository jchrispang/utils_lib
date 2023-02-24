function metric_parcel = calc_cortical_parc_metrics(parc, metric, data_input, ROI_mask)
% calc_cortical_parc_metrics.m
%
% Calculate cortical parcellation performance via metric
%
% Inputs: parc          : parcellation [Nx1]
%                         N = number of vertices
%         metric        : performance metric to calculate (string)
%                         Possible metrics:
%                         'pca_timeseries', 
%                         'pca_zFC_vertex_parcel', 'pca_FC_vertex_parcel', 
%                         'pca_zFC_ROI', 'pca_FC_ROI', 'pca_zFC', 'pca_FC', 
%                         'mean_zFC', 'mean_FC',
%                         'mean_task', 'std_task', 
%                         'mean_myelin', 'std_myelin',
%                         'mean_thickness', 'std_thickness', 'mean_S'
%         data_input    : data to calculate metric from
%         ROI_mask      : mask of ROI
%                         this is only needed for 'pca_zFC_ROI' and 'pca_FC_ROI'
%
% Output: metric_parcel : metric value per parcel
%
% Original: James Pang, Monash University, 2021

%%
warning('off', 'all')

num_vertices = size(parc,1);
parcels = unique(parc(parc>0));
num_parcels = length(parcels);

if nargin<4
    ROI_mask = ones(num_vertices,1);
end

if strcmpi(metric, 'pca_timeseries')
    
    metric_parcel = zeros(num_parcels,1);
    size_data = size(data_input.data);
    data = data_input.data;
    
    for parcel_ind = 1:num_parcels
        parcel_interest = parcels(parcel_ind);

        ind_parcel = find(parc==parcel_interest);
    
        if size_data(1)==num_vertices
            data_parcel = data(ind_parcel,:)';
        elseif size_data(2)==num_vertices
            data_parcel = data(:,ind_parcel);
        end
        data_parcel_normalized = utils.calc_normalize_timeseries(data_parcel);
        data_parcel_normalized(isnan(data_parcel_normalized)) = 0;
        
        warning off
        [~,~,~,~,temp_explained] = pca(data_parcel_normalized, 'Rows', 'complete');
        metric_parcel(parcel_ind) = double(temp_explained(1));
    end

elseif strcmpi(metric, 'pca_zFC_vertex_parcel') || strcmpi(metric, 'pca_FC_vertex_parcel') 
    
    metric_parcel = zeros(num_parcels,1);
    data_type = data_input.data_type;
    size_data = size(data_input.data);
    data = data_input.data;
    
    % normalize
    if strcmpi(data_type, 'timeseries')
        if size_data(1)==num_vertices
            data = utils.calc_normalize_timeseries(data');
            T = size_data(2);
        elseif size_data(2)==num_vertices
            data = utils.calc_normalize_timeseries(data);
            T = size_data(1);
        end
        data = data';
    end

    data_parcellated = utils.calc_parcellate(parc, data);

    FC_combined = {};
    zFC_combined = {};
    for parcel_ind = 1:num_parcels
        parcel_interest = parcels(parcel_ind);
        ind_parcel = find(parc==parcel_interest);

        if strcmpi(data_type, 'timeseries')
            data_parcel = data(ind_parcel,:);
            
            FC = data_parcellated*data_parcel';
            FC = FC/T;
            zFC = atanh(FC);
        elseif strcmpi(data_type, 'zFC')
            FC = tanh(data_parcellated(:,ind_parcel));
            zFC = data_parcellated(:,ind_parcel);
        elseif strcmpi(data_type, 'FC')
            FC = data_parcellated(:,ind_parcel);
            zFC = atanh(data_parcellated(:,ind_parcel));
        end
        FC(isnan(FC)) = 0;
        zFC(isnan(zFC)) = 0;
        FC_combined{parcel_ind} = FC;
        zFC_combined{parcel_ind} = zFC;
    end

    for parcel_ind = 1:num_parcels
        warning('off', 'all')
        if strcmpi(metric, 'pca_zFC_vertex_parcel')
%             warning('off', 'all')
            [~,~,~,~,temp_explained] = pca(zFC_combined{parcel_ind}, 'Rows', 'complete');
            metric_parcel(parcel_ind) = double(temp_explained(1));
        elseif strcmpi(metric, 'pca_FC_vertex_parcel')
%             warning off
            [~,~,~,~,temp_explained] = pca(FC_combined{parcel_ind}, 'Rows', 'complete');
            metric_parcel(parcel_ind) = double(temp_explained(1));
        end
    end

elseif strcmpi(metric, 'pca_zFC_ROI') || strcmpi(metric, 'pca_FC_ROI') 
    
    metric_parcel = zeros(num_parcels,1);
    data_type = data_input.data_type;
    size_data = size(data_input.data);
    data = data_input.data;
    
    ind_ROI = find(ROI_mask);
    
    FC_combined = {};
    zFC_combined = {};
    for parcel_ind = 1:num_parcels
        parcel_interest = parcels(parcel_ind);
        ind_parcel = find(parc==parcel_interest);

        if strcmpi(data_type, 'timeseries')
            if size_data(1)==num_vertices
                data_parcel = data(ind_parcel,:)';
                data_ROI = data(ind_ROI,:)';
                T = size_data(2);
            elseif size_data(2)==num_vertices
                data_parcel = data(:,ind_parcel);
                data_ROI = data(:,ind_ROI);
                T = size_data(1);
            end
            data_parcel_normalized = utils.calc_normalize_timeseries(data_parcel);
            data_parcel_normalized(isnan(data_parcel_normalized)) = 0;
            data_ROI_normalized = utils.calc_normalize_timeseries(data_ROI);
            data_ROI_normalized(isnan(data_ROI_normalized)) = 0;

            FC = data_ROI_normalized'*data_parcel_normalized;
            FC = FC/T;
            zFC = atanh(FC);
        elseif strcmpi(data_type, 'zFC')
            FC = tanh(data(ind_ROI,ind_parcel));
            zFC = data(ind_ROI,ind_parcel);
        elseif strcmpi(data_type, 'FC')
            FC = data(ind_ROI,ind_parcel);
            zFC = atanh(data(ind_ROI,ind_parcel));
        end
        FC(isnan(FC)) = 0;
        zFC(isnan(zFC)) = 0;
        FC_combined{parcel_ind} = FC;
        zFC_combined{parcel_ind} = zFC;
    end
    
    parfor parcel_ind = 1:num_parcels
        warning('off', 'all')
        if strcmpi(metric, 'pca_zFC_ROI')
%             warning('off', 'all')
            [~,~,~,~,temp_explained] = pca(zFC_combined{parcel_ind}, 'Rows', 'complete');
            metric_parcel(parcel_ind) = double(temp_explained(1));
        elseif strcmpi(metric, 'pca_FC_ROI')
%             warning off
            [~,~,~,~,temp_explained] = pca(FC_combined{parcel_ind}, 'Rows', 'complete');
            metric_parcel(parcel_ind) = double(temp_explained(1));
        end
    end
    
elseif strcmpi(metric, 'pca_zFC') || strcmpi(metric, 'pca_FC') || strcmpi(metric, 'mean_zFC') || strcmpi(metric, 'mean_FC')
    
    metric_parcel = zeros(num_parcels,1);
    data_type = data_input.data_type;
    size_data = size(data_input.data);
    data = data_input.data;
    
    FC_combined = {};
    zFC_combined = {};
    for parcel_ind = 1:num_parcels
        parcel_interest = parcels(parcel_ind);
        ind_parcel = find(parc==parcel_interest);

        if strcmpi(data_type, 'timeseries')
            if size_data(1)==num_vertices
                data_parcel = data(ind_parcel,:)';
                T = size_data(2);
            elseif size_data(2)==num_vertices
                data_parcel = data(:,ind_parcel);
                T = size_data(1);
            end
            data_parcel_normalized = utils.calc_normalize_timeseries(data_parcel);
            data_parcel_normalized(isnan(data_parcel_normalized)) = 0;

            FC = data_parcel_normalized'*data_parcel_normalized;
            FC = FC/T;
            zFC = atanh(FC);
        elseif strcmpi(data_type, 'zFC')
            FC = tanh(data(ind_parcel,ind_parcel));
            zFC = data(ind_parcel,ind_parcel);
        elseif strcmpi(data_type, 'FC')
            FC = data(ind_parcel,ind_parcel);
            zFC = atanh(data(ind_parcel,ind_parcel));
        end
        FC(isnan(FC)) = 0;
        zFC(isnan(zFC)) = 0;
        FC_combined{parcel_ind} = FC;
        zFC_combined{parcel_ind} = zFC;
    end
    
    parfor parcel_ind = 1:num_parcels
        if strcmpi(metric, 'pca_zFC')
            warning off
            [~,~,~,~,temp_explained] = pca(zFC_combined{parcel_ind}, 'Rows', 'complete');
            metric_parcel(parcel_ind) = double(temp_explained(1));
        elseif strcmpi(metric, 'pca_FC')
            warning off
            [~,~,~,~,temp_explained] = pca(FC_combined{parcel_ind}, 'Rows', 'complete');
            metric_parcel(parcel_ind) = double(temp_explained(1));
        elseif strcmpi(metric, 'mean_zFC')
            temp = zFC_combined{parcel_ind};
            triu_ind = find(triu(ones(size(temp)),1));
            metric_parcel(parcel_ind) = mean(temp(triu_ind));
        elseif strcmpi(metric, 'mean_FC')
            temp = FC_combined{parcel_ind};
            triu_ind = find(triu(ones(size(temp)),1));
            metric_parcel(parcel_ind) = mean(temp(triu_ind));
        end
    end
    
elseif strcmpi(metric, 'mean_task') || strcmpi(metric, 'std_task')
    
    contrasts = fieldnames(data_input);
    num_contrasts = length(contrasts);
    
    metric_parcel = zeros(num_parcels,num_contrasts);
    
    for parcel_ind = 1:num_parcels
        parcel_interest = parcels(parcel_ind);

        ind_parcel = find(parc==parcel_interest);
        
        for contrast_ind = 1:num_contrasts
            contrast = contrasts{contrast_ind};
            
            data_input.(contrast)(isnan(data_input.(contrast))) = 0;
            
            if strcmpi(metric, 'mean_task')
                metric_parcel(parcel_ind,contrast_ind) = mean(data_input.(contrast)(ind_parcel));
            elseif strcmpi(metric, 'std_task')
                metric_parcel(parcel_ind,contrast_ind) = std(data_input.(contrast)(ind_parcel));
            end
        end
    end
elseif strcmpi(metric, 'mean_myelin') || strcmpi(metric, 'std_myelin')
    
    data_input(isnan(data_input)) = 0;
    
    metric_parcel = zeros(num_parcels,1);
    
    for parcel_ind = 1:num_parcels
        parcel_interest = parcels(parcel_ind);

        ind_parcel = find(parc==parcel_interest);
        
        if strcmpi(metric, 'mean_myelin')
            metric_parcel(parcel_ind) = mean(data_input(ind_parcel));
        elseif strcmpi(metric, 'std_myelin')
            metric_parcel(parcel_ind) = std(data_input(ind_parcel));
        end
    end
elseif strcmpi(metric, 'mean_thickness') || strcmpi(metric, 'std_thickness')
    
    data_input(isnan(data_input)) = 0;
    
    metric_parcel = zeros(num_parcels,1);
    
    for parcel_ind = 1:num_parcels
        parcel_interest = parcels(parcel_ind);

        ind_parcel = find(parc==parcel_interest);
        
        if strcmpi(metric, 'mean_thickness')
            metric_parcel(parcel_ind) = mean(data_input(ind_parcel));
        elseif strcmpi(metric, 'std_thickness')
            metric_parcel(parcel_ind) = std(data_input(ind_parcel));
        end
    end
elseif strcmpi(metric, 'mean_S')
    
    metric_parcel = zeros(num_parcels,1);
    
    S_combined = {};
    for parcel_ind = 1:num_parcels
        parcel_interest = parcels(parcel_ind);
        ind_parcel = find(parc==parcel_interest);

        S = data_input(ind_parcel,ind_parcel);
        S(isnan(S)) = 0;
        
        S_combined{parcel_ind} = S;
    end
    
    parfor parcel_ind = 1:num_parcels
        temp = S_combined{parcel_ind};
        triu_ind = find(triu(ones(size(temp)),1));
        metric_parcel(parcel_ind) = mean(temp(triu_ind));
    end
end

