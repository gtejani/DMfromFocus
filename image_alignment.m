function [align_path] = image_alignment(dataset_path)
	addpath('/Users/geetakumari/Downloads/IAT_v0.9.3/')
	iat_setup;
    
    cd(dataset_path) 
    images = dir('*.jpg');
    N = length(images);
    ref = N-1; 
    
    tmp = imread(strcat(dataset_path,num2str(ref),'.jpg')); % reference images for alignment
	path = 'aligned/';

	if ~exist(path, 'dir')
		mkdir(path);
	end

    for i = 1:N
        disp(i-1)
        img = imread(strcat(dataset_path,num2str(i-1),'.jpg'));
        [d1, l1] = iat_surf(img);
        [d2, l2] = iat_surf(tmp);
        [~, ~, imgInd, tmpInd] = iat_match_features_mex(d1, d2, .7);
        X1 = l1(imgInd, 1:2);
        X2 = l2(tmpInd, 1:2);
        %         figure, iat_plot_correspondences(img, tmp, X1', X2');
        X1h = iat_homogeneous_coords (X1');
        X2h = iat_homogeneous_coords (X2');
        [~, ransacWarp]=iat_ransac( X2h, X1h,'affine','tol',.05, 'maxInvalidCount', 100);
        [wimage, ~] = iat_inverse_warping(img, ransacWarp, 'affine', 1:size(tmp,2), 1:size(tmp,1));
        %         figure, iat_plot_correspondences(img, wimage, X1', X2');
        imwrite(uint8(wimage),strcat(path, num2str(i-1), '.jpg'))
        %         tmp = uint8(wimage);
    end
    align_path = strcat(dataset_path, path);
    
    cd .. 
end