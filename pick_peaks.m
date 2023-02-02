function [bpms,weights] = pick_peaks(xn,num_peaks,fs_new, plotting)
    bpm_win = [40 240];
    bps_win = 60./bpm_win;
    bpn_win = round(bps_win * fs_new); % how many samples to look
    
    [pvals,plocs] = findpeaks(xn,"MinPeakDistance",200,"SortStr","descend");
    inds = plocs >= bpn_win(2) & plocs <= bpn_win(1);
    plocs = plocs(inds);
    pvals = pvals(inds);
    npeaks = min(num_peaks,length(plocs));
    top_plocs = plocs(1:npeaks); 
    top_pvals = pvals(1:npeaks);
    dist_n = top_plocs - 1;
    
    dist_bps = dist_n / fs_new;
    
    bpms = round(60 ./ dist_bps);
    weights = top_pvals';

    if plotting
        figure;
        plot(xn);
        hold on
        plot(top_plocs,top_pvals,'*');
        hold on
        line([bpn_win(2),bpn_win(2)],[min(xn),max(xn)],"Color", "Red");
        hold on
        line([bpn_win(1),bpn_win(1)],[min(xn),max(xn)],"Color", "Red");
    end
end