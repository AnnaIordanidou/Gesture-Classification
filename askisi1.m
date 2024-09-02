clear all; clc;

top_dir = 'C:\\Users\\Άννα\\Desktop\\exer3\\dhp_marcel\\';

gesture_dirs = {'Clic', 'No', 'Rotate', 'StopGraspOk'};

gesture_MEIs = struct();

for g = 1:length(gesture_dirs)
    seq_folders = dir(fullfile(top_dir, gesture_dirs{g}, 'Seq*'));

    gesture_MEIs.(gesture_dirs{g}) = cell(1, length(seq_folders));
    
    for s = 1:length(seq_folders)
        video_file = fullfile(seq_folders(s).folder, seq_folders(s).name, 'output.avi');
        

        video = VideoReader(video_file);
        
        num_frames = video.NumFrames;
        
        video_frames = zeros(video.Height, video.Width, 3, num_frames);
        
        for i = 1:num_frames
            video_frames(:, :, :, i) = read(video, i);
        end
        
        mei = EnergyImage(video_frames);
        
        gesture_MEIs.(gesture_dirs{g}){s} = mei;
    end
end

training_features = [];
training_labels = [];
test_features = [];
test_labels = [];

for g = 1:length(gesture_dirs)
    for s = 1:length(gesture_MEIs.(gesture_dirs{g}))
        mei = gesture_MEIs.(gesture_dirs{g}){s};
        
        if s <= 5
            training_features = [training_features; mei(:)'];
            training_labels = [training_labels; repmat(gesture_dirs(g), size(mei(:)', 1), 1)];
        else
            test_features = [test_features; mei(:)'];
            test_labels = [test_labels; repmat(gesture_dirs(g), size(mei(:)', 1), 1)];
        end
    end
end

k = 3;  
knn_model = fitcknn(training_features, training_labels, 'NumNeighbors', k);
predicted_labels = predict(knn_model, test_features);

confusion_matrix = confusionmat(test_labels, predicted_labels);

figure;
confusionchart(confusion_matrix, gesture_dirs, 'Normalization', 'row-normalized');
title('Confusion Matrix');
disp(confusion_matrix);

figure;
for g = 1:length(gesture_dirs)
    gesture = gesture_dirs{g};
    gesture_MEIs_seq = gesture_MEIs.(gesture);
    
    for s = 1:5
        subplot(length(gesture_dirs), 5, (g-1)*5 + s);
        imagesc(gesture_MEIs_seq{s});
        title(['Gesture: ', gesture, ', Seq: ', num2str(s)]);
        axis off;
    end
end