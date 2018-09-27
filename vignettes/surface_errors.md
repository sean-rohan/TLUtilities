---
title: "Surface Errors"
output: github_document
---



## Problem

There was evidence that measurment errors occurred, based on examination of the relationship between surface-incident clear-sky PAR estimated by global irradiance model and light measurements from the deck-mounted archival tag. Here, I fix the problem for one vessel/cruise. This is a somewhat convoluted example because the time offset error was already recorded in Stan's notes for this vessel/cruise. However, it was a slightly more "involved" fix than for other years.

Two possible explanations for discrepancies are:
* Measurement error due to obstruction of the photoelectric cell (e.g. gull-induced biofouling)
* Time zone mismatch between archival tag and "survey time."

The scatterplot seemed to suggest the latter explanation since the full range of light measurments seemed to occur. However, it's possible that both errors occurred.

#### Obstruction?
If the photoelectric cell was obstructed, diel peaks in light measurements would be expected to drop precipitously. Let's plot the raw tag data:


```r
head(bbb)
```

```
##         date     time cdepth  temp clight
## 1 06/02/2006 08:20:00   -2.5 11.45    157
## 2 06/02/2006 08:20:10   -2.5 11.45    153
## 3 06/02/2006 08:20:20   -2.5 11.45    156
## 4 06/02/2006 08:20:30   -2.0 11.40    148
## 5 06/02/2006 08:20:40   -2.5 11.45    167
## 6 06/02/2006 08:20:50   -2.5 11.35    170
```

```r
bbb$datetime <- paste(bbb$date, bbb$time)
bbb$datetime <- as.POSIXct(bbb$datetime, format = "%m/%d/%Y %H:%M:%S", tz = "America/Anchorage")
ggplot(data = bbb, aes(x = datetime, y = clight)) + geom_path()
```

![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-1-1.png)

Looks pretty normal-- no evidence that the tag was obstructed.

#### Wrong time?

Next, I checked to see if the timestamps were off, by plotting the sunrise time for the first haul of the day.

```r
require(fishmethods)
require(lubridate)


# Vessel/cruise of interest
ccc <- subset(haul_time_position, vessel == 134 & cruise == 200601)

# Only the first haul of the day
ccc <- subset(ccc, haul %in% aggregate(haul ~ yday(ccc$start_time), data = ccc, FUN = min)[,2])

# Calculate sunrise time
ccc <- cbind(ccc,
       fishmethods::astrocalc4r(day = day(ccc$start_time),
                  month = month(ccc$start_time),
                  year = year(ccc$start_time),
                  hour = hour(ccc$start_time) + minute(ccc$start_time)/60,
                  timezone = rep(-8, nrow(ccc)),
                  lat = ccc$start_latitude,
                  lon = ccc$start_longitude,
                  seaorland = "maritime"))

# Convert sunrise time to POSIXct
ccc$sunrise2 <- as.POSIXct(paste(date(ccc$start_time), " ", floor(ccc$sunrise), ":", floor(ccc$sunrise%%1 * 60), ":", floor((ccc$sunrise%%1 * 60)%%1*60), sep = ""), tz = "America/Anchorage")

head(ccc)
```

```
##     vessel cruise haul          start_time stationid start_latitude
## 639    134 200601    1 2006-06-01 13:48:46                 55.84351
## 640    134 200601    2 2006-06-02 06:38:21      G-15       57.01168
## 644    134 200601    6 2006-06-03 06:31:13      K-13       58.28686
## 649    134 200601   11 2006-06-04 06:35:11      E-12       56.33973
## 654    134 200601   16 2006-06-05 06:35:45      I-11       57.66882
## 659    134 200601   21 2006-06-06 06:26:03      J-09       58.00790
##     start_longitude end_latitude end_longitude bottom_depth performance
## 639      -163.20360     55.86209    -163.17171           87           0
## 640      -159.10260     56.99125    -159.13029           36           0
## 644      -159.97240     58.26921    -159.96820           42           0
## 649      -160.94910     56.33321    -160.99370           54           0
## 654      -161.46570     57.66470    -161.51300           53           0
## 659      -162.72479     57.99469    -162.76590           41           0
##     haul_type stratum       noon    sunrise     sunset     azimuth
## 639         0      NA 14.8446772 6.25448542 23.4348690 154.5844794
## 640         3      10 14.5731209 5.82897368 23.3172681  54.1953434
## 644         3      10 14.6338109 5.69811713 23.5695047  52.0213658
## 649         3      10 14.7017478 6.00260346 23.4008922  51.8622384
## 654         3      10 14.7390980 5.84996864 23.6282274  51.4076438
## 659         3      10 14.8260176 5.87122320 23.7808120  48.4273041
##         zenith     eqtime     declin   daylight          PAR
## 639 35.6601998 2.13376759 22.1295892 17.1803836 381.95197090
## 640 85.8652145 2.02314787 22.2207617 17.4882944   9.14266494
## 644 86.1285504 1.86094617 22.3446569 17.8713875   7.76722825
## 649 87.2319783 1.69152978 22.4629818 17.3982888   3.02174650
## 654 86.5474428 1.51691806 22.5744172 17.7782588   5.75551212
## 659 87.6829727 1.33810303 22.6786251 17.9095888   1.66950165
##                sunrise2
## 639 2006-06-01 06:15:16
## 640 2006-06-02 05:49:44
## 644 2006-06-03 05:41:53
## 649 2006-06-04 06:00:09
## 654 2006-06-05 05:50:59
## 659 2006-06-06 05:52:16
```

```r
# Plot sunrise times over light meaurements.
ggplot() + geom_path(data = bbb, aes(x = datetime, y = clight)) +
  geom_vline(data = ccc, aes(xintercept = sunrise2), col = "red", linetype = 2)
```

![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-2-1.png)

Sunrises times from the first half of the survey look consistent with the time stamps. Sunrise times from the second half look like they occurred in the middle of the day:

```r
ggplot() + geom_path(data = subset(bbb, month(datetime) == 7 & day(datetime) < 15), aes(x = datetime, y = clight)) +
  geom_vline(data = subset(ccc, month(sunrise2) == 7 & day(sunrise2) < 15), aes(xintercept = sunrise2), col = "red", linetype = 2)
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-1.png)

After some trial and error, it looks like the archival tag times were off by 12 hours. Here, the archival tag timestamps are shifted by 12 hours (12 * 3600):

```r
ggplot() + geom_path(data = subset(bbb, month(datetime) >= 7 & day(datetime) > 5), aes(x = datetime - 12 * 3600, y = clight)) +
  geom_vline(data = subset(ccc, month(sunrise2) >= 7 & day(sunrise2) > 5), aes(xintercept = sunrise2), col = "red", linetype = 2)
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4-1.png)


## Adding the correction

Now that I know how to fix the problem, I add a conditional correction to time_adjustment.R:

```text
  if(cast.data$vessel[1] == 134 & cast.data$cruise[1] == 200601) {
    print("Correcting 134-201101")
    light.data$ctime[lubridate::month(light.data$ctime) >=7 & lubridate::day(light.data$ctime) > 8] <- light.data$ctime[lubridate::month(light.data$ctime) >=7 & lubridate::day(light.data$ctime) > 8] - 3600*12 # Time off by 1 hour
  }
```