%[file,path] = uigetfile('*.jpg','*.png','Pick an Image File');
%if isequal(file,0) | isequal(path,0)
   % warndlg('User Pressed Cancel');
%else
    a = imread('face3.jpg');
    %a=imresize(a,[256 256]);
   % [r c p] = size(a);
   %55axes(handles.axes1);
    %imshow(a);
    %handles.a=a;
    %disp(size(a));
    %guidata(hObject, handles);

HSV=rgb2hsv(a);
HSV(:,:,1) = HSV(:,:,1)*360;

[r c p]=size(a);
h = HSV(:,:,1);
s = HSV(:,:,2);
v = HSV(:,:,3);
[r c p]=size(a);disp(size(a));
d=zeros(r,c);
for i=1:r;
    for j=1:c;
        if ((h(i,j)<45)&((s(i,j)<0.68)& (s(i,j)>0.25)))
            d(i,j)=1;
        end
    end
end
d = medfilt2(d,[3 3]);
figure(56)
    imshow(d);
 
  f=imcrop(d,[71 87 179 200]);
  figure(23)
  imshow(f)