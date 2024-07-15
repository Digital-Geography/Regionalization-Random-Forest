# Regionalization Random Forest
This repository can be used to arrive at more performant predictions in a spatial context than a "casual" Random Forest Regression Model. In certain scenarios, GWR and GW-RF can be outperformed as well. These three are also included in order to be able to compare performance.

In this example, the analysis was done for the California Housing Dataset which is available [here](https://www.dcc.fc.up.pt/~ltorgo/Regression/cal_housing).
The dataset was adapted slightly in order to make the Regionalization algorithms able to run. For further reference please do not hesitate to contact me.

Notebooks in this repository:

GWRPRED: Carries out a prediction on the test set using Geographically Weighted Regression.

GRF: Carries out a prediction on the test set using Geographically Weighted Random Forest.

GW-RF-LISA: Evaluation of spatial performance metrics from GRF.

RF: Carries out a prediction on the test set using Random Forest.

RegRF_WARD/AZP/KMmeans/SKATER/Max-p: Carries out a prediction on the test set using Regionalization Random Forest.


A more detailed description on what this repository does and why it is necessary can be found below:

Recent years have seen a rapid increase in the capabilities of machine learning models. In this realm, this thesis aims to present a novel approach for predictive modeling which is able to take spatial heterogeneity into account, as well as evaluate various approaches to solving this problem. This is done by introducing regionalization methods in a preprocessing step of the practical workflow. Five different regionalization methods are tested: WARD, AZP, Kmeans, SKATER, and Max-p, which are applied to two datasets of varying size, which is another aspect of interest to this research. The proposed approach is termed RegRF. RegRF is compared to three established predictive modeling methods: Random Forest, Geographically Weighted Regression, and Geographically Weighted Random Forest. The implementation of RegRF has shown its ability to significantly increase the performance of the predictive models in comparison to "non-spatial" Random Forest models, while only taking a few seconds longer to compute. In some scenarios, RegRF was able to compete with the well-established Geographically Weighted Regression, while only requiring a fraction of the computational effort. The third approach, Geographically Weighted Random Forest, was not able to be outperformed when modeling the smaller dataset, but in this work it was not able to finish computation for the larger scale dataset. These results clearly show the potential for the performance of machine learning models to increase when taking spatial phenomena into account. Given the fact that RegRF is not explicitly optimized for the data at hand, further improvements regarding its performance are possible.


The workflow for RegRF is schematically visualized in the figure which is linked ![here](Workflow.pdf). It can be categorized into three steps:

1. Carry out the regionalization procedure on the training data. The clusters (regions) are then inserted as a spatial feature into the observation matrix. 

2.	A spatial join is performed between the test data and the training data to identify the cluster region of each test point. Thus, the spatial feature of the test data is engineered in this step. 

3.	Carry out the RegRF prediction. After fitting the model, predictions on the test set are carried out and reported.

Depending on the regionalization results and the modeling with the training data, this process is repeated until a satisfactory regionalization result is obtained, after that it is used for predicting the test labels from the test features.
