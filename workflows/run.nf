include { CAT_FASTQ           } from "../modules/cat_fastq.nf"
include { SEQKIT_SORT         } from "../modules/seqkit/sort.nf"
include { SEQKIT_SPLIT2       } from "../modules/seqkit/split.nf"
include { CAMISIM_TABLES      } from "../modules/camisim/tables.nf"
include { CAMISIM_CONFIG      } from "../modules/camisim/configs.nf"
include { CAMISIM_SIMULATE    } from "../modules/camisim/simulate.nf"
include { MESS_SIMULATE       } from "../modules/mess/simulate.nf"

workflow RUN {
    ch_samples = Channel.fromPath("${params.input}/*.tsv")
                        .map{it -> [it.baseName.tokenize(".")[0], it]}
    
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
    CAMISIM_TABLES.out.set{ch_cami_tables}
    CAMISIM_CONFIG (ch_abundances,
                   params.config,
                   params.seed,
                   params.cpus,
                   params.mean_len,
                   params.frag_len,
                   params.frag_sd,
                   ch_cami_tables
                   )
    CAMISIM_CONFIG.out.set{ ch_cami_config }
    CAMISIM_SIMULATE (ch_cami_config)
    CAMISIM_SIMULATE.out.fastq.set{ch_camisim_reads}
    CAT_FASTQ(ch_camisim_reads)
    CAT_FASTQ.out.set{ch_cat_cami_fq}
    SEQKIT_SORT(ch_cat_cami_fq)
    SEQKIT_SORT.out.set{ch_sorted_fq}
    SEQKIT_SPLIT2(ch_sorted_fq)
    SEQKIT_SPLIT2.out.set{ch_split_fq}


    
}




