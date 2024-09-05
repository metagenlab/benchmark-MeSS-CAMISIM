
include { DOWNLOAD       } from "../subworkflows/download.nf"
include { MESS           } from "../modules/mess/simulate.nf"
include { CAMISIM        } from "../subworkflows/camisim.nf"

workflow RUN {
    
    tables_ch = Channel.fromPath("${params.input}/*.tsv")
                       .collect()
    DOWNLOAD(tables_ch, params.ncbi_key)

    
    samples_ch = Channel.fromPath("${params.input}/*.tsv")
                        .map{it -> [it.baseName.tokenize(".")[0], it]}
                        
    taxdump_ch = DOWNLOAD.out.taxdump.collect().toList()
    prefix_ch = Channel.fromPath(params.container_prefix)
    error_profile_ch = Channel.fromPath("${params.err_path}")
    mess_ch = samples_ch.combine(DOWNLOAD.out.summary)
                        .combine(taxdump_ch)
                        .combine(prefix_ch)
                        .combine(error_profile_ch)
    MESS(mess_ch,
        params.err_name,
        params.size,
        params.seed,
        params.mean_len,
        params.frag_len,
        params.frag_sd
        )
    coverages_ch = MESS.out.cov

    CAMISIM(coverages_ch,
            taxdump_ch,
            params.cami_config,
            params.seed,
            params.cpus,
            params.mean_len,
            params.frag_len,
            params.frag_sd
            )

}




