function mean_normalized = calc_mean_parcel_size_normalized(data, parc)

parcel_sizes = utils.calc_parcels_size(parc);

if size(data,1)==length(parcel_sizes)
    parcel_sizes = parcel_sizes';
    
    norm_factor = repmat(parcel_sizes, 1, size(data,2));
    mean_normalized = nansum(data.*norm_factor, 1)./nansum(norm_factor, 1);
elseif size(data,2)==length(parcel_sizes)
    norm_factor = repmat(parcel_sizes, size(data,1), 1);
    mean_normalized = nansum(data.*norm_factor, 2)./nansum(norm_factor, 2);
end