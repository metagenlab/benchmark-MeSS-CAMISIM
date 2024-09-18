nextflow.enable.dsl = 2

include { RUN } from "./workflows/run"

workflow {
    RUN ()
}