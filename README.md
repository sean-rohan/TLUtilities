TLUtilities
================

Introduction
------------

This package contains functions designed to process RACE light data using functions in the trawllight package. While trawllight provides functions to process light data, it is designed to work for a generic data structure, rather than being tailored to specifically processing RACE data. TLUtilities provides functions to read-in RACE data and iterate over casts to estimate optical parameters.

This document demonstrates how light data is processed using TLUtilities and trawllight.

Installing trawllight and TLUtilities
-------------------------------------

Use the devtools pacakge to install trawlllight and TLUtilities. Functions in the trawllight pacakage have full documentation. Not all functions in TLUtilities currently have documentation.

``` r
library(devtools)
#devtools::install_git("sean-rohan/trawllight")
#devtools::install_git("sean-rohan/TLUtilities")
library(trawllight)
library(TLUtilities)
```

Import directory structure
--------------------------

TLUtilities requires the user to pass a character vector indicating where light data are maintained. Each directory should contain a single file names CastTimes.csv, a single file named corr\_Mk9Hauls.csv, and any number of files formatted with the name deck\*\*.csv. The CastTimes.csv files contains survey event times associated with cast start/stop. The corr\_Mk9.Hauls.csv file contains data from a TDR-Mk9 archival tag with time-stamps shifted to match 'survey' time in cases where temporal drift occurred.

``` r
light.dir <- read.csv("D:/Projects/OneDrive/Thesis/Chapter 1 - Visual Foraging Condition in the Eastern Bering Sea/data/fileinv_lightdata_directory.csv", stringsAsFactors = F, header = F)

# Select EBS shelf directories
light.dir <- light.dir[which(grepl("ebs", light.dir[,1])),1]

print(light.dir[1:3])
```

    ## [1] "D:\\Projects\\OneDrive\\Thesis\\Chapter 1 - Visual Foraging Condition in the Eastern Bering Sea\\data\\LightData\\Data\\year_04\\ebs\\v_88"
    ## [2] "D:\\Projects\\OneDrive\\Thesis\\Chapter 1 - Visual Foraging Condition in the Eastern Bering Sea\\data\\LightData\\Data\\year_04\\ebs\\v_89"
    ## [3] "D:\\Projects\\OneDrive\\Thesis\\Chapter 1 - Visual Foraging Condition in the Eastern Bering Sea\\data\\LightData\\Data\\year_05\\ebs\\v_88"

Run light data
--------------

Run a wrapper function which runs `TLUtilies::vertical_profiles`, `trawllight::filter_stepwise`, and `trawllight::calculate_attenuation` for every cast in each of the target directories. Currently, directories should be processed in batches of 4-6 vessel/cruise combinations to avoid issues with R memory limits (which can exponentially increase processing time or cause R to crash). Downcasts and Upcasts should be processed separately. Here, processing is demonstrated for one year.

``` r
print(light.dir[9:10])
```

    ## [1] "D:\\Projects\\OneDrive\\Thesis\\Chapter 1 - Visual Foraging Condition in the Eastern Bering Sea\\data\\LightData\\Data\\year_08\\ebs\\v_88"
    ## [2] "D:\\Projects\\OneDrive\\Thesis\\Chapter 1 - Visual Foraging Condition in the Eastern Bering Sea\\data\\LightData\\Data\\year_08\\ebs\\v_89"

