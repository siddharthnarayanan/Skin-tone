
function varargout = skin_new(varargin)
% SKIN_NEW M-file for skin_new.fig
%      SKIN_NEW, by itself, creates a new SKIN_NEW or raises the existing
%      singleton*.
%
%      H = SKIN_NEW returns the handle to a new SKIN_NEW or the handle to
%      the existing singleton*.
%
%      SKIN_NEW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SKIN_NEW.M with the given input arguments.
%
%      SKIN_NEW('Property','Value',...) creates a new SKIN_NEW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before skin_new_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to skin_new_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help skin_new

% Last Modified by GUIDE v2.5 21-Jan-2011 00:00:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @skin_new_OpeningFcn, ...
                   'gui_OutputFcn',  @skin_new_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before skin_new is made visible.
function skin_new_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to skin_new (see VARARGIN)

% Choose default command line output for skin_new
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes skin_new wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = skin_new_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Browse.
function Browse_Callback(hObject, eventdata, handles)
% hObject    handle to Browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%%%%%% read cover image %%%%%%%%
[file,path] = uigetfile('*.jpg','*.png','Pick an Image File');
if isequal(file,0) | isequal(path,0)
    warndlg('User Pressed Cancel');
else
    a = imread(file);
    a=imresize(a,[256 256]);
    [r c p] = size(a);
   axes(handles.axes1);
    imshow(a);
    handles.a=a;
    disp(size(a));
    guidata(hObject, handles);
end

% --- Executes on button press in skin.
function skin_Callback(hObject, eventdata, handles)
% hObject    handle to skin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=handles.a;
HSV=rgb2hsv(a);
HSV(:,:,1) = HSV(:,:,1)*360;
h = HSV(:,:,1);
s = HSV(:,:,2);
v = HSV(:,:,3);
[r c p]=size(a);
d=zeros(r,c);
for i=1:r;
    for j=1:c;
        if ((h(i,j)<45)&((s(i,j)<0.68)& (s(i,j)>0.25)))
            d(i,j)=1;
        end
    end
end
d = medfilt2(d,[3 3]);
    figure;
    imshow(d);
    title('Mask image');
    handles.a=a;
    handles.d=d;
     guidata(hObject, handles);
     helpdlg('Skin detection is done');

