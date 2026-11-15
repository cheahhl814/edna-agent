<div class="container">

<div class="section content">

- <a href="/" data-astro-cid-sdvudldn="">Home</a>
- <a href="/packages/3.23/BiocViews.html"
  data-astro-cid-sdvudldn="">Bioconductor 3.23</a>
- <a href="/packages/3.23/bioc/" data-astro-cid-sdvudldn="">Software
  Packages</a>
- ANCOMBC

<div pagefind-body="" pagefind-filter="type:Packages"
astro-cid-sdvudldn="">

# ANCOMBC

<span hidden="" pagefind-filter="repo:Software"
astro-cid-sdvudldn=""></span>

<div class="package-fragment" pagefind-ignore="" astro-cid-sdvudldn="">

This is the **released** version of ANCOMBC; for the devel version, see
<a href="/packages/3.24/bioc/html/ANCOMBC.html"
data-astro-cid-sdvudldn="">ANCOMBC</a>.

All versions

<a href="/packages/3.24/bioc/html/ANCOMBC.html"
aria-label="Bioconductor 3.24 (devel)" data-astro-cid-sdvudldn="">3.24
(devel)</a>, <span class="current" aria-current="page"
astro-cid-sdvudldn="">3.23 (release)</span>,
<a href="/packages/3.22/bioc/html/ANCOMBC.html"
aria-label="Bioconductor 3.22" data-astro-cid-sdvudldn="">3.22</a>,
<a href="/packages/3.21/bioc/html/ANCOMBC.html"
aria-label="Bioconductor 3.21" data-astro-cid-sdvudldn="">3.21</a>,
<a href="/packages/3.20/bioc/html/ANCOMBC.html"
aria-label="Bioconductor 3.20" data-astro-cid-sdvudldn="">3.20</a>,
<a href="/packages/3.19/bioc/html/ANCOMBC.html"
aria-label="Bioconductor 3.19" data-astro-cid-sdvudldn="">3.19</a>,
<a href="/packages/3.18/bioc/html/ANCOMBC.html"
aria-label="Bioconductor 3.18" data-astro-cid-sdvudldn="">3.18</a>,
<a href="/packages/3.17/bioc/html/ANCOMBC.html"
aria-label="Bioconductor 3.17" data-astro-cid-sdvudldn="">3.17</a>,
<a href="/packages/3.16/bioc/html/ANCOMBC.html"
aria-label="Bioconductor 3.16" data-astro-cid-sdvudldn="">3.16</a>,
<a href="/packages/3.15/bioc/html/ANCOMBC.html"
aria-label="Bioconductor 3.15" data-astro-cid-sdvudldn="">3.15</a>,
<a href="/packages/3.14/bioc/html/ANCOMBC.html"
aria-label="Bioconductor 3.14" data-astro-cid-sdvudldn="">3.14</a>,
<a href="/packages/3.13/bioc/html/ANCOMBC.html"
aria-label="Bioconductor 3.13" data-astro-cid-sdvudldn="">3.13</a>,
<a href="/packages/3.12/bioc/html/ANCOMBC.html"
aria-label="Bioconductor 3.12" data-astro-cid-sdvudldn="">3.12</a>

</div>

## Microbiome differential abudance and correlation analyses with bias correction

<div id="badges-box" class="sidebar-box" pagefind-ignore=""
astro-cid-sdvudldn="">

<div class="section badges" astro-cid-sdvudldn="">

