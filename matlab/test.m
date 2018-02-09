clc;
clear;
close all hidden;

img = imread('../data/img01.jpg');
img = double(img) / 255;

% h=1/121*ones(11,11);
% img1 = myImageFilter(img, h);
sigma=2;
threshold = 0.03;
rhoRes    = 2;
thetaRes  = pi/90;
nLines    = 50;

hsize=2*ceil(3*sigma)+1;
h=fspecial('gaussian', hsize, sigma);
smooth_img=myImageFilter(img,h);

sobel_x=fspecial('sobel')';
sobel_y=fspecial('sobel');
Ix=myImageFilter(smooth_img,1/8*sobel_x);
Iy=myImageFilter(smooth_img,1/8*sobel_y);
Im=sqrt(Ix.^2 + Iy.^2);
Io=atan(Iy./Ix);


% convert the gradiant angle into 4 cases
imgwid=size(img,2);
imghei=size(img,1);
num1=22.5/180*pi;
num2=67.5/180*pi;
num3=90/180*pi;

Io(1,:)=0; Io(:,1)=0;
Io(imghei,:)=0; Io(:,imgwid)=0;
Im(1,:)=0; Im(:,1)=0;
Im(imghei,:)=0; Im(:,imgwid)=0;
Imm=Im;
for i=2:imghei-1
    for j=2:imgwid-1
        m=Io(i,j);
        mm=Im(i,j);
        
         if ((m>num1&&m<num2))
            Io(i,j)=45;
            if (Im(i+1,j+1)>mm||Im(i-1,j-1)>mm)
                Imm(i,j)=0;
            end
         
        
         elseif ((m<=num1)&&(m>=-num1))
            Io(i,j)=0;
            if (Im(i,j+1)>mm||Im(i,j-1)>mm)
                Imm(i,j)=0;
            end
     
 
         elseif ((m>num2&&m<=num3)||(m>=-num3&&m<-num2))
            Io(i,j)=90;
            if (Im(i+1,j)>mm||Im(i-1,j)>mm)
                Imm(i,j)=0;
            end
  
         elseif((m>-num2&&m<-num1))
            Io(i,j)=135;
            if (Im(i-1,j+1)>mm||Im(i+1,j-1)>mm)
                Imm(i,j)=0;
            end
         else 
             Imm(i,j)=0;
         end 
    end
end

Im=Imm;

%hough transform
small_idx= Im<threshold;
Im(small_idx)=0;
% Im(~small_idx)=1;
diag=sqrt(imgwid^2+imghei^2);

theta_siz=int32(pi/thetaRes);
rho_siz=int32(2*diag/rhoRes);
H=zeros(rho_siz,theta_siz);

for i=1:theta_siz
    thetaScale(i,1)=double(((i-1)*(thetaRes*180/pi)+1))*pi/180-pi/2;
end

for j=1:rho_siz
    rhoScale(j,1)=double((j-1)*rhoRes-diag+1);
end

for i=1:imghei
    for j=1:imgwid
        if (Im(i,j)~=0)
            for theta=-0.5*pi:thetaRes:pi*0.5
                rho=j*cos(theta)+i*sin(theta);       
               
               theta_idx=int32((theta+0.5*pi)/thetaRes);
%                 theta_idx=int32(theta/thetaRes);
                if (theta_idx==0)
                    theta_idx=1;
                end
                
                rho_idx=int32((rho+diag)/rhoRes);  
                 if (rho_idx==0)
                    rho_idx=1;
                 end
                 
                H(rho_idx,theta_idx)=H(rho_idx,theta_idx)+1;
            end

        end
    end
end

% finding lines

Hhei=size(H,1);
Hwid=size(H,2);

H1=H;
H2=H;
% for corners
if (H(1,2)>H(1,1)||H(2,2)>H(1,1)||H(2,1)>H(1,1))
    H1(1,1)=0;
end
if (H(1,Hwid-1)>H(1,Hwid)||H(2,Hwid)>H(1,Hwid)||...
        H(2,Hwid-1)>H(1,Hwid))
    H1(1,Hwid)=0;
end
if (H(Hhei-1,1)>H(Hhei,1)||H(Hhei-1,2)>H(Hhei,1)||...
        H(Hhei,2)>H(Hhei,1))
    H1(Hhei,1)=0;
end
if (H(Hhei-1,Hwid)>H(Hhei,Hwid)||H(Hhei-1,Hwid-1)>H(Hhei,Hwid)||...
        H(Hhei,Hwid-1)>H(Hhei,Hwid))
    H1(Hhei,Hwid)=0;
end

% for edges
for i=1
    for j=2:Hwid-1
    val=H(i,j);
        if (H(i+1,j)>val||H(i,j+1)>val||H(i,j-1)>val||...
                H(i+1,j+1)>val||H(i+1,j-1)>val)
            H1(i,j)=0;
        end
    end
end

for i=Hhei
    for j=2:Hwid-1
         val=H(i,j);
         if (H(i-1,j)>val||H(i,j+1)>val||...
                H(i,j-1)>val||H(i-1,j+1)>val||H(i-1,j-1)>val)
            H1(i,j)=0;
         end
    end
end

for i=2:Hhei-1
    for j=1
        val=H(i,j);
        if (H(i+1,j)>val||H(i-1,j)>val||H(i,j+1)>val||...
               H(i+1,j+1)>val||H(i-1,j+1)>val)
            H1(i,j)=0;
        end
    end
end

for i=2:Hhei-1
    for j=Hwid
        val=H(i,j);
        if (H(i+1,j)>val||H(i-1,j)>val||H(i,j-1)>val||...
                H(i+1,j-1)>val||H(i-1,j-1)>val)
            H1(i,j)=0;
        end
    end
end



% for centre points
for i=2:Hhei-1
    for j=2:Hwid-1
        val=H(i,j);
        if (H(i+1,j)>val||H(i-1,j)>val||H(i,j+1)>val||...
                H(i,j-1)>val||H(i+1,j+1)>val||H(i+1,j-1)>val||...
                H(i-1,j+1)>val||H(i-1,j-1)>val)
            H1(i,j)=0;
        end
    end
end
H=H1;
% H(1,:)=0;H(Hhei,:)=0;
% H(:,1)=0;H(:,Hwid)=0;

[value,idx]=sort(H(:),'descend');
value=value(1:nLines);
idx=idx(1:nLines);
rhos=zeros(nLines,1);
thetas=zeros(nLines,1);

for i=1:nLines
    thetas(i,1)=floor(idx(i,1)/Hhei)+1;
    rhos(i,1)=rem(idx(i,1),Hhei);
end

figure;
plot(thetas,rhos,'ro');
hold on;
P=houghpeaks(H2,50);
plot(P(:,2),P(:,1),'b*');




























