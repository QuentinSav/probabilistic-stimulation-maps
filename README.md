# 2008_BetterMaps

MATLAB Class to handle Probabilistic Stimulation Map (PSM). It currently includes the following algorithms:

| Algorithm | Features | Images | Threshold | Stat. tests | Null-hypothesis | False positive correction | Sweetspot |
| ------ | ------ | ------ | ------ | ------ | ------ | ------ | ------ | 
| Nguyen, 2019 | Activated voxels coord., weights, scores, VTA index | n, mean, scoresArray | None | Wilcoxon (exact) | 0 | Benjamini-Hochberg (Genovese, 2002) | 10 percentile of significantMean | 
| Dembek, 2019 | Activated voxels coord., weights, scores, VTA index, stim. amplitude, MSSA¹ | n, mean, scoresArray, h0 | 15 | Wilcoxon (approx.) | MSSA¹ | Permutation Tests | largest cluster | 
| Reich, 2019  | Activated voxels coord., weights, scores, VTA index | n, mean, scoresArray, h0 | None | two samples t-test | scores of VTA excluding voxel | None | largest cluster | 

¹ Mean score of the VTA with same amplitude


