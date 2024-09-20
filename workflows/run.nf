
include { DOWNLOAD  } from "../subworkflows/download.nf"
include { MESS      } from "../modules/mess/simulate.nf"
include { CAMISIM   } from "../subworkflows/camisim.nf"
include { SUBSAMPLE } from "../modules/subsample"

workflow RUN {
    if (params.subsample) {
        uniq = false
        input_ch = Channel.of(params.input)
    } else {
        input_ch = Channel.fromPath("${params.input}/*.tsv")
                          .collect()
        uniq = true
    }

    DOWNLOAD(input_ch, uniq)

    if (params.subsample) {
        SUBSAMPLE(params.subsets, 
                  params.seed, 
                  DOWNLOAD.out.summary)
        samples_ch = SUBSAMPLE.out.flatten()
                                  .map { it -> 
                                  [it.baseName.tokenize(".")[0].tokenize("subset_")[0], it] 
                                }
    } else {
        samples_ch = Channel.fromPath("${params.input}/*.tsv")
                            .map { it -> [it.baseName.tokenize(".")[0], it] }
    }
    
                        
    taxdump_ch = DOWNLOAD.out.taxdump.collect().toList()
    prefix_ch = Channel.fromPath(params.container_prefix)
    error_profile_ch = Channel.fromPath("${params.err_path}")
    mess_ch = samples_ch.combine(DOWNLOAD.out.summary)
                        .combine(taxdump_ch)
                        .combine(prefix_ch)
                        .combine(error_profile_ch)
    if (params.total_bases) {
        bases = params.total_bases
    } else {
        bases = false
    }
    MESS(mess_ch,
        params.err_name,
        bases,
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




