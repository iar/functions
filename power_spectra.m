function [frequency,spectra]=power_spectra(waveform,samples,rate)

Fs=rate;
T=1/Fs;
L=samples;
t=(0:L-1)*T;
NFFT=2^nextpow2(L);
Y=fft(waveform,NFFT)/L;
frequency=Fs/2*linspace(0,1,NFFT/2+1);
spectra=2*abs(Y(1:NFFT/2+1));

end