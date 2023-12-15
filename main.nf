#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

////////////////////////////////////////////////////
/* --              Parameter setup             -- */
////////////////////////////////////////////////////

////////////////////////////////////////////////////
/* --           Load Modules                  -- */
////////////////////////////////////////////////////

include { Kraken2 } from './tools/bracken'
include { BRACKEN } from './tools/bracken'
include { Krona } from './tools/bracken'
include { TAXPASTA } from './tools/taxpasta' 

////////////////////////////////////////////////////
/* --           RUN MAIN WORKFLOW              -- */
////////////////////////////////////////////////////

workflow {
    {
        ch_ont_fastq = Channel.empty()
        ch_ont_fastq = Channel.fromPath(params.reads)
            .map{ it -> tuple(it.baseName, it) }
            //.subscribe { println it }

        Kraken2(
            ch_ont_fastq,
            params.kraken_db
        )

         BRACKEN(
            Kraken2.out.report,
            params.kraken_db
        )

        Krona(
            Kraken2.out.bracken_krona
        )

        TAXPASTA(
            BRACKEN.out.tsv.collect()
        )
    }
}
