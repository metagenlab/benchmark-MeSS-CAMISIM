include { SUBSAMPLE } from "../modules/subsample"
include { MESS_TABLES } from "../modules/mess/tables"
include { CAMISIM_TABLES } from "../modules/camisim/tables"
include { CAMISIM_CONFIG } from "../modules/camisim/configs"


workflow SETUP {
    take:
    nbs
    size
    cpus
    seed
    mu
    sigma
    config
    summary
 
    main:
    SUBSAMPLE(nbs, seed, mu, sigma, summary)
    SUBSAMPLE.out.fasta.set{ch_fasta}
    SUBSAMPLE.out.table.set{ch_subsamples}
    MESS_TABLES(ch_subsamples)
    MESS_TABLES.out.set{ch_mess_tables}
    CAMISIM_TABLES(ch_subsamples)
    CAMISIM_TABLES.out.set{ch_camisim_tables}
    CAMISIM_CONFIG(config, cpus, size, ch_camisim_tables)
    CAMISIM_CONFIG.out.set{ch_camisim_configs}

    emit:
    fasta = ch_fasta
    asm_summaries = ch_subsamples
    cami_tables = ch_camisim_tables
    cami_configs = ch_camisim_configs
    mess_tables = ch_mess_tables
}