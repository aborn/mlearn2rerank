USAGE.md
==========

## INTRO
This manual tells you how to use this code step by step.

## USE THIS CODE
0. trainDataFeatureExtraction.m  
Running this code to extract the visual feature of training data. All
training examples are used the query positive images.
1. trainDataPre.m  
Running this code for prepare the training data.
2. trainModel.m   
Training metric model for each query.
3. testDataPre.m  
Prepare the testing data.
4. queryRerank.m  
Reranking for each query.
5. doMetricRerank.m and testDoMetricRerank.m  
Eqch qurey reranking with each kind of metric.
6. testSelectMetric.m  
Test the best select metric for reranking.


## UPDATE
2014-06-06 Aborn Jiang (aborn.jiang@foxmail.com)
