function mei = EnergyImage(videoIn)
    [height, width, ~, num_frames] = size(videoIn);
    mei = zeros(height, width);
    
    threshold = 50;  

    for frame_idx = 2:num_frames
        frame_cur = videoIn(:, :, :, frame_idx);
        frame_prev = videoIn(:, :, :, frame_idx - 1);
        
        frame_diff = abs(double(frame_cur) - double(frame_prev));
        
        mask = (frame_diff > threshold);
        
        mei = mei + double(frame_cur) .* mask;
    end
    
    mei = mei / max(mei(:));
end
