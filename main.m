clear all

%% Datasets Paths
balls_dataset = 'PA1_dataset1_balls/';
balls_aligned = 'PA1_dataset1_balls/aligned/';
keyboard_dataset = 'PA1_dataset2_keyboard/';
keyboard_aligned = 'PA1_dataset2_keyboard/aligned/';

%% Results saved
% mkdir('results');
out_dir = 'results/';

%%  Dataset count
cd(keyboard_dataset)
images = dir('*.jpg');
N_key = length(images);
cd ..

cd(balls_dataset)
images = dir('*.jpg');
N_ball = length(images);
cd ..

%% Step 1: Image Alignment Using IAT

if ~exist(balls_aligned,'dir')
    b_path = image_alignment(balls_dataset);
    disp(b_path)
end
if ~exist(keyboard_aligned,'dir')
    k_path = image_alignment(keyboard_dataset);
    disp(k_path)
end

%% Error map

% for keyboard
before_align = rgb2gray(imread(strcat(keyboard_dataset,num2str(N_key-1),'.jpg')) - imread(strcat(keyboard_dataset,num2str(30),'.jpg')));
b_a = figure, imagesc(before_align);
savefig(b_a,strcat(out_dir, 'keyboard_before_align'));
after_align = rgb2gray(imread(strcat(keyboard_aligned,num2str(N_key-1),'.jpg')) - imread(strcat(keyboard_aligned,num2str(30),'.jpg')));
a_a = figure, imagesc(after_align);
savefig(b_a,strcat(out_dir, 'keyboard_after_align'));

% for balls
before_align = rgb2gray(imread(strcat(balls_dataset,num2str(N_ball-1),'.jpg')) - imread(strcat(balls_dataset,num2str(20),'.jpg')));
b_a = figure, imagesc(before_align);
savefig(b_a,strcat(out_dir, 'balls_before_align'));
after_align = rgb2gray(imread(strcat(balls_aligned,num2str(N_ball-1),'.jpg')) - imread(strcat(balls_aligned,num2str(20),'.jpg')));
a_a = figure, imagesc(after_align);
savefig(b_a,strcat(out_dir, 'balls_after_align'));


%% Step 2: Focus Measure

[ball_fm, ball_image] = focal_measure(balls_aligned);
[key_fm, key_image] = focal_measure(keyboard_aligned);
[ball_Mp, ball_Mf] = maxfocusframe(ball_fm);
[key_Mp, key_Mf] = maxfocusframe(key_fm);

key_focus_map = label2rgb(key_Mf); figure, imshow(key_focus_map);
imwrite(key_focus_map, strcat(out_dir, 'focus_map_keyboards.jpg'))
save('results/key_Mf.mat','key_Mf')

ball_focus_map = label2rgb(ball_Mf); figure, imshow(ball_focus_map);
imwrite(ball_focus_map, strcat(out_dir, 'focus_map_balls.jpg'))
save('results/ball_Mf.mat','ball_Mf')

%% Step 3: Graph Cuts
GC_ball = graph_cuts(ball_Mf,N_ball,2,10);
GC_key = graph_cuts(key_Mf,N_key,2,10);

save('results/GC_ball.mat','GC_ball');
g1 = label2rgb(GC_ball+1);
figure, imshow(g1);
imwrite(g1,'results/graph_cut_ball.jpg');

save('results/GC_key.mat','GC_key');
g2 = label2rgb(GC_key+1);
figure, imshow(g2);
imwrite(g2,'results/graph_cut_keyboard.jpg');

%% Step 4: All in Focus Image - Stitching

ball_stitched = uint8(stitching(ball_Mf,ball_image));
ball_stitched_GC = uint8(stitching(GC_ball+1,ball_image));

figure, imshow(ball_stitched); figure, imshow(ball_stitched_GC);
imwrite(ball_stitched, 'results/ball_stitched.jpg');
imwrite(ball_stitched_GC, 'results/ball_stitched_graphcut.jpg');

key_stitched = uint8(stitching(key_Mf,key_image));
key_stitched_GC = uint8(stitching(GC_key+1,key_image));
figure, imshow(key_stitched); figure, imshow(key_stitched_GC);  
imwrite(key_stitched, 'results/keyboard_stitched.jpg');
imwrite(key_stitched_GC, 'results/keyboard_stitched_graphcut.jpg');

figure, imshow(uint8(ball_Mp*256)); 
figure, imshow(uint8(key_Mp*256));

%% Step 5: Depth Refinement Using Median Filter

dref_ball = depth_ref(GC_ball+1);
dref_key = depth_ref(GC_key+1);

figure, imshow(dref_ball);
figure, imshow(dref_key);

imwrite(dref_ball, 'results/depth_ref_ball.jpg');
imwrite(dref_key, 'results/depth_ref_key.jpg');



    


