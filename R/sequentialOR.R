#' Sequential outlier rejection
#'
#' Iteratively fit a model to data and remove the most extreme residual. Three models are implemented here: ordinary least squares (lm), generalized linear model (glm), generalized additive model (GAM).
#'
#' @param data Data frame containing predictor and response variables.
#' @param method Character vector of length one indicating which function should be used to fit models. Options are 'lm', 'glm', or 'gam'.
#' @param fn Formula to be passed to the model. Formula must be valid for the selected method. Variables must included in `data` and the extraction operator ($) should not be used in the forumla.
#' @param n.reject Numerical vector of length one. Number of observations to be rejected in each iteration. Larger values speed the funciton up, but may impede precise detection of break points.
#' @param n.stop Numerical vector of length one which indicating the number of observations remaining or proportion of initial observations which should be remaining before outlier rejection stops. For example, with 400 initial observations, n.stop set to 40 or 0.1 (= 400*0.1) would stop the algorithm when 40 observations remain.
#' @param tail Character vector of length one indicating whether to reject from the lower tail, upper tail, or both tails. Default = "both".
#' #' @param plot Logical vector indicating whether the function should print a plot of observations versus RMSE.
#' @param ... Additional arguments passed to function calls (family, offset, etc.)
#'
#' @return The function returns a list with (1) input data frame with an additional column indicating the order in which observations were rejected, (2) a data frame containing the number of observations used for model-fitting and the associated RMSE. If argument `plot=T`, also prints a plot of observations versus RMSE given the remaining observations.
#'
#' @references Kotwicki, S., M. H. Martin, and E. A. Laman. 2011. Improving area swept estimates from bottom trawl surveys. Fisheries Research 110(1):198–206. Elsevier B.V.


sequentialOR <- function(data, method = 'lm', formula, n.reject = 1, n.stop, threshold.stop = NULL, tail = "both", plot = T, progress.plot = F,  ...) {

  tail <- tolower(tail)
  method <- tolower(method)

  # Index rows
  rownames(data) <- 1:nrow(data)

  # Calculate absolute stopping point if n.stop is a proportion
  if(n.stop < 1) {
    n.stop <- n.stop * nrow(data)
  }

  # Initialize output
  iter <- floor((nrow(data) - n.stop) / n.reject)
  data$SOR_RANK <- NA
  RMSE <- rep(NA, iter)
  NN <- rep(NA, iter)
  PARSLOPE <- rep(NA, iter)
  data$index <- 1:nrow(data)

  # Rejection counter
  rejection <- 1

  for(i in 1:iter) {

    # Subset data that hasn't been rejected
    data.sub <- subset(data, is.na(SOR_RANK), drop = T)

    # Select model
    if(method == 'lm') mod <- lm(formula, data = data.sub, ...);
    if(method == 'glm') mod <- glm(formula, data = data.sub, ...);
    if(method == 'gam') mod <- mgcv::gam(formula, data = data.sub, ...);

    # Append residuals to subsetted data
    data.sub$resid <- resid(mod)

    if(progress.plot) {
      png(file = paste0("./figures/sor_example/", i, ".png"), res = 120, width = 8, height = 4, units = "in")
      p1 <- ggplot() + geom_point(aes(x = log10(surf_trans_llight), y = log10(trans_llight)), data = data.sub, alpha = 0.7) +
        scale_x_continuous(limits = c(-1.1, 4)) +
        scale_y_continuous(limits = c(-1.5, 3.5) + theme_bw())
      p2 <- ggplot() + geom_density(aes(x = data.sub$resid)) + scale_x_continuous(limits = c(-2.2,2.2), expand = c(0,0)) +
        scale_y_continuous(limits = c(0,2), expand = c(0,0))
      print(grid.arrange(p1, p2, nrow = 1, ncol = 2) + theme_bw())
      dev.off()
    }

    # Assign order of rejection to input data frame based on residual rank-order
    # if(tail == "both") data$SOR_RANK[as.numeric(rownames(data.sub)[rev(order(abs(data.sub$resid)))])[rejection:(rejection+n.reject-1)]] <- c(rejection:(rejection+n.reject-1))
    if(tail == "both") data$SOR_RANK[which(data$index == data.sub$index[which.max(abs(data.sub$resid))])] <- i
    if(tail == "upper") data$SOR_RANK[which(data$index == data.sub$index[which.max(data.sub$resid)])] <- i
    if(tail == "lower") data$SOR_RANK[which(data$index == data.sub$index[which.min(data.sub$resid)])] <- i

    # Calculate RMSE for iteration
    RMSE[i] <- mean(residuals(mod)^2)
    NN[i] <- i
    PARSLOPE[i] <- coef(mod)[2]

    # Stop based on a threshold, as in Kotwicki et al. (2011)
    if(!is.null(threshold.stop)) {
      if(max(abs(resid(mod))) < threshold.stop) {
        RMSE <- RMSE[1:i]
        NN <- NN[1:i]
        print(paste0("Stopping threshold reached. Stopped after iteration " , iter))
        return(list(obs_rank = data, rmse = data.frame(N = NN, RMSE = RMSE)))
      }
    }

    #Update rejection index counter
    rejection <- rejection + n.reject
  }

  if(plot == T) print(plot(NN, RMSE, xlim = c(nrow(data) + n.reject, n.stop - n.reject)))

  return(list(obs_rank = data, rmse = data.frame(N = NN, RMSE = RMSE, PARSLOPE = PARSLOPE)))

}
