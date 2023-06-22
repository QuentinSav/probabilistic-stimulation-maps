# Abstract

Deep brain stimulation (DBS) is a medical therapy that consist in inducing a pulsed voltage in deep brain tissues using electrodes. This process will be inhibiting or exciting the neurons located in that region. One of the major indication of this therapy is the Parkinson’s disease (PD), for which the best stimulation targets are the subthalamic nucleus (STN) and the internal globus pallidus. In clinical routine, the search of the optimal stimulation parameters is a time consuming (up to 8 hours per patient) trial-and-error process. The clinical need is to find method of DBS parameters optimization and go toward fully automated programming.
Previous studies developed methods using FEA-based estimation of the volume of tissue activated (VTA) and processing voxel-wise significance tests to find a sweet spot. They could demonstrate that it positively correlates with clinical improvement. This work aimed to refine existing probabilistic stimulation maps.
The state-of-the-art methods were implement in a MATLAB class allowing fast implementation of new algorithms. A multicentric dataset of PD-STN patients from Bern and Cologne centers was used to train and test the models. Proposed method consisted in regularized voxel-wise regression and classification models. The state of the art and proposed methods were assessed using a 10-fold cross-validation. The coefficient of determination (R2) between the ground truth and the predictions was used measure the quality of the models. 
The overall model comparison showed that the best model was a adaptation of the logistic regression to be used as a regression model with a median R2 value of 0.39. Voxel-wise regression analysis performed better than the previous sweet spot mapping methods. 
Sweet spot mapping method are very dependent on the dataset and all groups seem to have a sweet spot generation method adapted to their own dataset. The proposed approach for probabilistic stimulation mapping may be a more complex and less instinctive approach than the previous approach with sweet spot but provides better estimation of the clinical outcome. It is very likely that further analysis using deep learning methods may further refine the maps. 

# Results
## Clinical improvement predictors

| <img src="https://github.com/QuentinSav/probabilistic-stimulation-maps/assets/61971430/a2fc89f0-f6b6-4634-b588-a2e043fc5982"  width="60%" height="60%">|
|:---:|
|10-fold cross-validation summary of the probabilistic stimulation mapping methods (sweet spot methods in green, non-regularized linear regression in red, proposed approaches in blue)|

## Full effect - Partial effect classifiers

| <img src="https://github.com/QuentinSav/probabilistic-stimulation-maps/assets/61971430/a0517dac-2bd2-4d56-a052-0a899f91f607"  width="90%" height="90%">| <img src="https://github.com/QuentinSav/probabilistic-stimulation-maps/assets/61971430/a0517dac-2bd2-4d56-a052-0a899f91f607"  width="90%" height="85%"> |
|:---:|:---:|
|ROC Curve for all cross-validation folds of the logistic regression classifier|ROC Curve for all cross-validation folds of the logistic regression classifier preprocessed with PCA|

The results obtained by the classification models were very promising. The logistic regression classifier (on the left) obtained an accuracy of 77%, with a true positive rate of 78% and a true negative rate of 73%. The logistic regression classifier preprocessed with PCA (on the right) also obtained an accuracy of 77%. The true positive rate of 78% and a true negative rate of 75%. It is interesting to note that the model preprocessed with the principal component analysis rely much more on the amplitude feature with a coefficient $\beta_{amp} = 3.54$ while the non preprocessed model had a coefficient of $\beta_{amp} = 0.34$. The model non preprocessed by a PCA developed a better anatomical understanding than the preprocessed one. The principal component analysis seems to have given a very large weight to the stimulation amplitude feature, and the model relies mainly on this one. With equal accuracy, a model that learned better the voxel importance is to be preferred. 

## Exemple of model coefficient plotted in the template space

| <img src="https://github.com/QuentinSav/probabilistic-stimulation-maps/assets/61971430/219c985c-195a-48b9-a897-4189ea0486d1"  width="80%" height="80%"> | <img src="https://github.com/QuentinSav/probabilistic-stimulation-maps/assets/61971430/9ed556ce-47b2-4b9d-9338-4195c4d3d7d6"  width="80%" height="80%"> | <img src="https://github.com/QuentinSav/probabilistic-stimulation-maps/assets/61971430/4995ba85-0c42-4794-bd49-b8e6d91a4abc"  width="80%" height="80%"> |
|:---:|:---:|:---:|
|Sagital slice (x = 12mm)|Coronal slice (y = −15mm)|Axial slice (z = −8mm)|
