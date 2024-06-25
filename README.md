## MCLA (Microchimerism Literature Atlas)

![R Version](https://img.shields.io/badge/R-v4.1.3-blue)
![Shiny Version](https://img.shields.io/badge/Shiny-v1.7.1-brightgreen)
![Tests Passing](https://img.shields.io/badge/tests-passing-brightgreen)


<img src="[MCLA](https://github.com/microchimerism/MCLA/blob/main/__docs__/MCLA.png)https://github.com/microchimerism/MCLA/blob/main/__docs__/MCLA.png?raw=true" width="150" title="GTC" alt="cellpose" align="right" vspace="50">

The [Microchimerism Literature Atlas (MCLA)](https://literature-atlas.microchimerism.info) is a tool designed for creating and hosting a literature dataset — in our special case, with over 15,000 references in the field of microchimerism (MC) research. 
The MCLA is intended to be an essential resource for research (groups) providing useful tools for comprehensive and efficient literature analysis of a research field, with online access available to multiple users.

For more detailed information about the possibilities of the MCLA please read the "Info" tag of the online application.

### Features:

- **Modular Structure:** Navigate through different sections via a user-friendly Graphical User Interface (GUI).
- **Data Table:** View key information in an expandable table with options for multidimensional searches and data export (CSV, TXT, XLSX).
- **Advanced Search:** Execute precise queries with support for word parts, phrases, and logical operators (AND, OR, NOT).

### Functional Sections:

- **Chart View:** Visualize publication data, keyword frequency, and author activity. Graphs adapt to active filter settings, allowing for tailored insights.
- **Network View:** Investigate the citation network to understand relationships between papers. Highlight connections and access detailed paper information by hovering over nodes.
- **Filter Settings:** Apply predefined search strings typical for the research field to refine searches, enhancing specificity and relevance.

## Setup of the MCLA

The setup of the MCLA involves two steps: using R scripts for preprocessing and then starting the MCLA in a Shiny Server environment. 

### Downloading and Preprocessing the Literature Dataset

PubMed search query results (defined in `preprocessing/data/PubMedSearch_Parameters_*.xlsx`) are downloaded and essential information for creating the literature dataset is extracted.
Thereafter, the dataset is cleaned by removing duplicates and incomplete entries. 
To optimize server processing time and ensure smooth operation, time consuming operations are included in the preprocessing part.
Hence, the dataset is prefiltered using "Filter Settings" keywords (defined in `preprocessing/data/Filters__*.csv`) and nodes and edges of citation networks are calculated. 
After preprocessing, the files created in `preprocessing/results/` should be copied to `web_app/data/` and the file `web_app/global.R` should be adapted accordingly.

### Setup of Shiny Server Environment

To run the MCLA (in R or on a server), an R and Shiny Server environment must be set up previously.
Specific installation instructions vary depending on the operating system used — hence, we omit detailed guidelines here.
However, many detailed installation guides can be found online.

### Customizing the MCLA

The MCLA is designed for easy customization of the literature dataset, including downloading and preprocessing a custom literature dataset or modifying filter keywords.

The necessary files are mostly text files for customizing the literature tool can be found at:
- `preprocessing/data/`: Define the PubMed queries in `PubMedSearch_Parameters_*.xlsx` and the predefined "Filter Settings" in `Filters__*.csv`.
- `preprocessing/pubmed.R`: Define displayed columns for created literature dataset.
- `web_app/global.R`: Define general runtime settings.

## Acknowledgments

The MCLA is part of the 'We All Are Multitudes: The Microchimerism, Human Health and Evolution Project' that is funded by the John Templeton foundation (Grant-ID 62214). 
