nextflow.enable.dsl = 2

if (params.subsample) {
    include { SUBSETS as RUN } from "./workflows/subsets.nf"
} else {
    include { RUN              } from "./workflows/run"
}

workflow {
    RUN ()
}