<a href="#archives" data-astro-cid-sdvudldn=""><img
src="/shields/availability/release/ANCOMBC.svg"
title="Whether the package is available on all platforms; click for details."
data-astro-cid-sdvudldn="" alt="Platform availability badge" /></a><a href="/packages/stats/bioc/ANCOMBC/" data-astro-cid-sdvudldn=""><img
src="/shields/downloads/release/ANCOMBC.svg"
title="Ranking by number of downloads. A lower number means the package is downloaded more frequently. Determined within a package type (software, experiment, annotation, workflow) and uses the number of distinct IPs for the last 12 months."
data-astro-cid-sdvudldn="" alt="Ranking badge" /></a><a href="https://support.bioconductor.org/tag/ancombc"
data-astro-cid-sdvudldn=""><img src="/shields/posts/ANCOMBC.svg"
title="Support site activity, last 6 months: answered posts / total posts."
data-astro-cid-sdvudldn="" alt="Support activity badge" /></a><a href="#since" data-astro-cid-sdvudldn=""><img
src="/shields/years-in-bioc/ANCOMBC.svg"
title="How long since the package was first in a released Bioconductor version (or is it in devel only)."
data-astro-cid-sdvudldn="" alt="Years in BioConductor badge" /></a><a
href="https://bioconductor.org/checkResults/3.23/bioc-LATEST/ANCOMBC/"
data-astro-cid-sdvudldn=""><img
src="/shields/build/release/bioc/ANCOMBC.svg"
title="build results; click for full report" data-astro-cid-sdvudldn=""
alt="Build results badge" /></a><a
href="https://bioconductor.org/checkResults/3.23/bioc-LATEST/ANCOMBC/"
data-astro-cid-sdvudldn=""><img
src="/shields/lastcommit/release/bioc/ANCOMBC.svg"
title="time since last commit. possible values: today, &lt; 1 week, &lt; 1 month, &lt; 3 months, since release, before release"
data-astro-cid-sdvudldn="" alt="Last commit badge" /></a><a href="#since" data-astro-cid-sdvudldn=""><img
src="/shields/dependencies/release/ANCOMBC.svg"
title="Number of recursive dependencies needed to install package."
data-astro-cid-sdvudldn="" alt="Dependency count badge" /></a>

</div>

DOI: <a href="https://doi.org/10.18129/B9.bioc.ANCOMBC"
data-astro-cid-sdvudldn=""
title="DOI for use in publications, etc., will always redirect to current release version (or devel if package is not in release yet).">10.18129/B9.bioc.ANCOMBC</a>

</div>

\

<div class="package-info" astro-cid-sdvudldn="">

**Bioconductor version:** Release (3.23)

ANCOMBC is a package containing differential abundance (DA) and
correlation analyses for microbiome data. Specifically, the package
includes Analysis of Compositions of Microbiomes with Bias Correction 2
(ANCOM-BC2), Analysis of Compositions of Microbiomes with Bias
Correction (ANCOM-BC), and Analysis of Composition of Microbiomes
(ANCOM) for DA analysis, and Sparse Estimation of Correlations among
Microbiomes (SECOM) for correlation analysis. Microbiome data are
typically subject to two sources of biases: unequal sampling fractions
(sample-specific biases) and differential sequencing efficiencies
(taxon-specific biases). Methodologies included in the ANCOMBC package
are designed to correct these biases and construct statistically
consistent estimators.

**Author:** Huang Lin \[cre, aut\]
<a href="https://orcid.org/0000-0002-4892-7871" class="orcid-container"
data-astro-cid-sdvudldn="" title="ORCID iD"><img src="/images/orcid.png"
class="orcid-icon" data-astro-cid-sdvudldn="" alt="ORCID iD" /> <span
class="orcid-expanded" data-astro-cid-sdvudldn=""> ORCID:
0000-0002-4892-7871 </span></a>

**Maintainer:** Huang Lin \<huanglinfrederick at gmail.com\>

<div id="citation" pagefind-ignore="">

**Citation (from within R, enter `citation("ANCOMBC")`):**

<div id="citation-text" class="bioc-citation"
citation-url="/packages/3.23/bioc/citations/ANCOMBC/citation.html">

