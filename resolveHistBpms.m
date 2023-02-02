function [final_bpm,new_hist] = resolveHistBpms(bpm_hist,smooth)

if smooth
    maf = [1 1];
    maf = maf ./ sum(maf);
    bpm_hist = filter(maf,1,bpm_hist);
end
new_hist = bpm_hist;
[max_bpm_w, max_bpm] = max(bpm_hist);
all_bpms = [ max_bpm / 4;  max_bpm / 2; max_bpm; max_bpm*2; max_bpm*4 ];

bpms = round(all_bpms(all_bpms >= 40 & all_bpms <= 240));

bpm_weights = bpm_hist(bpms);

bpm_thr = max_bpm_w / 4;
final_bpm = max_bpm;

% if length(bpms) == 3
%     if (bpm_weights(2) > bpm_thr )
%         final_bpm = bpms(2);
%     elseif ( bpm_weights(3) > bpm_thr )
%         final_bpm = bpms(3);
%     end
% end
if max_bpm <= 65 && max_bpm == bpms(1)
%     bpms(2) = max([bpms(2)-1, bpms(2), bpms(2)+1]);
%     bpm_weights(2) = bpm_hist(bpms(2));
    if (bpm_weights(2) > bpm_thr )
        final_bpm = bpms(2);
    elseif ( length(bpm_weights) > 2 && bpm_weights(3) > bpm_thr )
        if bpm_weights(3) > bpm_weights(2)
            final_bpm = bpms(3);
        end
    end
end

end

