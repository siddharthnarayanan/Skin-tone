%n=size(a);
%M=n(1);
%N=n(2);
a=[1 2 3 4;3 4 5 6;4 5 6 7;7 8 9 0];
b=[2 3 4 5;4 5 6 7;2 3 4 5;4 5 6 7];
n=size(a);
M=n(1);
N=n(2);
MSE = sum(sum((a-b).^2))/(M*N);
disp(MSE);
%set(handles.edit1,'String',MSE);

fprintf('\nMSE: %7.2f ', MSE);
%save mse;

%load mse;
PSNR = 10*log10(256*256/MSE);
%set(handles.edit2,'String',PSNR);
fprintf('\nPSNR: %9.7f dB', PSNR);
%disp(PSNR);