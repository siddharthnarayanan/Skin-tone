clear all;
clc;

a=imread('face1.jpg');
HSV=rgb2hsv(a);
HSV(:,:,1) = HSV(:,:,1)*360;
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
    imshow(d);
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
           figure;
           imshow(Cropped_mask,[]);
           title('cropped mask');
           [R C]=size(Cropped_mask);
           M1=mod(R,2);
           if M1==1
               skin_mask = a(New_intr:New_endr-1,New_intc:New_endc-1,:);
           end
           
          disp(size(skin_mask));
           figure;
           
           imshow(skin_mask);
           
           a(New_intr:New_endr-1,New_intc:New_endc-1,:)==a(New_intr:New_endr-1,New_intc:New_endc-1,:);
           imshow(a);
           
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%555
     
      minvalue=15;
maxvalue=240;

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

[r c]=size(histmod);

        [w e kl t]=dwt2(histmod,'haar');
        g=[w e;kl t];
        figure(5678)
        imshow(g,[]);
        
        
        
        keygener=zeros(8,8);
key=[0 0 1 0 ;0 0 1 1 ;0 1 0 1; 0 1 1 1; 1 0 0 0; 1 0 1 0; 1 1 0 1; 1 0 1 1];
key1=[0 0 1 0 0 0 1 0 ;0 0 1 1 0 0 1 1 ;0 1 0 1 0 1 0 1; 0 1 1 1 0 1 1 1];
keygener(1:8,5:8)=key;
keygener(5:8,1:8)=key1;
orig_key=keygener;
        
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
[r c]=size(r);
for i=1:8:r-7;
    for j=1:8:c-7;
       block3(ii,jj)=w;
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
       w=block3;
        w=abs(w);
        if count>totalbits;
            break;
        end
    end
    if count>totalbits;
        break;
    end
end
o=w;
figure(90)
imshow(o);


as = idwt2(w,e,kl,t,'haar'); 
as = uint8(as); %convert back to uint8 as the image can be displayed as uint8 format only 
 
Z=as;
figure(2); 
imshow(Z,[]); title('Inverse DWT'); 


%Z=handles.Z;
%New_intr=handles.New_intr;
%New_endr=handles.New_endr;
%New_intc=handles.New_intc;
%New_endc=handles.New_endc;
%a=handles.a;
X=a(New_intr:New_endr-1,New_intc:New_endc-1,:);
%X=Z;
%axes(handles.axes2);
%Recon_im=a;
figure(678),
imshow(X);
title('Reconstructed image');














  
