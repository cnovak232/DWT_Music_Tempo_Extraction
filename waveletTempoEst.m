function bpm_hist = waveletTempoEst(x,fs,flen,lvl,wname,plotting)

win_len_s = flen;
win_len_n = win_len_s * fs;
hop = win_len_n / 2;
xlen = length(x);

num_frames = 1 + ( xlen - win_len_n ) / hop;
bpm_hist = zeros(1,240);
levels = lvl;
lp_b = fir1(20,.1); % low pass for smoothing envelopes

for f = 0:num_frames-1
    f_ind = 1+f*hop:win_len_n+f*hop;
    xf = x(f_ind);
    [xdwt, bands,band_info] = my_dwt(xf,wname,levels,fs,plotting);
    fs_new = fs / (2^levels);
    fn = fieldnames(bands);
    
    % algorithm chain
    % downsample other bands to lower level
    envelopes = struct;
    for i=1:length(fn)
        ds_fac = 2^(levels-i);
        xw = bands.(fn{i});
        xw = abs(xw); % half wave rect
        xw = filter(lp_b,1,xw); % lp filter to smooth

        if i < length(fn) - 1
            xw = downsample(xw,ds_fac); % downsample for processing
        end

        xw = xw - mean(xw); % normalization ( subtract mean );
       
        envelopes.(fn{i}) = xw;   
    end
    
    % subband integration - 
    num_plots = length(fn) + 2;
    sum_envs_d = zeros(length(envelopes.d1),1);
    sum_envs_da = zeros(length(envelopes.d1),1);
    for i = 1:length(fn)
        data = envelopes.(fn{i});
        if i ~= length(fn)
            sum_envs_d = sum_envs_d + data;
        end
        sum_envs_da = sum_envs_da + data;
        if plotting
            subplot(num_plots,1,i);
            plot(data);
            title([fn{i} 'envelope']);
        end
    end

    if plotting
        subplot(num_plots,1,length(fn)+1);
        plot(sum_envs_d);
        title('Detail Envs Summed');
        subplot(num_plots,1,length(fn)+2);
        plot(sum_envs_da);
        title('Detail and Approx Envs Summed');
    end
        
    % perform autocorrelations
    env_acorr_d = xcorr(sum_envs_d,'biased');
    env_acorr_d = env_acorr_d(floor(end/2)+1:end);

    env_acorr_da = xcorr(sum_envs_da,'biased');
    env_acorr_da = env_acorr_da(floor(end/2)+1:end);

    if plotting
        figure;
        subplot(211)
        plot(env_acorr_d);
        title('Autocorr envs details');
        subplot(212);
        plot(env_acorr_da);
        title('Autocorr envs detail and approx')
    end
        
    [bpms, weights] = pick_peaks(env_acorr_d,2,fs_new,plotting);
    bpm_hist(bpms) = bpm_hist(bpms) + weights*2;

    [bpms, weights] = pick_peaks(env_acorr_da,2,fs_new,plotting);
    bpm_hist(bpms) = bpm_hist(bpms) + weights;
    
    close all
end

end