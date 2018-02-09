function [rhos, thetas] = myHoughLines(H, nLines)
%Your implemention here

Hhei=size(H,1);
Hwid=size(H,2);

H1=H;
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



[~,idx]=sort(H(:),'descend');
idx=idx(1:nLines,1);
rhos=zeros(nLines,1);
thetas=zeros(nLines,1);


for i=1:nLines
    thetas(i,1)=floor(idx(i,1)/Hhei)+1;
    rhos(i,1)=rem(idx(i,1),Hhei);
%     thetas(i,1)=thetaScale(thetas_idx(i,1));
%     rhos(i,1)=rhoScale(rhos_idx(i,1));
end

 
 

end
        