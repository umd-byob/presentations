library(shiny)
library(dplyr)
library(ggplot2)
library(reshape2)
library(preprocessCore)
library(DESeq)
library(fission)

shinyServer(function(input, output) {
    # Count matrix and metadata
    data(fission)
    count_matrix = data.frame(assay(fission))
    metadata = colData(fission)

    # normalized counts
    counts_normed = reactive({
        # No normalization
        if(input$norm_method == 'none') {
            return(count_matrix)
        } else if(input$norm_method == 'size_factor') {
            # Size factor normalization
            x = newCountDataSet(count_matrix, metadata$strain)
            x = estimateSizeFactors(x)
            return(as.data.frame(counts(x, normalize=TRUE)))
        } else if (input$norm_method == 'quantile') {
            # Quantile normalization
            x = as.data.frame(normalize.quantiles(as.matrix(count_matrix), 
                                                  copy=TRUE))
            rownames(x) = rownames(count_matrix)
            colnames(x) = colnames(count_matrix)
            return(x)
        }
    })

    # Convert counts to long format
    counts_long = reactive({
        # get log-normalized counts
        counts_wide = log2(counts_normed() + 1)
        counts_wide$id = rownames(counts_wide)
        long = melt(counts_wide, id=c("id"))
        colnames(long) = c("gene_id", "sample_id", "expr") 
        long$strain = metadata$strain[match(long$sample_id, 
                                            rownames(metadata))]
        return(long)
    })

    # plot colors
    plot_colors = c(rep('red', 18), rep('blue', 18))

    output$count_distributions = renderPlot({
        plt = ggplot(data=counts_long(), aes(x=sample_id, y=expr)) +
               geom_boxplot(aes(fill=strain)) + 
               theme(axis.text.x=element_text(angle=90, hjust=1))
        print(plt)
    })
})

