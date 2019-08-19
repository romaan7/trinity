
R version 3.5.1 (2018-07-02) -- "Feather Spray"
Copyright (C) 2018 The R Foundation for Statistical Computing
Platform: x86_64-pc-linux-gnu (64-bit)

R is free software and comes with ABSOLUTELY NO WARRANTY.
You are welcome to redistribute it under certain conditions.
Type 'license()' or 'licence()' for distribution details.

Natural language support but running in an English locale

R is a collaborative project with many contributors.
Type 'contributors()' for more information and
'citation()' on how to cite R or R packages in publications.

Type 'demo()' for some demos, 'help()' for on-line help, or
'help.start()' for an HTML browser interface to help.
Type 'q()' to quit R.

> install.packages("ggplot2")
Installing package into ‘/users/pgrad/shaikhr/R/x86_64-pc-linux-gnu-library/3.5’
(as ‘lib’ is unspecified)
trying URL 'https://cloud.r-project.org/src/contrib/ggplot2_3.0.0.tar.gz'
Content type 'application/x-gzip' length 2847050 bytes (2.7 MB)
==================================================
  downloaded 2.7 MB

* installing *source* package ‘ggplot2’ ...
** package ‘ggplot2’ successfully unpacked and MD5 sums checked
** R
** data
*** moving datasets to lazyload DB
** inst
** byte-compile and prepare package for lazy loading
** help
*** installing help indices
*** copying figures
** building package indices
** installing vignettes
** testing if installed package can be loaded
* DONE (ggplot2)

The downloaded source packages are in
‘/tmp/Rtmp5bLYps/downloaded_packages’
> library(ggplot2)
> 
  > 
  > data <- read.csv("datafile.csv")
Error in file(file, "rt") : cannot open the connection
In addition: Warning message:
  In file(file, "rt") :
  cannot open file 'datafile.csv': No such file or directory
