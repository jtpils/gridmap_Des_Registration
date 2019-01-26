function [im_stitchedH, stitched_maskH, im1TH, im2TH] = pano(I1, I2, matchedPts1, matchedPts2, stitched_maskH)

    [T, best_pts,num_inliners, pt_inliners] = ransac(matchedPts2, matchedPts1, 5);     
    
    figure('name','RANSAC');
    subH3=subplot(1,2,1); imshow(I1)
    subH4=subplot(1,2,2); imshow(I2);
    txt=sprintf('%d matched points left after RANSAC.',num_inliners);
    text(.1,.5,txt);
    for i=1 : num_inliners
      c=rand(1,3);
      h=impoint(subH3, pt_inliners(i,1), pt_inliners(i,2)); setColor(h,c);
      h=impoint(subH4, pt_inliners(i,3), pt_inliners(i,4)); setColor(h,c);
    end
    
    if nargin < 5
        [im_stitchedH, stitched_maskH, im1TH, im2TH] = stitch(I1, I2, T);
    else
        [im_stitchedH, stitched_maskH, im1TH, im2TH] = stitch(I1, I2, T, stitched_maskH);
    end
    

end