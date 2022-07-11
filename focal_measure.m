function [fm, image] = focal_measure(path) % calculates focus of all images 
    cd(path) 
    images = dir('*.jpg');
    N = length(images);
    cd ..
    cd ..
    image = [];
    fm = [];
    for i = 1:N
        img = imread(strcat(path,num2str(i-1),'.jpg'));
        image = cat(4,image,img);
        f = FocusMeasure(img,N); 
        fm = cat(4,fm, f);
    end    
end
% calculate focus of one image
function [fm] = FocusMeasure(img,N)

[r,c,~] = size(img);

% Sigmas defined for balls
if (N==25)
    sig1 = 0.000000000000009;
    sig2 = 0.010000000001;
end

% Sigmas defined For keyboard
if (N==32)
    sig1 = 0.001;
    sig2 = 0.00998;
end
% OTF calculation
ky = -64.0;
for i = 1:c
    kx = -36.0;
    for j = 1:r
       OTF(i,j) = exp(-sig1*kx^2 - sig1*ky^2) - exp(-sig2*kx^2 - sig2*ky*ky);
       kx = kx + .1 ;
    end
    ky = ky+.1;
end

max1 = max(max(OTF));
scale = 1.0/max1;
OTF = OTF.*scale;

f1=fftshift(fft2(img));
max1 = max(max(f1));
f1 = f1.*(1.0/max1);
% OTF convolution with intensity spectrum function
f2 = f1.*OTF';
h = ifft2(f2);
max1 = max(max(h));
fm = h.*(1.0/max1);

end