% --- Executes on button press in Cropping.
function Cropping_Callback(hObject, eventdata, handles)
% hObject    handle to Cropping (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=handles.a;
d=handles.d;
[x y]=find(d==1);
            Min_y = min(y)+30;
            Max_y = max(y) - 30;
            x_tot=[x y];
            x_cen= floor(length(x)/2);
            x_loc = x(x_cen);
            y_loc = y(x_cen);
            Inc_val = y_loc - Min_y;
            
            New_intr = x_loc-Inc_val;
             New_endr = x_loc+Inc_val;
             New_intc = y_loc-Inc_val;
             New_endc = y_loc+Inc_val;
             
           Cropped_mask=d(x_loc-Inc_val:x_loc+Inc_val,y_loc-Inc_val:y_loc+Inc_val);
           %figure;
           %imshow(Cropped_mask,[]);
           [R C]=size(Cropped_mask);
           M1=mod(R,2);
           if M1==1
               skin_mask = a(New_intr:New_endr-1,New_intc:New_endc-1,:);
           end
           
          disp(size(skin_mask));
           figure(89);
           
           imshow(skin_mask);
           handles.skin_mask=skin_mask;
           guidata(hObject, handles);
           helpdlg('cropping process done');
           handles.a=a;
           handles.d=d;
%            Handles the cropped regions
handles.New_intr=New_intr;
handles. New_endr= New_endr;
handles.New_intc=New_intc;
handles.New_endc=New_endc;
guidata(hObject, handles);


% --- Executes on button press in histogram.
function histogram_Callback(hObject, eventdata, handles)
% hObject    handle to histogram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
minvalue=15;
maxvalue=240;
skin_mask=handles.skin_mask;
[r c p]=size(skin_mask);
s=skin_mask(:,:,3);  
[r c]=size(s);
for i=1:r;
    for j=1:c;
        if s(i,j)<=minvalue;
            s(i,j)=minvalue;
        elseif s(i,j)>=maxvalue;
            s(i,j)=maxvalue;
        end
    end
end
histmod=s;
figure(11);
imshow(histmod);
handles.histmod=histmod;
handles.skin_mask=skin_mask;
guidata(hObject, handles);
helpdlg('histogram modification done');


% --- Executes on button press in transform.
function transform_Callback(hObject, eventdata, handles)
% hObject    handle to transform (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%%%%%iwt transform applied%%%%%%%
histmod=handles.histmod;
 
[r c]=size(histmod);
for i=1:8:r-7;
    for j=1:8:c-7;
        bloc_k=histmod(i:i+7,j:j+7);
        [r t y u]=dwt2(bloc_k,'haar');
        Y(i:i+7,j:j+7)=round([r t;y u]);
    end
end
qw=[r t; y u];
fg=imresize(qw,[256 256]);
figure(567)
imshow(fg,[]);
handles.Y=Y;
guidata(hObject, handles);
helpdlg('Transformation completed');

% --- Executes on button press in Embedding.
function Embedding_Callback(hObject, eventdata, handles)
% hObject    handle to Embedding (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%%%%%embedding technic used%%%%%%%%%%%
Y=handles.Y;
orig_key=handles.orig_key;
[file path]=uigetfile('*.txt','choose txt file');
if isequal(file,0) | isequal(path,0)
    warndlg('User Pressed Cancel');
else
    data1=fopen(file,'r');
    F=fread(data1);
    fclose(data1);
end
len=length(F);
count=1;
totalbits=8*len;
a=128;
k=1;
[r c]=size(Y);
for i=1:8:r-7;
    for j=1:8:c-7;
        block3=Y(i:i+7,j:j+7);
        for ii=1:8
            for jj=1:8;
                if orig_key(ii,jj)==1;
                    coeff=abs(block3(ii,jj));
                    [ block3(ii,jj),a,k,count]=bitlength(coeff,a,k,F,totalbits,count,len);
                    if count>totalbits;
                        break;
                    end
                end
                if count>totalbits;
                    break;
                end
            end
            if count>totalbits;
                break;
            end
        end
        Y(i:i+7,j:j+7)=block3;
        Y=abs(Y);
        if count>totalbits;
            break;
        end
    end
    if count>totalbits;
        break;
    end
end
outpu_t=Y;
figure;
imshow(outpu_t);
title('embedded image');
handles.outpu_t=outpu_t;
handles.totalbits=totalbits;
guidata(hObject, handles);
helpdlg('Process completed');

% --- Executes on button press in Inverse.
function Inverse_Callback(hObject, eventdata, handles)
% hObject    handle to Inverse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
outpu_t=handles.outpu_t;
[r c]=size(outpu_t);
m=1;
n=1;
for i=1:8:r-7;
    for j=1:8:c-7;
        bloc_k11=outpu_t(i:i+7,j:j+7);
        LL=bloc_k11(m:m+3,n:n+3);
        LH=bloc_k11(m:m+3,n+4:n+7);
        HL=bloc_k11(m+4:m+7,n:n+3);
        HH=bloc_k11(m+4:m+7,n+4:n+7);
        Z(i:i+7,j:j+7)=idwt2(LL,LH,HL,HH,'haar');
    end
end
axes(handles.axes2);
imshow(Z,[]);
handles.Z=Z;
guidata(hObject, handles);
helpdlg('Inverse Transformation completed');
helpdlg('Output Image is obtained');


% --- Executes on button press in stagno.
function stagno_Callback(hObject, eventdata, handles)
% hObject    handle to stagno (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Z=handles.Z;
New_intr=handles.New_intr;
New_endr=handles.New_endr;
New_intc=handles.New_intc;
New_endc=handles.New_endc;
a=handles.a;
X=a(New_intr:New_endr-1,New_intc:New_endc-1,:)
X=Z;
axes(handles.axes2);
imshow(a);
title('Reconstructed image');
Recon_im=a;
w=rgb2gray(a);
handles.w=w;
handles.Recon_im=Recon_im;
guidata(hObject, handles);

% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Recon_im=handles.Recon_im;
figure;
imshow(Recon_im);
title('Received Image');

% --- Executes on button press in Cropping2.
function Cropping2_Callback(hObject, eventdata, handles)
% hObject    handle to Cropping2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
New_intr=handles.New_intr;
New_endr=handles.New_endr;
New_intc=handles.New_intc;
New_endc=handles.New_endc;
Recon_im=handles.Recon_im;
C=Recon_im(New_intr:New_endr-1,New_intc:New_endc-1,:);
cropped_image=C;
figure;
imshow(cropped_image);
title('Recropped Image');
handles.C_I=cropped_image;
guidata(hObject, handles);

% --- Executes on button press in transform2.
function transform2_Callback(hObject, eventdata, handles)
% hObject    handle to transform2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cropped_image=handles.C_I;
Z=cropped_image;
Z=handles.Z;
extractinpu_t=Z;

[r c]=size(extractinpu_t);
for i=1:8:r-7;
    for j=1:8:c-7;
        bloc_kw=extractinpu_t(i:i+7,j:j+7);
        [r t y u]=dwt2(bloc_kw,'haar');
        YY(i:i+7,j:j+7)=round([r t;y u]);
    end
end
handles.YY=YY;
guidata(hObject, handles);
helpdlg('Transformation completed');


% --- Executes on button press in Extraction.
function Extraction_Callback(hObject, eventdata, handles)
% hObject    handle to Extraction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
YY=handles.YY;
totalbits=handles.totalbits;
orig_key=handles.orig_key;
fil_e=YY;
% totalbits=8*len;
a=128;
jjj=1;
count=1;
k=0;
[r c]=size(YY);
for i=1:8:r-7;
    for j=1:8:c-7;
        block9=fil_e(i:i+7,j:j+7);
        for ii=1:8
            for jj=1:8;
                if orig_key(ii,jj)==1;
                    coeff=abs(block9(ii,jj));
                    %                     [ k,a,count,jjj,ff]=extrac_t(coeff,a,k,jjj,totalbits,count);
                    g=coeff;
                    if g>=64;
                        bits=6;

                        h=32;
                    elseif g<64 & g>=32;
                        bits=5;

                        h=16;
                    elseif g<32 & g>=16;
                        bits=4;

                        h=8;
                    elseif g<16
                        bits=3;
                        h=4;
                    end
                    l=bits;
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    for iii=1:l;
                        if bitand(g,h)==h;
                            k= bitor(k,a);
                        end
                        count=count+1;
                        a=a/2;
                        h=h/2;
                        if a<1;
                            R(jjj)=k;
                            fid=fopen('output.txt','wb');
                            fwrite(fid,char(R),'char');
                            fclose(fid);jjj=jjj+1;
                            k=0;
                            a=128;
                        end
                        if count>totalbits;
                            break;
                        end
                    end
                    if count>totalbits;
                        break;
                    end
                end
                if count>totalbits;
                    break;
                end
            end
            if count>totalbits;
                break;
            end
        end
        if count>totalbits;
            break;
        end
    end
    if count>totalbits;
        break;
    end
end
helpdlg('Secret data was obtained in text file');


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
open('output.txt');

% --- Executes on button press in Validate.
function Validate_Callback(hObject, eventdata, handles)
% hObject    handle to Validate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Clear.
function Clear_Callback(hObject, eventdata, handles)
% hObject    handle to Clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

delete '*.txt';
clear all;
close all;


% --- Executes on button press in Key.
function Key_Callback(hObject, eventdata, handles)
% hObject    handle to Key (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
keygener=zeros(8,8);
key=[0 0 1 0 ;0 0 1 1 ;0 1 0 1; 0 1 1 1; 1 0 0 0; 1 0 1 0; 1 1 0 1; 1 0 1 1];
key1=[0 0 1 0 0 0 1 0 ;0 0 1 1 0 0 1 1 ;0 1 0 1 0 1 0 1; 0 1 1 1 0 1 1 1];
keygener(1:8,5:8)=key;
keygener(5:8,1:8)=key1;
orig_key=keygener;
handles.orig_key=orig_key;
guidata(hObject, handles);
helpdlg('Secret key generated');


% --- Executes on button press in OPM.
function OPM_Callback(hObject, eventdata, handles)
% hObject    handle to OPM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)







function val_Callback(hObject, eventdata, handles)
% hObject    handle to val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%% COMPUTATION OF MEAN SQUARE ERROR %%%%.


% --- Executes on button press in validatate.
function validatate_Callback(hObject, eventdata, handles)
% hObject    handle to validatate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=handles.a;
c=rgb2gray(a);
f=double(c);
w=handles.w;
h=double(w);
%b=handles.b;
%[M N]=size(w);
%Y=handles.Y;
%YY=handles.YY;
%outpu_t=handles.outpu_t;
 
[M N]=size(c);
%M=n(1);
%N=n(2);
MSE = sum(sum((h-f)^2))/(M*N);
disp(MSE);
%set(handles.edit1,'String',MSE);
 
%fprintf('\nMSE: %7.2f ', MSE);
save mse;
 
load mse;
PSNR = 10*log10(256*256/MSE);
%set(handles.edit2,'String',PSNR);
%fprintf('\nPSNR: %9.7f dB', PSNR);
disp(PSNR);
 
 
 
f_g=entropy1(b);
disp('entropy value is')
disp(f_g);
 
 
helpdlg(f_g);
