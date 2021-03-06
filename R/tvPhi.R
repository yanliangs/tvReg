#' Time-Varying Coefficient Arrays of the MA Represention
#'
#' Returns the estimated time-varying coefficient arrays of the moving average representation
#' of a stable \code{tvvar} object obtained with function \code{tvVAR}.
#'
#' @param x An object of class \code{tvvar}.
#' @param nstep An integer specifying the number of moving error coefficient matrices to be calculated.
#' @param ... Other parameters passed to specific methods.
#' @rdname tvPhi
#' @export
#'
tvPhi<- function (x, nstep = 10, ...)
{
  if (!inherits(x, "tvvar"))
    stop("\nPlease provide an object of class 'tvvar', generated by 'tvVAR()'.\n")
  nstep <- abs(as.integer(nstep))
  neq <- x$neq
  p <- x$p
  obs <- x$obs
  A <- tvAcoef(x)
  if (nstep >= p)
  {
    As <-  array(0, dim = c(obs,neq, neq, nstep + 1))
    for (i in (p + 1):(nstep + 1)) 
    {
      As[,, , i] <- array(0, dim=c(obs,neq, neq))
    }
  }
  else
  {
    As <- array(0, dim = c(obs, neq, neq, p))
  }
  for (i in 1:p)
  {
    As[,, , i] <- A[[i]]
  }
  Phi <- array(0, dim = c(obs, neq, neq, nstep + 1))
  for ( t in 1:obs)
  {
    Phi[t, , , 1] <- diag(neq)
    Phi[t, , , 2] <- Phi[t,,,1] %*% As[t, , , 1]
    if (nstep > 1) {
      for (i in 3:(nstep + 1)) 
      {
        tmp1 <- Phi[t, , , 1] %*% As[t,,,i-1]
        tmp2 <- matrix(0, nrow = neq, ncol = neq)
        idx <- (i - 2):1
        for (j in 1:(i - 2)) 
        {
          tmp2 <- tmp2 + Phi[t,, , j + 1] %*% As[t,, , idx[j]]
        }
        Phi[t, , , i] <- tmp1 + tmp2
      }
    }
  }
  return(Phi)
}
