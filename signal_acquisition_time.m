function [doppler, code, st] = signal_acquisition_time(file,prn)
global f_sampling;
global fif;
acq_metric = 1.4;                           % Nguong xac dinh co ve tinh
seek_sec = 0;
fseek(file,ceil(f_sampling*seek_sec),-1);   % Diem bat dau doc trong file du lieu (sec)
[gpsdata,scount] = fread(file,40000*6,'int8'); 
code_rate = 1.023*1e6;                      % Tan so cua ma GPS C/A.
num_samples = f_sampling/code_rate;         % So mau tren 1 chip (cua ma C/A).
CodeLen=1023;                               % Do dai cua mot ma C/A
N=floor(f_sampling*CodeLen/code_rate)+1;
Dopplerstep=500;
S=prn;
idx=1;
% Sinh ma trai pho cho ve tinh S
Loc = generateCAcode(S);
% Bo sung them 1 chip de du phong khi lay mau
Loc = [Loc Loc(1)];  
C=[];
k=0:N-1;
% Lay mau ma trai pho theo tan so lay mau f_sampling
SigLOC=Loc(floor(k*code_rate/f_sampling)+1);   
%Lay tin hieu 
SigIN=gpsdata'; 
 for FD=-5000:Dopplerstep:5000 
    argx=2*pi*(fif+FD)/f_sampling;
    carrI=cos(argx*k);
    carrQ=sin(argx*k);
        for i=1:N
            x=SigIN(i:i+N-1).*SigLOC;
            I=carrI.*x;
            Q=carrQ.*x;
            corr(i) =sqrt(sum(I)^2+sum(Q)^2);  
        end
        C(idx,:)=corr;
        idx=idx+1;
 end
% --- Xac dinh xem ve tinh co hay khong
% Tim vi tri cua cell cho gia tri lon nhat trong searchspace
[bb ind_mixf] = max(max(C'));
[bb ind_mixc] = max(max(C));

% Tim vi tri cua cell co gia tri lon thu hai trong searchspace
if (ind_mixc < ceil(num_samples)),
    vect_search_peak2 = [zeros(1,2*ceil(num_samples)), C(ind_mixf,(2*ceil(num_samples)):end)];
elseif (ind_mixc < ceil(num_samples))
    vect_search_peak2 = [C(ind_mixf,1:(end-2*ceil(num_samples)):end), zeros(1,2*ceil(num_samples))];
else
    vect_search_peak2 = [C(ind_mixf,1:(ind_mixc-ceil(num_samples))),zeros(1,2*ceil(num_samples)-1),C(ind_mixf,(ind_mixc+ceil(num_samples)):end)];
end
second_peak = max(vect_search_peak2);

% So sanh ty so cua dinh lon nhat voi dinh thu hai vs. nguong cho truoc

if ((bb/second_peak) > acq_metric)
    fprintf('...acquired satellite\n ')
    code = ceil(f_sampling*seek_sec)+((ind_mixc-1));
    doppler = (fif-5e3) + (ind_mixf-1)*Dopplerstep;
    st = 1;
    figure, surf(C), shading interp;
else
    fprintf('...no satellite ')
    code = 0;
    doppler = 0;
    st = 0;
end
end