mlearn2rerank
==========

## INTRO
This project aims to use metric learning to image search reranking.

## How to use code
Pls read the file
[USAGE.md](https://github.com/aborn/mlearn2rerank/blob/master/doc/USAGE.md)

## Training dataset
All trainig dataset comes from the MSRAMM dataset. 

## Test data
All testing dataset comes form the WebQueries dataset. Each query test
data is stored in $ABSPATH/$dataSetName/$featurename/$data$queryno.mat.

## About Model File Path
Note: the following $ABSPATH means the project directory.  

All model files are stored in $ABSPATH/data/model/$featurename/ . There
are two kinds of model, that is , normal models and scale models. The
normal models are trained from the extracted feature data. The scale
models are trained freom the extracted feature normalized data. We
adapted common normalized method, which normalize data between
[0,1]. And the normalization uses y = (x - x_min) / (x_max - x_min);  

Take the 'gist' feature as example. So, all normal models and scale
models are stored in $ABSPATH/data/model/gist/ . For the model trained
by the data of MSRAMM query_1. The normal model is
$ABSPATH/data/model/gist/gist1.mat, and the scale model is
$ABSPATH/data/model/gist/gistscale1.mat.  

## Use Model File
If you want to use a specific model file, for eaxmpale
$ABSPATH/data/model/gist/gistscale1.mat, only use load command in
matlab. After file loaded, the matlab working memory has a transform
matrix, that is, L. Using transform matrix like Y = L * X, here X is
dim-by-sampleno. Each coloum of X and Y represents an example image.


## Version
* v1.0 2014-04-27 by Aborn Jiang.



