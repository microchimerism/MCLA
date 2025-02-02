## MCLA (Microchimerism Literature Atlas)

![R Version](https://img.shields.io/badge/R-v4.1.3-blue)
![Shiny Version](https://img.shields.io/badge/Shiny-v1.7.1-brightgreen)
![Tests Passing](https://img.shields.io/badge/tests-passing-brightgreen)

<a href="https://github.com/microchimerism/MCLA/raw/main/__docs__/MCLA_Collage.png" target="_blank">
  <img src="https://github.com/microchimerism/MCLA/raw/main/__docs__/MCLA_Collage.png" width="400" height="210" title="MCLA" align="right">
</a>

The [Microchimerism Literature Atlas (MCLA)](https://literature-atlas.microchimerism.info) is a tool designed for creating and hosting a literature dataset — in our special case, with over 15,000 references in the field of microchimerism (MC) research.
The MCLA is intended to be an essential resource for research (groups) providing useful tools for comprehensive and efficient literature analysis of a research field, with online access available to multiple users.  
For more detailed information about the possibilities and the operation of the MCLA, please refer to the *Info* section of the web application.

### Key Features

- **User-Friendly Interface:** Use a modular structure with an intuitive Graphical User Interface (GUI) where you can navigate through different sections.
- **Comprehensive Knowledge Database:** Access a vast literature dataset containing metadata for over 15,000 references from the field of microchimerism (MC) research, covering peer-reviewed articles and reviews from 1970 to the present.
- **Clearly-Structured Data Table View:** Get the key information from the MC literature displayed in an expandable table format, making it easy to view and navigate through the data.
- **Advanced Search Function:** Execute precise multi-dimensional queries with support for word parts and whole phrase searches alongside logical operators (AND, OR, NOT).
- **Graphical Data Representation:** Graphically display important information in the form of bar plots, heatmaps, and word clouds, aiding quick identification of key trends and patterns in the dataset.
- **Dynamic Visualization:** Interactively change the graphs by applying different filter settings.
- **Reference Network Establishment:** Establish a reference network of a specific paper and get a comprehensive view of the research landscape.
- **Data Export Options:** Export the obtained search results as CSV, TXT, or XLSX files for further investigation and analysis.

### Functional Sections

- **Data Table:** Presents key information from the MC literature in an expandable table format, making it easy to view and navigate through the data.
- **Filter Settings:** Combine multiple predefined search strings typical for the research field via checkboxes to refine searches, enhancing specificity and relevance.
- **Chart View:** Visualize publication data, keyword frequency, and author activity. Graphs adapt to active Filter Settings, allowing for tailored insights.
- **Network View:** Investigate the citation network to understand relationships between papers. Highlight connections and access detailed paper information by hovering over nodes.
- **Info:** Detailed description of how to operate the MCLA.

## Setup of the MCLA

The setup of the MCLA involves two steps:
- using R scripts for downloading and preprocessing the literature dataset and then
- running the MCLA (online) in a Shiny Server environment.

### Downloading and Preprocessing the Literature Dataset

PubMed search query results (defined in `preprocessing/data/PubMedSearch_Parameters_*.xlsx`) are downloaded and the essential information for creating the literature dataset is extracted.  
If a custom literature dataset is used instead of the PubMed queries, then the file flag DOWNLOAD_PUBMED has to be set to FALSE to import the dataset.  
Thereafter, the dataset is cleaned by removing duplicates and incomplete entries.
To optimize server processing time and ensure smooth operation, time consuming operations are included in the preprocessing part.
Hence, the dataset is prefiltered using *Filter Settings* keywords (defined in `preprocessing/data/Filters__*.csv`) and nodes and edges of citation networks are calculated.
After preprocessing, the files created in `preprocessing/results/` should be copied to `web_app/data/` and the file `web_app/global.R` should be adapted accordingly.

### Setup of Shiny Server Environment

To run the MCLA on a server (or in R), a Shiny Server environment must be set up previously.
Specific installation instructions vary depending on the operating system used — hence, we omit detailed guidelines here.
However, many detailed installation guides can be found online.

### Customizing the MCLA

The MCLA is designed for easy customization of the literature dataset, including downloading and preprocessing a custom literature dataset or modifying filter keywords.

The necessary files are mostly text files for customizing the literature tool can be found at:
- `preprocessing/data/`: Define the PubMed queries in `PubMedSearch_Parameters_*.xlsx` and the predefined *Filter Settings* in `Filters__*.csv`.
- `preprocessing/pubmed.R`: Define displayed columns for created literature dataset.
- `web_app/global.R`: Define general runtime settings.

## Acknowledgments

The MCLA is part of the 'We All Are Multitudes: The Microchimerism, Human Health and Evolution Project' that is funded by the John Templeton foundation (Grant-ID 62214).
