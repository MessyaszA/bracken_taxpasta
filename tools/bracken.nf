// Specify DSL2
nextflow.enable.dsl = 2

// Process definition

process Kraken2 {
    tag "${meta}"
    label 'process_high'

    publishDir "${params.outdir}/kraken2/",
        mode: "copy",
        overwrite: true,
        saveAs: { filename -> filename }

    container "alemenze/kraken2-docker"

    input:
        tuple val(meta), path(reads)
        path(db)

    output:
        tuple val(meta), path("*kraken2.krona"), emit: kraken2krona
        tuple val(meta), path("*_kraken2.report"), emit: report
        path ("*_kraken2.output"), emit: kraken_output

    script:
        """
        kraken2 -db $db --report ${meta}_kraken2.report $reads > ${meta}_kraken2.output
        cut -f 2,3 ${meta}_kraken2.output > ${meta}_kraken2.krona
        """
}

process Krona {

    container "alemenze/kraken2-docker"
    label 'process_medium'

    publishDir "${params.outdir}/kraken2_krona/${meta}",
        mode: "copy",
        overwrite: true,
        saveAs: { filename -> filename }
    
    input:
        tuple val(meta), path(krona_in)
    
    output:
        path("*_taxonomy_krona.html")

    script:
        """
        ktImportTaxonomy -o ${meta}_kraken2_taxonomy_krona.html $krona_in
        """
}

process BRACKEN {
    tag "${meta}"
    label 'process_high'

    publishDir "${params.outdir}/bracken/",
        mode: "copy",
        overwrite: true,
        saveAs: { filename -> filename }

    container "alemenze/kraken2-docker"

    input:
        tuple val(meta), path(reads)
        path(db)

    output:
        path("*.brackreport"), emit: brack_report
        path("*_bracken.tsv"), emit: tsv

    script:
        """
        bracken -d $db -r $params.read_len -i $reads -l $params.kraken_tax_level -o ${meta}_bracken.tsv -w ${meta}.brackreport
        """
}
