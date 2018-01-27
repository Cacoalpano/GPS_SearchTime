
close all;
clear all;
f_sampling = 16.368e6;
fif = 4.092e6;
%doc file du lieu gan vao bien gpsdata
str = 'test_1.bin';
fid=fopen(str,'rb');
file=fid;
seek_sec = 0;
fseek(file,ceil(f_sampling*seek_sec),-1);   % Diem bat dau doc trong file du lieu (sec)
[gpsdata,scount] = fread(fid,40000*6,'int8');

%lay 500 gia tri dau tien cua gpsdata de xu ly
data=gpsdata';

% Ve tin hieu
figure, plot(data), title('Digital Signal');

% Ve mat do pho cong suat
nfft = 2^nextpow2(length(data));
Pxx = abs(fft(data,nfft)).^2/length(data)/f_sampling;
Hpsd = dspdata.psd(Pxx(1:length(Pxx)/2),'Fs',f_sampling);  
figure, plot(Hpsd), title('Power Spectral Density');

% VE PHO
%Take fourier transform
fftSignal = fft(data);
%apply fftshift to put it in the form we are used to (see documentation)
fftSignal = fftshift(fftSignal);

figure, plot( abs(fftSignal)), title('magnitude FFT of sine');
xlabel('Frequency (Hz)');
ylabel('magnitude');

%VE HISTOGRAM
figure, hist(data), title('Histogram');
% end

%Tinh gia tri trung binh cua tin hieu
tb=sum(data)/length(data);
%Phuong sai giai tri trung binh cua tin hieu
SN =sum(data.^2)/length(data)-tb^2;

