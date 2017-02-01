[![shiny](https://img.shields.io/badge/launch-shiny%20app-ff69b4.svg)](http://shiny.janfreyberg.com/pt-stats-shiny/)


# shiny-elbow-kmeans

Want to find structure in your data?

### Step 1: Enter your data
There is a text field where you can enter your univariate (one variable only!) data.

### Step 2: Find the elbow
The script will try up to 10 clusters. It will show you the variance __not__ explained by your data, and you need to pick the point at which the variance not explained starts to decrease at a much lower rate (in essence, the point at which adding more clusters does not explain more variance).

### Step 3: Check the results
Make sure the clustering looks right to you - and that the script didn't mess up.

### Step 4: Get your results
You can get the information on your cluster centers and the variance explained at the end of the app.

### Accompanying blogpost
Often data is distributed normally. But sometimes, there is sub-grouping in your data that is worth exploring a bit more: For example, a subset of your data is drawn from a different population, and therefore has a different mean.

One popular technique to find these clusters without any prior knowledge is k-means clustering. The idea is that you ask an algorithm to provide you with k clusters, where k is an integer (between 1 and your sample size). The algorithm then selects some random cluster centers, and assigns each datapoint to the cluster it is closest to. It then calculates the within-group sum of squares (SS), a proxy for how much variance is in your data after you account for the cluster centers.

The algorithm then moves around the cluster centers until this variance is minimised.

The tricky part comes when you need to decide how many clusters your data likely has. Of course, the more clusters you have, the more variance they account for, and subsequently the less variance is left after accounting for cluster centers. If you have the same number of clusters as you have data points, then each cluster just contains one point - and there is no variance left at the end. However, you’ve also not learned anything about your dataset.

One simple method is the “elbow” method, where you try out a certain number of clusters, and plot the within-group sum of squares against number of clusters. You then try and find the “elbow”, or the point at which suddenly, increasing the number of clusters doesn’t reduce the residual variance very much.

Since this is a visual procedure, it lends itself well to an interactive framework, so I’ve built one =) you can try it below, or find it [here](shiny.janfreyberg.com/elbow-kmeans).

I’ll work on a bivariate version soon!