clc
clear all
close all


[input, pathname] = uigetfile('*.jpg');
if isequal(input,0)
   disp('User selected Cancel')
else
   disp(['User selected ', fullfile(pathname, input)])
end

inpimg=imread(input);

imshow(inpimg)
title('input image ')

%For disk image
red=inpimg(:,:,1);
green=inpimg(:,:,2);
%figure,imshow(green)
%title('green max image ')
black=inpimg(:,:,3);



nefilt=green>130;
binaryImage=nefilt;
% Get rid of stuff touching the border
binaryImage = imclearborder(binaryImage);
fill=imfill(binaryImage,'holes');
 flatten1=strel('disk',6);
diskimg=imdilate(fill,flatten1);
 %figure,imshow(diskimg)
%title('disk image ')



%For the Cup Image
nefilt=green>140;
binaryImage=nefilt;
% Get rid of stuff touching the border
binaryImage = imclearborder(binaryImage);
cup=imfill(binaryImage,'holes');
flatten2=strel('disk',2);
dilate=imdilate(cup,flatten2);
cupimg=dilate;
%figure,imshow(cup)
%title('cup image ')



% Extract only the two largest blobs.
BW=binaryImage ;
CC = bwconncomp(BW);
numPixels = cellfun(@numel,CC.PixelIdxList);
[biggest,idx] = max(numPixels);
BW(CC.PixelIdxList{idx}) = 0;

filteredForeground=BW;
figure, imshow(BW);

binaryImage = imfill(binaryImage, 'holes');
% % Display the binary image.

dis(:,:,1)=immultiply(binaryImage,inpimg(:,:,1));

dis(:,:,2)=immultiply(binaryImage,inpimg(:,:,2));

dis(:,:,3)=immultiply(binaryImage,inpimg(:,:,3));

 


a = diskimg;
stats = regionprops(double(a),'Centroid',...
    'MajorAxisLength','MinorAxisLength');


centers = stats.Centroid;
diameters = mean([stats.MajorAxisLength stats.MinorAxisLength],2);
radii = diameters/2;

% Plot the circles.
 figure,imshow(inpimg)
hold on
viscircles(centers,radii);
hold off


figure
subplot(3,3,1)
imshow(inpimg)
title('input image ')

subplot(3,3,2)
imshow(diskimg,[])
title('disk segment image ')

subplot(3,3,3)
imshow(inpimg)
hold on
viscircles(centers,radii);
hold off
title('Disc boundary')

subplot(3,3,4)
imshow(dilate,[])
title('cup image ')

subplot(3,3,5)
imshow(inpimg)
hold on
viscircles(centers,radii/2);
hold off
title('cup boundary')

c1=bwarea(diskimg);
c2=bwarea(dilate);

cdr=c2./(c1)
rim=(1-dilate)-(1-diskimg);

RDR=bwarea(rim)./(c2);


nn=sprintf('The CDR is  %2f ',cdr)
msgbox(nn)
pause(2)

nn1=sprintf('The RDR is  %2f ',RDR/2)
msgbox(nn1)
pause(2)


if cdr<0.45
    msgbox('NO GLUCOMA')
elseif cdr <0.6 & cdr>0.45
    msgbox('GLUCOMA DETECTED:Medium risk')
    
else cdr>0.6 
    msgbox('GLUCOMA DETECTED:High risk')
end
