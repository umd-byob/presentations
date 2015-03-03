Shiny demo: K-means clustering
==============================

Overview
--------

![I. versicolor](../images/Iris_versicolor_3.jpg)
(source: [Wikipedia](http://en.wikipedia.org/wiki/Iris_flower_data_set#mediaviewer/File:Iris_versicolor_3.jpg))

The first demo application is a very simple Shiny app which includes one UI
control (a slider) and one output (a scatterplot). The application demonstrates
the use of kmeans clustering to group datapoints in [Fisher's iris
dataset](http://en.wikipedia.org/wiki/Iris_flower_data_set) which includes
three related iris flower species and some properties (sepal height, petal
length, etc.) for a collection of representative flowers from each species.

Usage
-----

To run this demo, open up an R console in the directory containing `server.R`
and `ui.R` and type:

```r
library(shiny)
runApp()
```

