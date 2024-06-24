## MCLA (Microchimerism Literature Atlas)

The [Microchimerism Literature Atlas (MCLA)](https://literature-atlas.microchimerism.info) is a tool designed for creating and hosting a literature dataset — in our case, with over 15,000 references in the field of microchimerism (MC) research. 
The MCLA is intended to be an essential resource for researchers, providing useful tools for comprehensive and efficient literature analysis, with online access available to multiple users.

### Features:

- **Modular Structure:** Navigate through different sections via a user-friendly Graphical User Interface (GUI).
- **Data Table:** View key information in an expandable table with options for multidimensional searches and data export (CSV, TXT, XLSX).
- **Advanced Search:** Execute precise queries with support for word parts, phrases, and logical operators (AND, OR, NOT).

### Functional Sections:

- **Chart View:** Visualize publication data, keyword frequency, and author activity. Graphs adapt to active filter settings, allowing for tailored insights.
- **Network View:** Investigate the citation network to understand relationships between papers. Highlight connections and access detailed paper information by hovering over nodes.
- **Filter Settings:** Craft and apply complex search strings to refine searches, enhancing specificity and relevance.

## Setup of the MCLA

Setting up the MCLA involves two steps: using R-scripts initially and then setting up a Shiny-server environment. 
The MCLA is designed for easy customization of the literature dataset, including downloading and preprocessing a custom literature dataset or modifying filter keywords.

The necessary files for customizing the literature tool can be found at:
- `preprocessing/data/`
- `preprocessing/pubmed.R`
- `web_app/global.R`

### Downloading and Preprocessing the Literature Dataset

PubMed search query results (defined in `preprocessing/data/PubMedSearch_Parameters_*.xlsx`) are downloaded, and essential information for creating the literature dataset is extracted.
The dataset is cleaned by removing duplicates and incomplete entries. 
To optimize server processing time and ensure smooth operation, the dataset is prefiltered using "Filter Settings" keywords (defined in `preprocessing/data/Filters__*.csv`), and nodes and edges of citation networks are calculated. 
After preprocessing, the files created in `preprocessing/results/` should be copied to `web_app/data/`, and adjustments should be made to `web_app/global.R` to reflect the date of the data files.

### Setup of Shiny-server Environment

To run the MCLA on the server, an R and Shiny-server environment must be set up. 
Specific installation instructions vary depending on the server's operating system. 
Detailed installation guides can be found online. 
After installation, the `web_app/` folder should be copied to the Shiny application folder, and the Shiny server should be restarted.
