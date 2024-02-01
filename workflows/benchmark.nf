


//include { DOWNLOAD } from "../subworkflows/download"
include { SETUP } from "../subworkflows/setup"
include { SIMULATE } from "../subworkflows/simulate"

if (params.custom_range) {
    ch_nbs = Channel.fromList(params.custom_range.tokenize(","))
} else {
    ch_nbs = Channel.fromList((params.start..params.nb).step(params.step))
}

workflow BENCHMARK {
    
    SETUP ( 
        ch_nbs,
        params.size,
        params.cpus, 
        params.seed,
        params.mu, 
        params.sigma, 
        params.config, 
        params.summary
        )

    ch_fasta = SETUP.out.fasta
    ch_asm_summaries = SETUP.out.asm_summaries
    ch_mess_tables = SETUP.out.mess_tables
    ch_cami_configs = SETUP.out.cami_configs

    ch_mess_input = ch_mess_tables.join(ch_asm_summaries).join(ch_fasta)
    SIMULATE ( 
        ch_mess_input, 
        ch_cami_configs, 
        params.custom_profile,
        params.size,
        params.mean_len,
        params.frag_len,
        params.frag_sd
        )
    
}