/*
 * Copyright (c) 2020, The Jackson Laboratory and the authors.
 *
 *   This file is part of TheJacksonLaboratory/sbas repository.
 *
 * Main TheJacksonLaboratory/sbas pipeline script for post rmats differential splicing analysis
 *
 * @authors
 * Name1 LastName1 <name.lastname1@email.com>
 * Name2 LastName2 <name.lastname2@email.com>
 */

log.info "Post-rmats differential splicing analysis version 0.1"
log.info "====================================="
log.info "Tissue table .csv : ${params.tissues_csv}"
log.info "Input notebook    : ${params.notebook}"
log.info "../data/ tar.gz   : ${params.data}"
log.info "../assets/ tar.gz : ${params.assets}"
log.info "Results directory : ${params.output}"
log.info "\n"

def helpMessage() {
    log.info """
    Usage:
    The typical command for running the pipeline is as follows:
    nextflow run cgpu/sbas-nf --tissues_csv file1 --notebook gs://my_R_notebook.ipynb --data gs://data.tar.gz --assets gs://assets.tar.gz -profile docker
    Mandatory arguments:
      --tissues_csv             Path to input file. The suffix of the file must be .csv
                                The csv file is expected to have two columns with header
                                Column 1, must be a numeric index of the row
                                Column 2, must correspond to the name of the tissue
                                The order is expected to be the same as the output of the command:
                                `levels(reduced_metadata_pData$tissue)`

      --notebook                The path to the .ipynb notebook that is to be executed
      --data                    The path to the .tar.gz archive that contains all the files used as input by the notebook from the ../data folder.
                                It is expected that upon decompressing the archive with the command `tar xvzf data.tar.gz -C ../data`
                                all input files will be in the required format for the notebook to run,
                                eg. flat file structure, and not nested in another folder.
      --assets                  The path to the .tar.gz archive that contains all the files used as input by the notebook from the ../assets folder.
                                It is expected that upon decompressing the archive with the command `tar xvzf data.tar.gz -C ../assets`
                                all input files will be in the required format for the notebook to run,
                                eg. flat file structure, and not nested in another folder.
      -profile                  Configuration profile to use. Can use multiple (comma separated)
                                Available: testdata, docker, ...
    Optional:
      --output                  Path to output directory.
                                Default: 'results'

      --ontologizer             [No value]
                                Switch flag, pass to enable the execution of the optional
                                Ontologizer process on the gene lists generated by the runNotebook process.

      --gaf                     Path to GO Annotation file. The suffix must be .gaf
                                Conditionally required when '--ontologizer' is set.

      --obo                     Path to GO ontology in obo format. The suffix muste be .obo
                                Conditionally required when '--ontologizer' is set.

    """.stripIndent()
}

/*********************************
 *      CHANNELS SETUP           *
 *********************************/

// Input files

ch_notebook = Channel.fromPath(params.notebook, checkIfExists: true)
ch_data = Channel.fromPath(params.data, checkIfExists: true)
ch_assets = Channel.fromPath(params.assets, checkIfExists: true)

// Optional Ontologizer input files

if (params.ontologizer) {
    ch_obo_file = Channel.fromPath(params.obo, checkIfExists: true)
    ch_go_annotation_file = Channel.fromPath(params.gaf, checkIfExists: true)
}


// Input list .csv file of tissues to analyse
if (params.tissues_csv.endsWith(".csv")) {
  Channel.fromPath(params.tissues_csv)
                        .ifEmpty { exit 1, "Input .csv list of input tissues not found at ${params.tissues_csv}. Is the file path correct?" }
                        .splitCsv(sep: ',',  header: true)
                        .set { ch_tissues_indices }
  }

/*********************************
 *          PROCESSES            *
 *********************************/

/*
 * Execute the notebook for each tissue
 */

 process runNotebook {
    machineType 'n1-standard-16'
    tag "${tissue_index}-${tissue_name}"
    publishDir "results/differential/per_tissue/${tissue_name}/"
    publishDir "results/differential/all_tissues/"

    input:
    set val(tissue_index), val(tissue_name) from ch_tissues_indices
    each file(notebook) from ch_notebook
    each file(data) from ch_data
    each file(assets) from ch_assets

    output:
    set val(tissue_name), file "data/se*sex_as_events_gene_set.txt", file("data/se*sex_as_events_universe.txt") into ch_ontologizer
    file "data/*_universe.txt"
    file "data/*_gene_set.txt"
    file "data/*csv"
    file "pdf/"
    file "metadata/"
    file "assets/"
    file "jupyter/${tissue_name}_diff_splicing.ipynb"

    script:
    """
    mkdir -p jupyter
    mkdir -p data
    mkdir -p pdf
    mkdir -p metadata
    mkdir -p assets

    tar xvzf $data -C data/
    tar xvzf $assets -C assets/

    cp $notebook jupyter/main.ipynb
    cd jupyter

    papermill main.ipynb ${tissue_name}_diff_splicing.ipynb -p tissue_index $tissue_index
    """
}

/*
 * Perform Gene Ontology analysis with Ontologizer
 */

 process ontologizer {
    tag "${tissue}"
    label 'ontologizer'
    publishDir "results/ontologizer/per_tissue/${tissue}/"
    publishDir "results/ontologizer/all_tissues/"

    input:
    set  val(tissue), file(gene_set), file(universe) from ch_ontologizer
    each file(go.obo) from ch_obo_file
    each file(goa_human.gaf) from ch_go_annotation_file

    output:
    file "*"

    when:  params.ontologizer

    script:
    """
    ontologizer \
    -s $gene_set \
    -p $universe \
    -g $go.obo \
    -a $goa_human.gaf \
    -c Term-For-Term \
    -m Benjamini-Hochberg \
    -n
    """
}
