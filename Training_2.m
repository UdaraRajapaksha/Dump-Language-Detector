clc;
clear all;
close all;

%open webcam
camList = webcamlist;
cam = webcam(1);
cam.Resolution = '640x360';
%preview webcam
preview(cam);
%button click
answer = questdlg('Confirm?', ...
	'Take Picture', ...
	'OK','Cancel','Cancel');

switch answer
    
    case 'OK' %checking box input
        
        img = snapshot(cam);%capture image

        %close webcam
        clear cam
        image(img);
        
        I2 = imcrop(img,[100 0 400 280]);
        I2 = flipdim(I2 ,2); 
                    
%===============thresholding===========================
        [bw, rgb]=thresholding(I2);
%================= Skin color detection ===========================      
        img=rgb;

    img=rgb2ycbcr(img);
    for i=1:size(img,1)
        for j= 1:size(img,2)
            cb = img(i,j,2);
            cr = img(i,j,3);
            if(~(cr > 132 && cr < 173 && cb > 76 && cb < 156))
                img(i,j,1)=235;
                img(i,j,2)=128;
                img(i,j,3)=128;
            end
        end
    end
    img=ycbcr2rgb(img);
    
  
 %===================================================================== 
       
       bw =im2bw(img); %convert into b&w
       bw = imcomplement(bw);
       bw2 = imfill(bw,'holes'); %filling uncompleted parts/holes
       
       bw3 = imcomplement(bw2);
       
       %bw = imcomplement(bw2);
        imshow(bw2);
        title('Input Image');
        
  
answer = questdlg('Confirm?', ...
	'Proceed to saving', ...
	'OK','Cancel','Cancel');
%take image

switch answer
    
    case 'OK' %checking box input
        
       
        
        c=input('Enter the Class(Number from 1-12)');
        %% Feature Extraction
        F=FeatureStatistical(bw3);
        try 
            load db;
            F=[F  c];
            db=[db; F];
            save db.mat db 
        catch 
            db=[F c]; % 10 12 1
            save db.mat db 
        end

     
  %===============================  
    case 'Cancel'
        
        %close webcam
        clear cam
        %dessert = 0;
    
end

case 'Cancel'
        
        %close webcam
        clear cam
    
end


