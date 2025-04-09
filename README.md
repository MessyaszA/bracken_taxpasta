# bracken_taxpasta
Combine kracken/bracken result tables into biom and tsv files using taxpasta

[![Nextflow](https://img.shields.io/badge/nextflow%20DSL2-%E2%89%A520.11.0--edge-23aa62.svg?labelColor=000000)](https://www.nextflow.io/)
[![run with slurm](https://img.shields.io/badge/run%20with-slurm-ff4d4d.svg?labelColor=000000)](https://slurm.schedmd.com/)

## Description
This workflow will take processed/raw fastq files, run them through a Kraken2/Bracken workflow, and combine results into one file using taxpasta. Outputs can then be implemented into downstream analyses like phyloseq. 

## Databases
Setting up this pipeline for execution requires a built kraken/bracken database. For example to run a 16S workflow a custom Kraken/Bracken database must be built specifying 16S sequence reads lengths (~1600bp). 
