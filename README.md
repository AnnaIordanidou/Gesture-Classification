The goal is to classify 4 gestures using the Energy Motion of an image and k-NN. We are given the database containing 4 different gestures.
To solve it, we construct the Energy Image function, which extracts the energy of each image (frame). The function takes as input a video and gives as output a table that 
will store the motion energy. We set a threshold which serves to identify whether small changes in frame rotation are significant to be considered motion.
Values above the threshold will be considered as motion. Then, we calculate the energy by comparing each frame to the previous frame.
We calculate the absolute difference between the current and previous frame to find a measure of the difference in pixel intensity between frames.
Based on this difference, we build a mask where, it will take the value 1 for pixels where the difference is greater than the threshold, indicating that there is motion, 
and when the difference is less than the threshold, the mask takes the value 0 and there is no motion. The energy is given if we multiply in the current frame the mask.
This results in us getting what values only for the pixels where there is motion. We normalize the mei matrix so that the values are between 0 and 1.

