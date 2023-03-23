function parc_list_by_type = get_cortical_parc_list()

% only for more than one parcel in each hemisphere

% parc_name_list = {'Brodmann78', 'Smith88', 'Flechsig92', 'Kleist98', 'Julich257', ...
%                   'Desikan70', 'AAL82', 'Mars82', 'HarvardOxford96', 'Destrieux150', ...
%                   'Brainnetome210', 'Cammoun219', 'Glasser360', ...
%                   'Shen200', 'Craddock300', 'Schaefer300', 'Aicha344'}; 
              
%% by type
% Histological
parc_list_by_type.Histological = {'Brodmann78', 'Smith88', 'Flechsig92', 'Kleist98', 'Julich257'};

% Anatomical
parc_list_by_type.Anatomical = {'Desikan70', 'AAL82', 'Mars82', 'HarvardOxford96', 'Destrieux150'};

% Hybrid
parc_list_by_type.Hybrid = {'Brainnetome210', 'Cammoun219', 'Glasser360'};

% Functional
parc_list_by_type.Functional = {'Shen200', 'Craddock300', 'Schaefer300', 'Aicha344'};

