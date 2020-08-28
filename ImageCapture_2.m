clc;
clear all;
close all;

%open webcam
camList = webcamlist;
cam = webcam(1)
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
       bw = imfill(bw,'holes'); %filling uncompleted parts/holes
       
        imshow(bw);
        %bw2 = imcomplement(bw);
        imwrite(bw,'C:\Users\Acer\Desktop\DIP 2\project\tempImage.png');

        fname=strcat('C:\Users\Acer\Desktop\DIP 2\project\', 'tempImage.png');
        im=imread(fname);
        
        imshow(im);

        title('Test Image');
        %% Find the class the test image belongs
        Ftest=FeatureStatistical(im);
        %% Compare with the feature of training image in the database
        load db.mat
        Ftrain=db(:,1:2);
        Ctrain=db(:,3);
        for (i=1:size(Ftrain,1));
            dist(i,:)=sum(abs(Ftrain(i,:)-Ftest));
        end   
        m=find(dist==min(dist),1);
        det_class=Ctrain(m);
        %msgbox(strcat('Name Class=',num2str(det_class)));

        if det_class == 1 
            f = msgbox('B','Character');
        elseif det_class == 2
            f = msgbox('D','Character');
        elseif det_class == 3
            f = msgbox('V','Character');
        else
            f = msgbox('Other','Character'); 
        end

    
    case 'Cancel'
        
        %close webcam
        clear cam
    
end





