% This is a function that convolves an image with 
% a given convolution filter.

function [img1] = myImageFilter(img0, h)

% flip h
h=rot90(h,2);

imgwid=size(img0,2);
imghei=size(img0,1);
img1=zeros(imghei,imgwid);
len=size(h,1);
padsize=0.5*(len-1);
padfig= padarray(img0,[padsize padsize],'replicate');

% show original image
% subplot(1,2,1);
% imshow(padfig);

for i=1:imghei
    for j=1:imgwid
        block=padfig(i:i+len-1,j:j+len-1);
        temp=block.*h;
        img1(i,j)=sum(temp(:));
    end 
end

% show image after applying the filter
% subplot(1,2,2);
% imshow(img1);

end
