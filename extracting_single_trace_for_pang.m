


load intrahemispheric_cc_Camcan_parcellation=QIMR_512_numGroups=4_group=1
im1 = out.cc; % correlation image over time
lag = out.cl; % lag values

offs = 50; % this ignores the initial bit of rubbish
r1 = zeros(length(lag),length(im1)); r2 = r1;
for kk = 2:length(lag)-1
    kk1 = kk-floor(length(lag)/2);
    dum1 = lag-kk; dum2 = lag-kk;
    for ii = offs:length(im1) % track maxima and minima in time
        s1 = im1(:,ii);
        a1 = find([diff(s1') 0]<=0 & [0 diff(s1)']>0); % find maxima 
        b1 = dum1(a1);
        c1 = a1(find(abs(b1)==min(abs(b1)),1)); % find maxima closes to zero lag
        r1(kk,ii) = c1;
        dum1 = dum1-dum1(c1); % shift zero lag to lag of current maxima
        a2 = find([diff(s1') 0] > 0 & [0 diff(s1)'] <= 0); % find minima
        b2 = dum2(a2);
        c2 = a2(find(abs(b2)==min(abs(b2)),1)); % find minima closest to zero lage
        r2(kk,ii) = c2;
        dum2 = dum2-dum2(c2); % shift zero lag to lag of current maxima
    end
    val1(kk,:) = [min([r1(kk,offs:end) ; r2(kk,offs:end)]') max([r1(kk,offs:end) ; r2(kk, offs:end)]')]; % cost function see if it hits that range of lags 
    
end

% not the best cost function
ref1 = find(val1(:,1)>2 & val1(:,2) & val1(:,3)<length(lag)-1 & val1(:,4)<length(lag)-1);% pick a trace that does not go near the edges of the image lag range
ref1 = ref1(floor(length(ref1)/2));
dum3 = mean([r1(ref1,:) ; r2(ref1,:)],1); % average minima trace and maxima trace together for some reason

% plot stuff
% figure;
% subplot(3,1,1); imagesc(im1)
% axis xy; ylabel('Original Thing'); axis([25 length(r1) 1 61])
% subplot(3,1,2); plot(dum3); ylabel('Extracted Thing'); axis([25 length(r1) 1 61])
% subplot(3,1,3); hold on;
% for ii = -10:10;
%     plot(dum3+ii*10)
% end
% axis([0 2500 0 60]); ylabel('Repeated Extracted Thing'); axis([25 length(r1) 1 61])
