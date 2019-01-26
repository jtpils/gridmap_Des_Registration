function test()
    % The test function gives an example of keypoint extraction using the
    % methods :
    % - Harris
    % - SUSAN
    % - LoG (Laplacian of Gaussian)
    % - Harris-Laplace
    % - Gilles
    %
    % Example
    % =======
    % test();

    % Harris
%     img = imread('test.jpg');
%     pt  = kp_harris(img);
%     draw(img,pt,'Harris');

    % SUSAN
 %   img = imread('test.pgm');
 %   pt  = kp_susan(img);
 %   draw(img,pt,'SUSAN');

    % LoG Lindeberg
%    img = imread('sunflower.jpg');
%    pt  = kp_log(rgb2gray(img));
%    draw(img,pt,'LoG Lindeberg');

    % Harris-Laplace
   img = imread('../Fr2_5.png');
   pt  = kp_harrislaplace(rgb2gray(img));
   draw(img,pt,'Harris Laplace');

    % Gilles
%    img = imread('patrol.jpg');
 %   pt  = kp_gilles(rgb2gray(img));
 %   draw(img,pt,'Gilles');

end

