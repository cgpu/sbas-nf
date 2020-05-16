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
log.info "Input ijc matrix  : ${params.ijc}"
log.info "Input sjc matrix  : ${params.sjc}"
log.info "Pheno metadata    : ${params.pData}"
log.info "Feature metadata  : ${params.fData}"
log.info "Results directory : ${params.output}"
log.info "\n"

def helpMessage() {
    log.info """
    Usage:
    The typical command for running the pipeline is as follows:
    nextflow run TheJacksonLaboratory/sbas --tissues_csv file1 --ijc file2 --sjc file3 --pData file4 --fData file5 -profile docker
    Mandatory arguments:
      --tissues_csv             Path to input file. The suffix of the file must be .csv
                                The csv file is expected to have two columns with header
                                Column 1, must be a numeric index of the row
                                Column 2, must correspond to the name of the tissue

      --ijc                     The rmats ijc output matrix for all samples (eg. SraRunTable.noCram.noExome.noWGS.totalRNA.txt)
      --sjc                     The rmats sjc output matrix for all samples (eg. SraRunTable.noCram.noExome.noWGS.totalRNA.txt)
      --pData                   The phenotypic metadata for the samples present in the rmats matrices (eg. SraRunTable.noCram.noExome.noWGS.totalRNA.txt)
      --fData                   The feature metadata for the features (exons) present in the rmats matrices (eg. fromGTF.SE.txt)
      -profile                  Configuration profile to use. Can use multiple (comma separated)
                                Available: testdata, docker, ...
    Optional:
      --output                   Path to output directory. 
                                Default: 'results'

    """.stripIndent()
}

/*********************************
 *      CHANNELS SETUP           *
 *********************************/

// Input files

ch_ijc   = Channel.fromPath(params.ijc, checkIfExists: true)
ch_sjc   = Channel.fromPath(params.sjc, checkIfExists: true)
ch_pData = Channel.fromPath(params.pData, checkIfExists: true)
ch_fData = Channel.fromPath(params.fData, checkIfExists: true)


// Input list .csv file of many .tar.gz
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
    tag "${tissue_index}-${tissue_name}"
    publishDir "results/${tissue_name}"
    echo true

    input:
    set val(tissue_index), val(tissue_name) from ch_tissues_indices
    each file(ijc) from ch_ijc
    each file(scj) from ch_sjc
    each file(pData) from ch_pData
    each file(fData) from ch_fData

    output:
    file "/sbas/data/data/*"
    file "/sbas/data/jupyter/${tissue_name}_diff_splicing.ipynb"

    script:
    """
    mv $ijc /sbas/data/
    mv $scj /sbas/data/
    mv $fData /sbas/data/
    mv $pData /sbas/data/


    ls *

    cd /sbas/jupyter
    papermill AllTissueJunctionAnalysis.ipynb ${tissue_name}_diff_splicing.ipynb -p tissue_index $tissue_index
    """
}
