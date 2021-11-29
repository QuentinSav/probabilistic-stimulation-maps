# 2008_BetterMaps

MATLAB Class to handle Probabilistic Stimulation Map (PSM). It currently includes the following algorithms:

- Nguyen, 2019:
    - **VTA reslicing filtering method:**   Rounded
    - **Features:**                         Activated voxels coordinates
                                            VTA index
                                            Weights ( = 1)
                                            Efficiencies 
    - **Image computation:**                N-Image
                                            Mean-Image
                                            Efficiency array image
    - **Statistical test:**                 Wilcoxon signrank test (with null hypothesis 0)                         
    - **Type 1 error correction:**          Benjamini-Hochberg
    - **Significant mean image computation**
    - **Sweetspot computation** 

    - **Validation method:**                5-Folded cross-validation

- Dembek, 2019
    - VTA reslicing filtering method: Rounded

- Reich, 2019
    - 
    - 

TODO:
- [x] Finish the implementation of the Dembek, 2019 pipeline (without permutation tests)
- [x] Finish the implementation of Reich, 2019
- [x] Gitignore the asv files
- [x] Integrate the psm constructor additional filters
- [ ] Implement permutation tests from Dembek, 2019
- [ ] Implement the Genovese formulation for the Benjamini-Hochberg type 1 error correction of Nguyen, 2019
    
