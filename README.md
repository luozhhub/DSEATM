# DSEATM
drug set enrichment analysis based on text mining

cite：Luo Z H, Zhu L D, Wang Y M, et al. DSEATM: drug set enrichment analysis uncovering disease mechanisms by biomedical text mining[J]. Briefings in Bioinformatics, 2022. https://doi.org/10.1093/bib/bbac228

##Install this package in R studio

```{r}
devtools::install_github("luozhhub/DSEATM")
#or
install.packages("/XXXX(path)/DSEATM_1.0.0.tar.gz", repos = NULL, type="source")
```

##Usage
We have stored the disease-drug and drug-gene associations in this package.
Users can retrive drugs related to a specific disease, or genes related to a specific drugs

For example, to get the breast cancer related pathways
```{r}
library("DSEATM")
BRCA_pathways = disease2pathway("D001943")
```

##manual
In this package, the disease id and drug id are all MeSH terms. If you want to get more information for one MeSH term.
Please refer to pyMeSHSim (https://github.com/luozhhub/pyMeSHSim)