> plot(mtcars$wt, mtcars$mpg)
> mtcars
mpg cyl  disp  hp drat    wt  qsec vs am gear carb
Mazda RX4           21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4
Mazda RX4 Wag       21.0   6 160.0 110 3.90 2.875 17.02  0  1    4    4
Datsun 710          22.8   4 108.0  93 3.85 2.320 18.61  1  1    4    1
Hornet 4 Drive      21.4   6 258.0 110 3.08 3.215 19.44  1  0    3    1
Hornet Sportabout   18.7   8 360.0 175 3.15 3.440 17.02  0  0    3    2
Valiant             18.1   6 225.0 105 2.76 3.460 20.22  1  0    3    1
Duster 360          14.3   8 360.0 245 3.21 3.570 15.84  0  0    3    4
Merc 240D           24.4   4 146.7  62 3.69 3.190 20.00  1  0    4    2
Merc 230            22.8   4 140.8  95 3.92 3.150 22.90  1  0    4    2
Merc 280            19.2   6 167.6 123 3.92 3.440 18.30  1  0    4    4
Merc 280C           17.8   6 167.6 123 3.92 3.440 18.90  1  0    4    4
Merc 450SE          16.4   8 275.8 180 3.07 4.070 17.40  0  0    3    3
Merc 450SL          17.3   8 275.8 180 3.07 3.730 17.60  0  0    3    3
Merc 450SLC         15.2   8 275.8 180 3.07 3.780 18.00  0  0    3    3
Cadillac Fleetwood  10.4   8 472.0 205 2.93 5.250 17.98  0  0    3    4
Lincoln Continental 10.4   8 460.0 215 3.00 5.424 17.82  0  0    3    4
Chrysler Imperial   14.7   8 440.0 230 3.23 5.345 17.42  0  0    3    4
Fiat 128            32.4   4  78.7  66 4.08 2.200 19.47  1  1    4    1
Honda Civic         30.4   4  75.7  52 4.93 1.615 18.52  1  1    4    2
Toyota Corolla      33.9   4  71.1  65 4.22 1.835 19.90  1  1    4    1
Toyota Corona       21.5   4 120.1  97 3.70 2.465 20.01  1  0    3    1
Dodge Challenger    15.5   8 318.0 150 2.76 3.520 16.87  0  0    3    2
AMC Javelin         15.2   8 304.0 150 3.15 3.435 17.30  0  0    3    2
Camaro Z28          13.3   8 350.0 245 3.73 3.840 15.41  0  0    3    4
Pontiac Firebird    19.2   8 400.0 175 3.08 3.845 17.05  0  0    3    2
Fiat X1-9           27.3   4  79.0  66 4.08 1.935 18.90  1  1    4    1
Porsche 914-2       26.0   4 120.3  91 4.43 2.140 16.70  0  1    5    2
Lotus Europa        30.4   4  95.1 113 3.77 1.513 16.90  1  1    5    2
Ford Pantera L      15.8   8 351.0 264 4.22 3.170 14.50  0  1    5    4
Ferrari Dino        19.7   6 145.0 175 3.62 2.770 15.50  0  1    5    6
Maserati Bora       15.0   8 301.0 335 3.54 3.570 14.60  0  1    5    8
Volvo 142E          21.4   4 121.0 109 4.11 2.780 18.60  1  1    4    2
> qplot(mtcars$wt, mtcars$mpg)
> ggplot(mtcars, aes(x=wt, y=mpg)) + geom_point()
> plot(pressure$temperature, pressure$pressure, type="l")
> pressure
temperature pressure
1            0   0.0002
2           20   0.0012
3           40   0.0060
4           60   0.0300
5           80   0.0900
6          100   0.2700
7          120   0.7500
8          140   1.8500
9          160   4.2000
10         180   8.8000
11         200  17.3000
12         220  32.1000
13         240  57.0000
14         260  96.0000
15         280 157.0000
16         300 247.0000
17         320 376.0000
18         340 558.0000
19         360 806.0000
> View(mtcars)
> View(pressure)
> points(pressure$temperature, pressure$pressure)
> lines(pressure$temperature, pressure$pressure/2, col="red")
> points(pressure$temperature, pressure$pressure/2, col="red")
> qplot(pressure$temperature, pressure$pressure, geom="line")
> qplot(temperature, pressure, data=pressure, geom="line")
> barplot(BOD$demand, names.arg=BOD$Time)
> View(BOD)
> table(mtcars$wt)

1.513 1.615 1.835 1.935  2.14   2.2  2.32 2.465  2.62  2.77  2.78 2.875  3.15  3.17  3.19 3.215 3.435  3.44  3.46  3.52  3.57  3.73 
1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     3     1     1     2     1 
3.78  3.84 3.845  4.07  5.25 5.345 5.424 
1     1     1     1     1     1     1 
> table(mtcars$cyl)

4  6  8 
11  7 14 
> barplot(table(mtcars$cyl))
> barplot(table(mtcars$wt))
> barplot(table(mtcars$mpg))
> qplot(BOD$Time,BOD$demand,geom="bar",stat="identity")
Error: stat_count() must not be used with a y aesthetic.
In addition: Warning message:
  `stat` is deprecated 
> qplot(factor(BOD$Time), BOD$demand, geom="bar", stat="identity")
Error: stat_count() must not be used with a y aesthetic.
In addition: Warning message:
  `stat` is deprecated 
> qplot(factor(BOD$Time), BOD$demand, geom="bar")
Error: stat_count() must not be used with a y aesthetic.
> qplot(BOD$Time, BOD$demand, geom="bar", stat="identity")
Error: stat_count() must not be used with a y aesthetic.
In addition: Warning message:
  `stat` is deprecated 


barplot(table(mtcars$cyl))

qplot(BOD$Time, BOD$demand, geom="col", stat = "identity")
qplot(BOD$Time, BOD$demand, geom="bar", stat="identity")
ggplot(BOD, aes(x=Time, y=demand)) + geom_bar(stat="identity")
qplot(Time, demand, data=BOD, geom="bar", stat="identity")

hist(mtcars$mpg, breaks=10)
qplot(BOD$Time, BOD$demand) + (geom="bar", stat="identity")

