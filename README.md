# MCLA (Microchimerism Literature Atlas)

The [Microchimerism Literature Atlas (MCLA)](https://literature-atlas.microchimerism.info) is an advanced literature dataset offering powerful tools for exploring and analyzing over 15,000 references in the field of MC research. The MCLA is run with Shiny on a server, allowing online access by multiple users to share and investigate data. The literature is downloaded in a preprocessing step from PubMed, cleaned, and processed to save server performance.

## Features

- **Modular Structure**: Navigate different sections via a user-friendly Graphical User Interface (GUI).
- **Data Table**: View key information in an expandable table with options for multidimensional searches and data export (CSV, TXT, XLSX).
- **Advanced Search**: Execute precise queries with support for word parts, phrases, and logical operators (AND, OR, NOT).

## Functional Sections

- **Chart View**: Visualize publication data, keyword frequency, and author activity. Graphs adapt to active filter settings, allowing tailored insights.
- **Network View**: Investigate the citation network to understand the relationships between papers. Highlight connections and access detailed paper information by hovering over nodes.
- **Filter Settings**: Craft and apply complex search strings to refine your searches, enhancing specificity and relevance.

The MCLA is designed to be an essential resource for researchers, providing powerful tools for comprehensive and efficient literature analysis in the field of microchimerism.

## Setup of the Microchimerism Literature Atlas

The literature tool is programmed in such a way that it can be easily adapted to meet one’s own need for a literature dataset, e.g., by downloading and preprocessing a custom literature dataset or by changing the possible filter keywords. The files for customizing the literature tool can be found in:
- `preprocessing/data/`
- `preprocessing/pubmed.R`
- `web_app/global.R`

The literature dataset and the literature network are created with an R script by downloading and processing the results of PubMed queries in the preprocessing pipeline. The results of the search queries (defined in the file `preprocessing/data/PubMedSearch_Parameters_*.xlsx`) are downloaded from PubMed, and the essential information is extracted afterward. The dataset is cleaned by removing duplicates and incomplete entries. To keep server processing time to a minimum and ensure smooth operation on lower-performing servers, the dataset is prefiltered by applying the filter settings keywords (defined in the file `preprocessing/data/Filters__*.csv`), and the nodes and edges of the citation networks are calculated.

After preprocessing, the files created in the `preprocessing/results/` folder should be copied into the `web_app/data/` folder, and the `web_app/global.R` file should be adjusted accordingly to reflect the date of the data files.

## Setup of Shiny Environment on Server

To run the MCLA on the server, an R and Shiny environment must first be set up. Since the setup depends on the operating system of the server, the instructions are omitted here. However, various step-by-step instructions can be found on the web. After the installation, the `web_app/` folder should be copied into the Shiny application folder, and the Shiny server should be restarted.
