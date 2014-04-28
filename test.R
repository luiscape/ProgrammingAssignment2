### Testing the speed of cachematrix.R ###
# 
# Here we test the efficiency of caching computationally expensive functions.
# The functions we are testing are makeCacheMatrix and cacheSolve. 
# [Use `source(cachematrix.R)` if you are interested in the functions.]
# 
# The function SpeedTest below only takes one parameter: iterations. 
# Iterations means the power that will be applied to the 2 x 2 matrix.
# Providing a value larger than 14 could stall most home computers 
# for a considerable ammount of time. 
# 
# You can see results of speed.test(20) in this link: 
# 
# Use with CAUTION! 
# -----------------

SpeedTest <- function(iterations = 10, functions = 'makeCacheMatrix') { 
  
  if (functions == 'makeVector') { function1 <- makeVector
                                 function2 <- cachemean }
  else { function1 <- makeCacheMatrix
         function2 <- cacheSolve }
  
  z <- function1(2)
  
  wo.cache <- data.frame(t(unclass(system.time(function2(z)))))
  wo.cache$i <- 2
  w.cache <- data.frame(t(unclass(system.time(function2(z)))))
  w.cache$i <- 2
  
  # create progress bar
  pb <- txtProgressBar(min = 0, max = iterations, style = 3)
  for (i in 3:iterations) {
    setTxtProgressBar(pb, i)  # Updates progress bar.
    
    z <- function1(2^i)
    wo.it <- data.frame(t(unclass(system.time(function2(z)))))
    wo.it$i <- i
    wo.cache <- rbind(wo.cache, wo.it)
    if (i == iterations) message('Assembling data.frame . . .')
    w.it <- data.frame(t(unclass(system.time(function2(z)))))
    w.it$i <- i
    w.cache <- rbind(w.cache, w.it)
  }
  wo.cache <<- wo.cache
  w.cache <<- w.cache
  message('Done.')
}


PlotSpeedTest <- function() { 
  
  library(ggplot2)
  
  SpeedPlot <- ggplot() + theme_bw() + 
#                 geom_line(data = wo.cache, aes(i, user.self), color = "#cccccc") + 
                geom_smooth(data = wo.cache, se = FALSE, aes(i, user.self), 
                          color = "#cccccc", 
                          size = 1.3) +
#                 geom_text(data = wo.cache[wo.cache$i == nrow(wo.cache), ], 
#                           aes(i, user.self, label = "Without cache."), 
#                           hjust = 0.7,
#                           vjust = 1) +
#                 geom_point(data = wo.cache, aes(i, sys.self), 
#                            color = "#ffffff", 
#                            size = 5) +
#                 geom_point(data = wo.cache, aes(i, sys.self), 
#                            color = "#cccccc", 
#                            size = 3.5
#                            ) +
#                 geom_line(data = wo.cache, aes(i, elapsed), color = "#cccccc") + 
#                 geom_line(data = w.cache, aes(i, user.self), color = "#cccccc") + 
  geom_smooth(data = w.cache, se = FALSE, aes(i, user.self), 
                          color = "#0988bb", 
                          size = 1.3) +
#   geom_text(data = w.cache[w.cache$i == nrow(w.cache), ], 
#             aes(i, user.self, label = "With cache."), 
#             hjust = 0.7,
#             vjust = 1)
#                 geom_point(data = w.cache, aes(i, sys.self), 
#                            color = "#ffffff", 
#                            size = 5) +
#                 geom_point(data = w.cache, aes(i, sys.self), 
#                            color = "#0988bb", 
#                            size = 3.5) + 
#                 geom_line(data = w.cache, aes(i, elapsed), color = "#0988bb")
                scale_x_continuous(labels = 
                                   paste0("2^",c(1:nrow(wo.cache) + 1)), 
                                   breaks = c(1:nrow(wo.cache) + 1)) + 
  labs(title = 'Cached performance (blue) vs. no-Cached performance (grey)')

SpeedPlot

## add plots with three variables here. 

}

