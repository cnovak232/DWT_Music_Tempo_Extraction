%% Wavelets and Filter Banks Term Project
% Wavelet based musicial tempo extraction
% Chris Novak

%% Read in audio and tempos
audiodir = './Audio/Tempo/';
listname = dir(audiodir);
listname = listname(3:end);
fs = 44100;
t_per_song = 30; % 30 second clips of each song
num_samples = t_per_song * fs;
music_files = {};
for i = 1:length(listname)
    [y,fs] = audioread([audiodir, listname(i).name],[1 num_samples]);
    music_files{i} = y;
end

% read in labels

labels = readcell('Test_BPMS.txt');
%% Wavelet filters viewing
wname = 'sym8';
[LoD,HiD,LoR,HiR] = wfilters(wname); 
plot_filter_bank(LoD,HiD,fs);

%% Test one audio file 
wname = 'sym8';
x = music_files{5};

x = mean(x,2); % make mono for now
flen = 3; % frame length in seconds

bpm_hist = waveletTempoEst(x,fs,flen,4,wname,0);

figure;
stem(bpm_hist);

[final_bpm,new_hist] = resolveHistBpms(bpm_hist,false);

% figure;
% stem(new_hist);
% title("BPM Histogram for track 'Weapon'");
% xlabel('BPMs');
% ylabel('Weight');

disp('BPM Estimate of Track:')
disp(final_bpm);

%% Run through all files 

flen = 3; % frame lenght in seconds
wname = 'sym8';
for i = 1:length(labels)
    id = labels{i,1};

    x = music_files{id};
    
    x = mean(x,2); % make mono for now
    
    bpm_hist = waveletTempoEst(x,fs,flen,4,wname,0);
   
    final_bpm = resolveHistBpms(bpm_hist,false);
    
    labels{i,4} = final_bpm;
   
end

labs = cell2mat(labels(:,3));
my_labs = cell2mat(labels(:,4));
correct_labs = abs(labs - my_labs) < 3;
correct = (sum(correct_labs) / length(correct_labs))* 100

not_correct = find(~correct_labs);

inc_labs = labs(not_correct);
inc_my_labs = my_labs(not_correct);

part_correct1 = abs( (inc_labs * 2) - inc_my_labs) < 3;

part_correct2 = abs( inc_labs - (inc_my_labs*2)) < 3;

part_correct = ( (sum(part_correct1) + sum(part_correct2)) / length(correct_labs) ) * 100

incorrect = 100 - correct - part_correct 






















