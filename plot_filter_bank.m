function plot_filter_bank(h0,h1,fs)

figure;
subplot(211);
stem(h0);
title('h0');
xlabel('Samples (n)')
subplot(212);
stem(h1);
title('h1')
xlabel('Samples (n)')

N = 1024;
Hw0 = abs(fft(h0,N));
Hw0 = Hw0(1:end/2 + 1);
Hw1 = abs(fft(h1,N));
Hw1 = Hw1(1:end/2 + 1);
fw = linspace(0,fs/2,N/2+1);
fw = fw / (fs/2); % normalized freq

figure;
plot(fw,Hw0);
hold on
plot(fw,Hw1);
legend('Hw0','Hw1');
title('Frequency Response');
xlabel('Normalized Freq (\times\pi rad/sample)');
ylabel('Magnitude')
hold off
end