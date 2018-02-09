function [H, rhoScale, thetaScale] = ...
    myHoughTransform(Im, threshold, rhoRes, thetaRes)
%Your implementation here
%Im - grayscale image - 
%threshold - prevents low gradient magnitude points from being included
%rhoRes - resolution of rhos - scalar
%thetaRes - resolution of theta - scalar

imgwid=size(Im,2);
imghei=size(Im,1);
thetaRes=thetaRes*0.5;
small_idx= Im<threshold;
Im(small_idx)=0;
% Im(~small_idx)=1;
% imshow(Im);
diag=sqrt(imgwid^2+imghei^2);

theta_siz=int32(pi/thetaRes);
rho_siz=int32(2*diag/rhoRes);
H=zeros(rho_siz,theta_siz);

for i=1:theta_siz
    thetaScale(i,1)=double(((i-1)*(thetaRes*180/pi)+1))*pi/180-0.5*pi;
    % from -pi/2 to pi/2
end

for j=1:rho_siz
    rhoScale(j,1)=double((j-1)*rhoRes-diag+1);
    % from -max to max
end

for i=1:imghei
    for j=1:imgwid
        if (Im(i,j)~=0)
            for theta=-0.5*pi:thetaRes:0.5*pi
                rho=(j*cos(theta)+i*sin(theta));       
  
               theta_idx=int32((theta+0.5*pi)/thetaRes);
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

end
        
        
