% -------------------------------------------------------------------------------------------
% This program calls two generic acquisition engines (on user choice):
%       1-  signal_acquisition_FFT.m that performs an FFT signal acquisition;
% -------------------------------------------------------------------------------------------
close all;fclose all;
global f_sampling;
f_sampling = 16.368 e6; % sampling frequency [Hz]
global fif;
fif = 4.092e6; % IF frequency [Hz]
PRN_vect = [1:30];
PRN_inview = []; % to store PRN in view
str = 'test_1.bin';
fid=fopen(str,'rb');
for ik = 1:length(PRN_vect)
    PRN = PRN_vect(ik);%% FFT signal acquisition
   %[doppler_est, code_phase, status] = signal_acquisition_FFT(fid,PRN);
    %%Time signal acquisition
   [doppler_est, code_phase, status] = signal_acquisition_time(fid,PRN);
   
   if (status == 0)
        fprintf('PRN %i has not been found\n',PRN)
    else
        PRN_inview = [PRN_inview PRN];
        disp('------------------------------------------------------');
        fprintf('PRN %i has been found \n',PRN);
        fprintf('Code Phase [samples]: %d \n',code_phase);
        fprintf('Mixing Frequency [Hz]: %d \n',doppler_est);
        fprintf('Doppler [Hz]: %d \n',doppler_est-fif);
        disp('------------------------------------------------------');
    end
end