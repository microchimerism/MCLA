# MCLA (Microchimerism Literature Atlas)

The [Microchimerism Literature Atlas (MCLA)](https://literature-atlas.microchimerism.info) is an tool to easily create and host a literature dataset - in our case with over 15,000 references in the field of microchimerism (MC) research.
The MCLA is designed to be an essential resource for researchers, providing useful tools for comprehensive and efficient literature analysis, allowing online access by multiple users.

### Features
- **Modular Structure**: Navigate different sections via a user-friendly Graphical User Interface (GUI).
- **Data Table**: View key information in an expandable table with options for multidimensional searches and data export (CSV, TXT, XLSX).
- **Advanced Search**: Execute precise queries with support for word parts, phrases, and logical operators (AND, OR, NOT).

### Functional Sections
- **Chart View**: Visualize publication data, keyword frequency, and author activity. Graphs adapt to active filter settings, allowing tailored insights.
- **Network View**: Investigate the citation network to understand the relationships between papers. Highlight connections and access detailed paper information by hovering over nodes.
- **Filter Settings**: Craft and apply complex search strings to refine your searches, enhancing specificity and relevance.

## Setup of the MCLA

The setup of the MCLA happens in 2 steps, using R-scripts in the first and additionally a Shiny-server environment in the second.
The MCLA is designed to be easily adapted for customizing the literature dataset, such as downloading and preprocessing a custom literature dataset or modifying filter keywords.
The files for customizing the literature tool can be found at:
- `preprocessing/data/`
- `preprocessing/pubmed.R`
- `web_app/global.R`

### Downloading and Preprocessing Dataset

The results of the PubMed search queries (defined in the file `preprocessing/data/PubMedSearch_Parameters_*.xlsx`) are downloaded from PubMed and the essential information for creating the literature dataset is extracted afterwards.
The dataset is cleaned by removing duplicates and incomplete literature entries.
In order to keep the server processing time to a minimum and ensure a smooth operation, the dataset is prefiltered by the "Filter Settings" keywords (defined in the file `preprocessing/data/Filters__*.csv`), and the nodes and edges of the citation networks are calculated.
After preprocessing, the files created in the `preprocessing/results/` folder should be copied into the `web_app/data/` folder, and the `web_app/global.R` file should be adjusted accordingly to reflect the date of the data files.

### Setup of Shiny-server Environment

To run the MCLA on the server, an R and Shiny-server environment must be set up first.
Since the setup varies with the operating system of the server, we refrain here from providing an detailed installation guide - however, various step-by-step instructions can be found online. 
After the installation, the `web_app/` folder should be copied into the Shiny application folder, and the Shiny server should be restarted.
