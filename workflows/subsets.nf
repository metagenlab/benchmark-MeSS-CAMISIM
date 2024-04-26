
include { SUBSAMPLE           } from "../modules/subsample"
include { MESS_SIMULATE       } from "../modules/mess/simulate"
include { CAMISIM_TABLES      } from "../modules/camisim/tables"
include { CAMISIM_CONFIG      } from "../modules/camisim/configs"
include { CAMISIM_SIMULATE    } from "../modules/camisim/simulate.nf"


workflow SUBSETS {
    
    SUBSAMPLE(params.subsets, params.seed, params.summary)
    ch_subsamples = SUBSAMPLE.out
    ch_samples = ch_subsamples.flatten()
                              .map { it -> [it.baseName.tokenize(".")[0].tokenize("subset_")[0], it] }

    MESS_SIMULATE (ch_samples,
                   params.summary,
                   params.seed, 
                   params.size,
                   params.err_profile,
                   params.mean_len,
                   params.frag_len,
                   params.frag_sd
                   )
    MESS_SIMULATE.out.cov.set{ch_abundances}
    CAMISIM_TABLES(ch_abundances)


    CAMISIM_TABLES.out.dist.set{ch_cami_dist}
    CAMISIM_TABLES.out.meta.set{ch_cami_meta}
    CAMISIM_TABLES.out.g2id.set{ch_cami_g2id}

    ch_cami_config_in = ch_abundances.join(ch_cami_dist).join(ch_cami_meta).join(ch_cami_g2id)
    CAMISIM_CONFIG (ch_cami_config_in,
                   params.config,
                   params.seed,
                   params.cpus,
                   params.mean_len,
                   params.frag_len,
                   params.frag_sd,
                   )
    ch_camisim_config = CAMISIM_CONFIG.out
    CAMISIM_SIMULATE (ch_camisim_config)
    
    
    
}