Huang Lin. *ANCOMBC: Microbiome differential abudance and correlation
analyses with bias correction*.
doi:[10.18129/B9.bioc.ANCOMBC](https://doi.org/10.18129/B9.bioc.ANCOMBC),
R package version 2.14.0, https://bioconductor.org/packages/ANCOMBC.

<span class="small">Generated from the package metadata; it may differ
from the package's own citation.</span>

</div>

</div>

</div>

</div>

### Installation

To install this package, start R (version "4.6") and enter:

```
if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("ANCOMBC")
```

For older versions of R, please refer to the appropriate
<a href="/about/release-announcements/"
data-astro-cid-sdvudldn="">Bioconductor release</a>.

### Documentation

To view documentation for the version of this package installed in your
system, start R and enter:

```
browseVignettes("ANCOMBC")
```

|  |  |  |
|----|----|----|
| ANCOM Tutorial | <a href="/packages/3.23/bioc/vignettes/ANCOMBC/inst/doc/ANCOM.html"
data-astro-cid-sdvudldn="">HTML</a> | <a href="/packages/3.23/bioc/vignettes/ANCOMBC/inst/doc/ANCOM.R"
data-astro-cid-sdvudldn="">R Script</a> |
| ANCOM-BC Tutorial | <a href="/packages/3.23/bioc/vignettes/ANCOMBC/inst/doc/ANCOMBC.html"
data-astro-cid-sdvudldn="">HTML</a> | <a href="/packages/3.23/bioc/vignettes/ANCOMBC/inst/doc/ANCOMBC.R"
data-astro-cid-sdvudldn="">R Script</a> |
| ANCOM-BC2 Tutorial | <a href="/packages/3.23/bioc/vignettes/ANCOMBC/inst/doc/ANCOMBC2.html"
data-astro-cid-sdvudldn="">HTML</a> | <a href="/packages/3.23/bioc/vignettes/ANCOMBC/inst/doc/ANCOMBC2.R"
data-astro-cid-sdvudldn="">R Script</a> |
| SECOM Tutorial | <a href="/packages/3.23/bioc/vignettes/ANCOMBC/inst/doc/SECOM.html"
data-astro-cid-sdvudldn="">HTML</a> | <a href="/packages/3.23/bioc/vignettes/ANCOMBC/inst/doc/SECOM.R"
data-astro-cid-sdvudldn="">R Script</a> |
| Tutorial on Data Sanity and Integrity Checks | <a
href="/packages/3.23/bioc/vignettes/ANCOMBC/inst/doc/data_sanity_check.html"
data-astro-cid-sdvudldn="">HTML</a> | <a
href="/packages/3.23/bioc/vignettes/ANCOMBC/inst/doc/data_sanity_check.R"
data-astro-cid-sdvudldn="">R Script</a> |
| Reference Manual | <a href="/packages/3.23/bioc/manuals/ANCOMBC/man/ANCOMBC.pdf"
data-astro-cid-sdvudldn="">PDF</a> |  |
| NEWS | <a href="/packages/3.23/bioc/news/ANCOMBC/NEWS"
data-astro-cid-sdvudldn="">Text</a> |  |

<div class="info-section-button-padding" astro-cid-sdvudldn="">

<a href="https://support.bioconductor.org/tag/ancombc"
class="brand-border-button" data-astro-cid-sdvudldn=""><span
class="span-brand format-bold" data-astro-cid-sdvudldn=""> Need some
help? Ask on the Bioconductor Support site! <img
src="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIxNCIgaGVpZ2h0PSIxNSIgdmlld2JveD0iMCAwIDE0IDE1IiBmaWxsPSJub25lIiBhcmlhLWhpZGRlbj0idHJ1ZSIgZGF0YS1hc3Ryby1jaWQtc2R2dWRsZG4+IDxwYXRoIGQ9Ik01LjI1IDMuNjY2NjVMOS4zMzMzMyA3Ljc0OTk4TDUuMjUgMTEuODMzMyIgc3Ryb2tlPSIjMzc5MkFEIiBzdHJva2Utd2lkdGg9IjIuMiIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIiBkYXRhLWFzdHJvLWNpZC1zZHZ1ZGxkbiAvPiA8L3N2Zz4=" />
</span></a>

</div>

### Details

|  |  |
|----|----|
| biocViews | <a href="/packages/3.23/BiocViews.html#___DifferentialExpression"
data-astro-cid-sdvudldn="">DifferentialExpression</a>, <a href="/packages/3.23/BiocViews.html#___Microbiome"
data-astro-cid-sdvudldn="">Microbiome</a>, <a href="/packages/3.23/BiocViews.html#___Normalization"
data-astro-cid-sdvudldn="">Normalization</a>, <a href="/packages/3.23/BiocViews.html#___Sequencing"
data-astro-cid-sdvudldn="">Sequencing</a>, <a href="/packages/3.23/BiocViews.html#___Software"
data-astro-cid-sdvudldn="">Software</a> |
| Version | 2.14.0 |
| In Bioconductor since | BioC 3.12 (R-4.0) (6 years) |
| License | Artistic-2.0 |
| Depends | R (\>= 4.5.0) |
| Imports | stats, <a href="https://cran.r-project.org/package=DescTools"
data-astro-cid-sdvudldn="">DescTools</a>, <a href="https://cran.r-project.org/package=Hmisc"
data-astro-cid-sdvudldn="">Hmisc</a>, <a href="https://cran.r-project.org/package=MASS"
data-astro-cid-sdvudldn="">MASS</a>, <a href="https://cran.r-project.org/package=Matrix"
data-astro-cid-sdvudldn="">Matrix</a>, <a href="https://cran.r-project.org/package=Rdpack"
data-astro-cid-sdvudldn="">Rdpack</a>, <a href="https://cran.r-project.org/package=doParallel"
data-astro-cid-sdvudldn="">doParallel</a>, <a href="https://cran.r-project.org/package=doRNG"
data-astro-cid-sdvudldn="">doRNG</a>, <a href="https://cran.r-project.org/package=energy"
data-astro-cid-sdvudldn="">energy</a>, <a href="https://cran.r-project.org/package=foreach"
data-astro-cid-sdvudldn="">foreach</a>, <a href="https://cran.r-project.org/package=gtools"
data-astro-cid-sdvudldn="">gtools</a>, <a href="https://cran.r-project.org/package=lme4"
data-astro-cid-sdvudldn="">lme4</a>, <a href="https://cran.r-project.org/package=lmerTest"
data-astro-cid-sdvudldn="">lmerTest</a>, <a href="https://cran.r-project.org/package=multcomp"
data-astro-cid-sdvudldn="">multcomp</a>, <a href="https://cran.r-project.org/package=nloptr"
data-astro-cid-sdvudldn="">nloptr</a>, parallel, utils, <a href="https://cran.r-project.org/package=quadprog"
data-astro-cid-sdvudldn="">quadprog</a> |
| System Requirements |  |
| URL | <a href="https://github.com/FrederickHuangLin/ANCOMBC"
data-astro-cid-sdvudldn="">https://github.com/FrederickHuangLin/ANCOMBC</a> |
| Bug Reports | <a href="https://github.com/FrederickHuangLin/ANCOMBC/issues"
data-astro-cid-sdvudldn="">https://github.com/FrederickHuangLin/ANCOMBC/issues</a> |

See More

|  |  |
|----|----|
| Suggests | <a href="/packages/3.23/bioc/html/mia.html"
data-astro-cid-sdvudldn="">mia</a> (\>= 1.18.0), <a href="https://cran.r-project.org/package=DT"
data-astro-cid-sdvudldn="">DT</a>, <a href="/packages/3.23/bioc/html/S4Vectors.html"
data-astro-cid-sdvudldn="">S4Vectors</a>, <a href="/packages/3.23/bioc/html/SingleCellExperiment.html"
data-astro-cid-sdvudldn="">SingleCellExperiment</a>, <a href="/packages/3.23/bioc/html/SummarizedExperiment.html"
data-astro-cid-sdvudldn="">SummarizedExperiment</a>, <a href="/packages/3.23/bioc/html/TreeSummarizedExperiment.html"
data-astro-cid-sdvudldn="">TreeSummarizedExperiment</a>, <a href="https://cran.r-project.org/package=dplyr"
data-astro-cid-sdvudldn="">dplyr</a>, <a href="https://cran.r-project.org/package=knitr"
data-astro-cid-sdvudldn="">knitr</a>, <a href="https://cran.r-project.org/package=magrittr"
data-astro-cid-sdvudldn="">magrittr</a>, <a href="/packages/3.23/bioc/html/microbiome.html"
data-astro-cid-sdvudldn="">microbiome</a>, <a href="/packages/3.23/bioc/html/phyloseq.html"
data-astro-cid-sdvudldn="">phyloseq</a>, <a href="https://cran.r-project.org/package=rmarkdown"
data-astro-cid-sdvudldn="">rmarkdown</a>, <a href="https://cran.r-project.org/package=testthat"
data-astro-cid-sdvudldn="">testthat</a>, <a href="https://cran.r-project.org/package=tidyr"
data-astro-cid-sdvudldn="">tidyr</a>, <a href="https://cran.r-project.org/package=tidyverse"
data-astro-cid-sdvudldn="">tidyverse</a> |
| Linking To |  |
| Enhances |  |
| Depends On Me |  |
| Imports Me | <a href="/packages/3.23/bioc/html/benchdamic.html"
data-astro-cid-sdvudldn="">benchdamic</a> |
| Suggests Me | <a href="/packages/3.23/bioc/html/dar.html"
data-astro-cid-sdvudldn="">dar</a>, <a href="https://cran.r-project.org/package=MiscMetabar"
data-astro-cid-sdvudldn="">MiscMetabar</a> |
| Links To Me |  |
| Build Report | <a
href="https://bioconductor.org/checkResults/3.23/bioc-LATEST/ANCOMBC/"
data-astro-cid-sdvudldn="">Build Report</a>, <a href="https://bioc-release.r-universe.dev/ANCOMBC"
data-astro-cid-sdvudldn="">r-universe</a> |

### Package Archives

Follow <a href="/install/#install-bioconductor-packages"
data-astro-cid-sdvudldn="">Installation</a> instructions to use this
package in your R session.

|  |  |
|----|----|
| Source Package | <a href="/packages/3.23/bioc/src/contrib/ANCOMBC_2.14.0.tar.gz"
data-astro-cid-sdvudldn="">ANCOMBC_2.14.0.tar.gz</a> |
| Windows Binary (x86_64) | <a href="/packages/3.23/bioc/bin/windows/contrib/4.6/ANCOMBC_2.14.0.zip"
data-astro-cid-sdvudldn="">ANCOMBC_2.14.0.zip</a> |
| macOS Binary (big-sur-x86_64) | <a
href="/packages/3.23/bioc/bin/macosx/big-sur-x86_64/contrib/4.6/ANCOMBC_2.14.0.tgz"
data-astro-cid-sdvudldn="">ANCOMBC_2.14.0.tgz</a> |
| macOS Binary (sonoma-arm64) | <a
href="/packages/3.23/bioc/bin/macosx/sonoma-arm64/contrib/4.6/ANCOMBC_2.14.0.tgz"
data-astro-cid-sdvudldn="">ANCOMBC_2.14.0.tgz</a> |
| Source Repository | git clone https://git.bioconductor.org/packages/ANCOMBC |
| Source Repository (Developer Access) | git clone git@git.bioconductor.org:packages/ANCOMBC |
| Package Short Url | <a href="https://bioconductor.org/packages/ANCOMBC/"
data-astro-cid-sdvudldn=""
title="For citation in publications, etc., please use DOI: 10.18129/B9.bioc.ANCOMBC">https://bioconductor.org/packages/ANCOMBC/</a> |
| Package Downloads Report | <a href="/packages/stats/bioc/ANCOMBC/"
data-astro-cid-sdvudldn="">Download Stats</a> |

</div>

</div>
