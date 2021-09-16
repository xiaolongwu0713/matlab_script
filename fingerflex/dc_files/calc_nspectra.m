function [spectra]=calc_nspectra(spectra)
%this function normalizes the spectra prior to the pca step
%kjm 12/07

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% normalization step
for k=1:size(spectra,2)
%     spectra(:,k,:)=spectra(:,k,:)./repmat(squeeze(mean(spectra(:,k,:),3)),[1 1 size(spectra,3)]);
    spectra(:,k,:)=log(spectra(:,k,:)./repmat(squeeze(mean(spectra(:,k,:),3)),[1 1 size(spectra,3)]));
end
clear k
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