``` r
ebs <- process_all(dir.structure = light.dir[9:10],
                        cast.dir = "Downcast",
                        silent = F)
```

    ## [1] "Cruise: 200801, Vessel: 88, Haul: 1"

    ## Warning in calculate_attenuation(filtered, light.col = "trans_llight",
    ## depth.col = "cdepth", : calculate_attenuation: Did not fit loess. Total
    ## depth range of cast < min.range.

    ## [1] "Cruise: 200801, Vessel: 88, Haul: 2"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 3"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 4"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 5"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 6"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 7"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 8"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 9"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 10"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 11"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 12"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 13"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 14"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 15"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 16"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 17"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 18"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 19"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 20"
    ## [1] "No cast data found!"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 21"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 22"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 23"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 24"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 25"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 26"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 27"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 28"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 29"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 30"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 31"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 32"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 33"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 34"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 35"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 36"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 37"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 38"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 39"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 40"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 41"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 42"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 43"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 44"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 45"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 46"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 47"

    ## Warning in calculate_attenuation(filtered, light.col = "trans_llight",
    ## depth.col = "cdepth", : calculate_attenuation: Did not fit loess. Total
    ## depth range of cast < min.range.

    ## [1] "Cruise: 200801, Vessel: 88, Haul: 48"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 49"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 50"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 51"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 52"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 53"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 54"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 55"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 56"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 57"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 58"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 59"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 60"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 61"
    ## [1] "No cast data found!"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 62"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 63"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 64"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 65"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 66"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 67"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 68"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 69"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 70"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 71"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 72"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 73"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 74"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 75"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 76"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 77"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 78"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 79"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 80"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 81"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 82"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 83"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 84"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 85"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 86"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 87"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 88"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 89"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 90"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 91"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 92"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 93"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 94"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 95"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 96"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 97"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 98"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 99"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 100"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 101"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 102"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 103"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 104"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 105"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 106"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 107"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 108"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 109"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 110"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 111"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 112"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 113"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 114"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 115"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 116"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 117"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 118"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 119"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 120"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 121"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 122"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 123"
    ## [1] "No cast data found!"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 124"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 125"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 126"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 127"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 128"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 129"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 130"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 131"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 132"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 133"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 134"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 135"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 136"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 137"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 138"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 139"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 140"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 141"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 142"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 143"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 144"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 145"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 146"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 147"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 148"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 149"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 150"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 151"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 152"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 153"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 154"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 155"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 156"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 157"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 158"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 159"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 160"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 161"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 162"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 163"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 164"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 165"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 166"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 167"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 168"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 169"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 170"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 171"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 172"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 173"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 174"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 175"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 176"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 177"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 178"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 179"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 180"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 181"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 182"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 183"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 184"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 185"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 186"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 187"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 188"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 189"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 190"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 191"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 192"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 193"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 194"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 195"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 196"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 197"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 198"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 199"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 200"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 201"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 202"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 203"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 204"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 205"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 206"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 207"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 208"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 209"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 210"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 211"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 212"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 213"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 214"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 215"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 217"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 218"
    ## [1] "Cruise: 200801, Vessel: 88, Haul: 219"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 1"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 2"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 3"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 4"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 5"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 6"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 7"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 8"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 9"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 10"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 11"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 12"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 13"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 14"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 15"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 16"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 17"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 18"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 19"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 20"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 21"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 22"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 23"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 24"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 25"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 26"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 27"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 28"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 29"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 30"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 31"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 32"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 33"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 34"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 35"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 36"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 37"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 38"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 39"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 40"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 41"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 42"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 43"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 44"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 45"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 46"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 47"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 48"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 49"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 50"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 51"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 52"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 53"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 54"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 55"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 56"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 57"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 58"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 59"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 60"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 61"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 62"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 63"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 64"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 65"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 66"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 67"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 68"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 69"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 70"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 71"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 72"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 73"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 74"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 75"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 76"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 77"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 78"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 79"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 80"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 81"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 82"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 83"
    ## [1] "No cast data found!"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 84"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 85"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 86"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 87"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 88"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 89"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 90"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 91"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 92"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 93"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 94"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 95"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 96"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 97"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 98"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 99"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 100"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 101"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 102"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 103"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 104"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 105"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 106"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 107"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 108"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 109"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 110"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 111"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 112"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 113"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 114"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 115"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 116"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 117"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 118"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 119"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 120"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 121"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 122"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 123"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 124"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 125"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 126"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 127"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 128"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 129"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 130"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 131"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 132"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 133"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 134"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 135"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 136"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 137"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 138"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 139"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 140"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 141"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 142"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 143"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 144"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 145"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 146"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 147"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 148"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 149"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 150"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 151"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 152"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 153"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 154"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 155"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 156"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 157"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 158"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 159"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 160"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 161"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 162"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 163"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 164"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 165"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 166"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 167"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 168"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 169"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 170"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 171"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 172"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 173"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 174"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 175"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 176"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 177"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 178"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 179"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 180"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 181"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 182"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 183"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 184"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 185"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 186"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 187"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 188"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 189"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 190"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 191"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 192"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 193"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 194"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 195"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 196"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 197"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 198"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 199"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 200"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 201"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 202"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 203"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 204"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 205"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 206"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 207"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 208"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 209"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 210"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 211"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 212"
    ## [1] "Cruise: 200801, Vessel: 89, Haul: 213"
