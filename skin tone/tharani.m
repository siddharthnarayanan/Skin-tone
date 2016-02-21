function varargout = tharani(varargin)
% THARANI M-file for tharani.fig
%      THARANI, by itself, creates a new THARANI or raises the existing
%      singleton*.
%
%      H = THARANI returns the handle to a new THARANI or the handle to
%      the existing singleton*.
%
%      THARANI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in THARANI.M with the given input arguments.
%
%      THARANI('Property','Value',...) creates a new THARANI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before tharani_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to tharani_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help tharani

% Last Modified by GUIDE v2.5 06-Mar-2011 17:32:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tharani_OpeningFcn, ...
                   'gui_OutputFcn',  @tharani_OutputFcn, ...
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


% --- Executes just before tharani is made visible.
function tharani_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to tharani (see VARARGIN)

% Choose default command line output for tharani
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes tharani wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = tharani_OutputFcn(hObject, eventdata, handles) 
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
    disp(size(a));
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
    %figure;
    axes(handles.axes2);
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
           imshow(Cropped_mask,[]);
           [R C]=size(Cropped_mask);
           M1=mod(R,2);
           if M1==1
               skin_mask = a(New_intr:New_endr-1,New_intc:New_endc-1,:);
           end
           
          disp(size(skin_mask));
           %figure(89);
           axes(handles.axes2);
           imshow(skin_mask);

