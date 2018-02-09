function [Im, Io, Ix, Iy] = myEdgeFilter(img, sigma)
%Smoothing
hsize=2*ceil(3*sigma)+1;
h=fspecial('gaussian',hsize, sigma)
smooth_img=myImageFilter(img,h);

% find gradient
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
%imshow(Im);

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
% imshow(Im);
                
        
        
