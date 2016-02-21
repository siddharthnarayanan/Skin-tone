function varargout = guinew123(varargin)
% GUINEW123 M-file for guinew123.fig
%      GUINEW123, by itself, creates a new GUINEW123 or raises the existing
%      singleton*.
%
%      H = GUINEW123 returns the handle to a new GUINEW123 or the handle to
%      the existing singleton*.
%
%      GUINEW123('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUINEW123.M with the given input arguments.
%
%      GUINEW123('Property','Value',...) creates a new GUINEW123 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guinew123_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guinew123_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guinew123

% Last Modified by GUIDE v2.5 18-Mar-2011 00:03:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guinew123_OpeningFcn, ...
                   'gui_OutputFcn',  @guinew123_OutputFcn, ...
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


% --- Executes just before guinew123 is made visible.
function guinew123_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guinew123 (see VARARGIN)

% Choose default command line output for guinew123
handles.output = hObject;
a=ones([256,256]);
axes(handles.axes1);
imshow(a)
axes(handles.axes2);
imshow(a);


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes guinew123 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = guinew123_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
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
    %disp(size(a));
    guidata(hObject, handles);
end

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
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

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
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
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
skin_mask=handles.skin_mask;
temp_img = skin_mask(:,:,3);
%temp_img=rgb2gray(skin_mask);
figure(15),imshow(temp_img);
handles.temp_img=temp_img;
guidata(hObject, handles);
% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp_img=handles.temp_img;
[ll lh hl hh]=dwt2(temp_img,'haar');
dwt_img = [ll lh;hl hh];
figure(12)
imshow(dwt_img,[]);
handles.dwt_img=dwt_img;
handles.ll=ll;
handles.lh=lh;
handles.hl=hl;
handles.hh=hh;
guidata(hObject, handles);
% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[logo_file logo_path] = uigetfile('*.bmp;*.jpg','Pick a logo image');
if logo_file==0
    warndlg('cancel');
else
    s=imread(logo_file);
s=imsubtract(s,[150]);
s=imresize(s,[128 128]);
figure(567),
imshow(s);
end
handles.s=s;
ll =handles.ll;
lh =handles.lh;
hl =handles.hl;
hh =handles.hh;
logo_im = imresize(rgb2gray(s),[40 40]);
[rows_logo cols_logo] = size(logo_im);
len_logo = rows_logo*cols_logo;
[rows_hh cols_hh] = size(hh);
len_hh = rows_hh*cols_hh;
hh = hh(:);
logo_im = logo_im(:);

hh(1:len_logo) = logo_im;
hh = reshape(hh,[rows_hh cols_hh]);
helpdlg('embedding process has done');
handles.ll=ll;
handles.lh=lh;
handles.hl=hl;
handles.hh=hh;
handles.len_logo=len_logo;
handles.rows_logo=rows_logo;
handles.cols_logo=cols_logo;
guidata(hObject, handles);

% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
New_intr=handles.New_intr;
New_endr=handles.New_endr;
New_intc=handles.New_intc;
New_endc=handles.New_endc;
a=handles.a;
ll =handles.ll;
lh =handles.lh;
hl =handles.hl;
hh =handles.hh;
skin_mask=handles.skin_mask;
%==
%take idwt
emb_cropim = idwt2(ll,lh,hl,hh,'haar');
figure,imshow(emb_cropim,[]);title('inverse transformed image');
skin_mask(:,:,3) = emb_cropim;
figure,imshow(skin_mask,[]);

%X=a(New_intr:New_endr-1,New_intc:New_endc-1,:);
guidata(hObject, handles);


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
New_intr=handles.New_intr;
New_endr=handles.New_endr;
New_intc=handles.New_intc;
New_endc=handles.New_endc;
skin_mask=handles.skin_mask;
a=handles.a;
inp_img = a;
inp_img(New_intr:New_endr-1,New_intc:New_endc-1,:) = skin_mask;
axes(handles.axes2);
imshow(inp_img);
title('reconstruted image');
handles.inp_img=inp_img;
guidata(hObject, handles);

% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
New_intr=handles.New_intr;
New_endr=handles.New_endr;
New_intc=handles.New_intc;
New_endc=handles.New_endc;
inp_img=handles.inp_img;
%Recon_im=handles.Recon_im;
c=inp_img(New_intr:New_endr-1,New_intc:New_endc-1,:);

figure(45);
imshow(c);
title('Recropped Image');
handles.c=c;
guidata(hObject, handles);



% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
c=handles.c;

ex_temp_img = c(:,:,3);
[ll1 lh1 hl1 hh1] = dwt2(ex_temp_img,'haar');
d=[ll1 lh1 hl1 hh1];
figure(456)
imshow(d,[]);

handles.hh1=hh1;
guidata(hObject, handles);

% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

New_intr=handles.New_intr;
New_endr=handles.New_endr;
New_intc=handles.New_intc;
New_endc=handles.New_endc;
%a=handles.a;
a=handles.a;
s=handles.s;
ll=handles.ll;
lh=handles.lh;
hl=handles.hl;
hh=handles.hh;
skin_mask=handles.skin_mask;
logo_im = imresize(rgb2gray(s),[40 40]);
[rows_logo cols_logo] = size(logo_im);
len_logo = rows_logo*cols_logo;
[rows_hh cols_hh] = size(hh);
len_hh = rows_hh*cols_hh;
hh = hh(:);
logo_im = logo_im(:);

hh(1:len_logo) = logo_im;
hh = reshape(hh,[rows_hh cols_hh]);
%axes(handles.five);
%set(handles.t5,'string','embedding');
%imshow(hh);

emb_cropim = idwt2(ll,lh,hl,hh,'haar');
%axes(handles.three);
%set(handles.t3,'string','dwt image');
%imshow(emb_cropim,[]);
skin_mask(:,:,3) = emb_cropim;
%axes(handles.four);
%5set(handles.t4,'string','123');
%imshow(skin_mask,[]);

inp_img = a;
inp_img(New_intr:New_endr-1,New_intc:New_endc-1,:) = skin_mask;
%axes(handles.two);
%set(handles.t2,'string','stego image');
%figure(12)
%imshow(inp_img);

ex_img = inp_img(New_intr:New_endr-1,New_intc:New_endc-1,:);
ex_temp_img = ex_img(:,:,3);
[ll1, lh1, hl1, hh1] = dwt2(ex_temp_img,'haar');
hh1 = hh1(:);
ex_logo_img = hh1(1:len_logo);
ex_logo_img = reshape(ex_logo_img,[rows_logo cols_logo]);

%axes(handles.one);
%set(handles.t1,'string','extracted  image');
imshow(ex_logo_img,[]);



handles.len_logo=len_logo;
handles.rows_logo=rows_logo;
handles.cols_logo=cols_logo;
% Update handles structure
guidata(hObject, handles);



[R C]=size(a);
MSE=sum(sum((a(:,:,3) - inp_img(:,:,3)).^2))/(R*C);
 set(handles.edit1,'string',MSE);
%%%%%%%%%%%%%%%%%%PSNR%%%%%%%%%%%
disp('MSE value is');
disp(MSE);
PSNR = 10*log10(255*255/MSE);
 set(handles.edit2,'string',PSNR);
disp('PSNR value is : ');
disp(PSNR);
disp(' db');




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


