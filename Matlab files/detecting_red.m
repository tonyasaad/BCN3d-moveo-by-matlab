vid=videoinput('winvideo',2);
s=serial('COM3','BaudRate',9600); 
answer=1;
set(vid,'FramesPerTrigger',Inf);
set(vid,'ReturnedColorspace','rgb')
while(1)
    data=getsnapshot(vid);
    
    diff_im=imsubtract(data(:,:,1),rgb2gray(data));
    diff_im=medfilt2(diff_im,[3,3]);
    diff_im=im2bw(diff_im,0.18);
    diff_im=bwareaopen(diff_im,300);
    
    bw=bwlabel(diff_im,8);
    
    stats=regionprops(bw,'BoundingBox','Centroid');
    imshow(data);
    
    hold on
    tf=1;
    for(object=1:length(stats))
        bb=stats(object).BoundingBox;
        bc=stats(object).Centroid;
        tf = isempty(bb);
        
    rectangle('Position',bb,'EdgeColor','r','LineWidth',2)
    plot(bc(1),bc(2),'-m+')
    
    end
    if(tf==0)
     fopen(s);
fprintf(s,'%d',answer); 
fclose(s);
       % rectangle('Position',bb,'EdgeColor','r','LineWidth',2)
    end
    
        
    hold off
    
end