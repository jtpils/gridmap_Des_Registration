function example(testset)
    clc;
    if(testset > 4)
        testset=4;
    elseif(testset<1)
        testset=1;
    end
    if(testset == 1)
        files = { 'TestImages/demo1.png'
             'TestImages/demo2.png'
             };
    elseif(testset == 2)
        files = { 'TestImages/green_nature1.jpg'
             'TestImages/green_nature2.jpg'
             };
    elseif(testset == 3)
        files = { 'TestImages/PICT0107a.jpg'
             'TestImages/PICT0108a.jpg'
             };
    elseif(testset == 4)
        files = { 'TestImages/PICT0126a.png'
             'TestImages/PICT0127a.png'
             };
    end
    I1=imread(files{1});
    I2=imread(files{2});

    [matchedPts1, matchedPts2] = SURFFeat(I1,I2);
    [im_stitchedH, stitched_maskH, im1TH, im2TH]=pano(I1, I2, matchedPts1, matchedPts2);
    figure;
    imshow(im_stitchedH);

    im_stitchedH2=im_stitchedH;
    for i = 3:length(files)
        close all;
        I3=imread(files{i});
        [matchedPts1, matchedPts2] = SURFFeat(im_stitchedH, I3);
        im_stitchedH2=pano(im_stitchedH, I3, matchedPts1, matchedPts2, stitched_maskH);
        figure;
        imshow(im_stitchedH2);
    end
    if(testset == 1)
        imwrite(im_stitchedH2,'results/demo_result.jpg');
    elseif(testset == 2)
        imwrite(im_stitchedH2,'results/green_nature.jpg');
    elseif(testset == 3)
        imwrite(im_stitchedH2,'results/UCFA_College.jpg');
    elseif(testset == 4)
        imwrite(im_stitchedH2,'results/UCFA_Lake.jpg');
    end
end
%I1=imread('D:\code\matlab\pandemo\performFolderDemo/a.jpg');
%I2=imread('D:\code\matlab\pandemo\performFolderDemo/b.jpg');
%stitched_maskH = imread('mask.jpg');
%stitched_maskH = rgb2gray(stitched_maskH);


%  I1=imread('TestImages/20100228376.jpg');
%  I2=imread('TestImages/20100228377.jpg');
%  I1=imread('TestImages/demo1.png');
%  I2=imread('TestImages/demo2.png');