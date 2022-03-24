# TODO:
## Report
  - [ ] Write DBS introduction
  
## Map computation
  - [x] Solve the transformation issue
  - [x] Create datasets for right and left hemisphere
  - [ ] Implement 10 fold cross validation for the map computation
  - [ ] Create a new map with logistic regression
  - [ ] Create a new map with elastic net

## Optimization
  - [x] Add location column in table
  - [x] Create a first version of the map
  - [X] Implement the method from Simon to link the VTA diameter to the stim. amplitude
  - [X] Create the integration function
  - [X] Create GroundTruth best contact array for each lead
  - [X] Issue with the table, electrode center exists only for the first 50 samples
  - [X] Create a map with the intercept and amplitude terms
  - [ ] Extend optimization for best contact
  - [ ] Implement function to correctly filter table (remove leads with not enough samples)
  - [ ] Box plot of the error
  - [ ] Create table with electrode center by adding cologne data
## Visualization
  - [x] Add the coordinate frame in the figure
  - [ ] Center the white color to zero coefficient values
  - [ ] Finish adaptation of Khoa code from Tremor paper
  - [x] Add the STN shape in map plotting
## State of the art implementation
  - [x] Finish the implementation of the Dembek, 2019 pipeline (without permutation tests)
  - [x] Finish the implementation of Reich, 2019
  - [x] Gitignore the asv files
  - [x] Integrate the psm constructor additional filters
  - [x] Implement permutation tests from Dembek, 2019
  - [ ] Implement the Genovese formulation for the Benjamini-Hochberg type 1 error correction of Nguyen, 2019
  - [X] Implement the exe_computeSweetSpot with method 'percentile' and 'largest cluster'

# Random thoughts:

Permutation test for non independent variables!!!???
https://stats.stackexchange.com/questions/400118/what-glm-family-and-link-function-to-use-with-similarity-index-as-response-varia

–> permutation tests of independence

What are the exact assumption behind the logistic regression ? Could Generalized linear model be a solution? 


From which distribution comes p(y|x:θ) from???? normal, gamma?
- Logistic regression make the assumption that it comes from Bernoulli?




Problem with the logistic regression model:
-	assumption about the data independence –> need to perform permutation tests.
- 	the clinical score (efficiency) is not contained in [0, 1], it just appends because of our dataset.
- 	 p(y|x:θ) does not comes from Bernoulli distribution because it is not discrete