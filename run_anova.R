run_anova <- function(x, var1, var2 = NULL, var3 = NULL, padj = FALSE) {
    anova_res <- NULL
    if (is.null(var1)) stop("You must define at least one condition to use for the model")
    if (is.null(var2)) {
        if (is.null(var3)) {
            formu <- as.formula("unlist(x[i, ]) ~ var1")
            idx <- 1
            cols <- "Pval"
            
            cat("Using one way anova \n")
        }
        else {
            formu <- as.formula("unlist(x[i, ]) ~ var1 * var3")
            idx <- 1:3
            cols <- c(substitute(var1), substitute(var3), "interaction")
            cat("Using two way anova \n")
        }
    }
    
    else if (is.null(var3)) {
        formu <- as.formula("unlist(x[i, ]) ~ var1 * var2")
        idx <- 1:3
        cols <- c(substitute(var1), substitute(var2), "interaction")
        cat("Using two way anova \n")
    }

    else {
        formu <- as.formula("unlist(x[i, ]) ~ var1 * var2 * var3")
        idx <- 1:7
        cols <- c(deparse(substitute(var1)), deparse(substitute(var2)), deparse(substitute(var3)), 
                  paste0(deparse(substitute(var1)), ":", deparse(substitute(var2))),
                  paste0(deparse(substitute(var1)), ":", deparse(substitute(var3))),
                  paste0(deparse(substitute(var2)), ":", deparse(substitute(var3))),
                  paste0(deparse(substitute(var1)), ":", deparse(substitute(var2)), ":", deparse(substitute(var3))))

        cat("Using three way anova \n")
    }

    for (i in 1:nrow(x)) {
        mod <- stats::lm(formu)
        a <- stats::anova(mod)
        res <- t(as.data.frame(a[idx, 5]))
        anova_res <- as.data.frame(rbind(anova_res, res))

        #this is a just progess tracker for the function
        if (i%%100==0) {
            per <- round((i / nrow(x)) * 100)
            cat(paste("\r", "anova ", per, "% done", sep=""))
        }
        else if (i == nrow(x)) {
            cat(paste("\r", "anova ", "100% done", sep = ""))
        }
    }
    colnames(anova_res) <- cols
    rownames(anova_res) <- rownames(x)
    if (padj == TRUE) {
        padj <- as.data.frame(lapply(anova_res, p.adjust, method = "BH"))
        colnames(padj) <- paste0("padj_", colnames(padj))
        anova_res <- cbind(anova_res, padj)
    }

    cat("\n")
    return(anova_res)
}

