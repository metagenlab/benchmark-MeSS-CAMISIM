include { CAMISIM_CONFIG as CONFIG     } from '../modules/camisim/configs.nf'
include { CAMISIM_TABLES as TABLES     } from '../modules/camisim/tables.nf'
include { CAMISIM_SIMULATE as SIMULATE } from '../modules/camisim/simulate.nf'
include { CAT_FASTQ                    } from '../modules/cat_fastq.nf'
include { SEQKIT_SORT                  } from '../modules/seqkit/sort.nf'
include { SEQKIT_SPLIT2                } from '../modules/seqkit/split.nf'


workflow CAMISIM {
  take:
  coverages
  taxdump  
  config   
  seed     
  cpus     
  mean_len 
  frag_len 
  frag_sd  

  main:
  TABLES(coverages)
  default_conf_ch = Channel.fromPath(config)
  config_ch = coverages
    .join(TABLES.out.dist)
    .join(TABLES.out.meta)
    .join(TABLES.out.g2id)
    .combine(default_conf_ch)
    .combine(taxdump)
  CONFIG(
    config_ch,
    seed,
    cpus,
    mean_len,
    frag_len,
    frag_sd
  )
  SIMULATE(CONFIG.out)
  CAT_FASTQ(SIMULATE.out.fastq)
  SEQKIT_SORT(CAT_FASTQ.out)
  SEQKIT_SPLIT2(SEQKIT_SORT.out)

  emit:
  bam     = SIMULATE.out.bam
  contigs = SIMULATE.out.contigs
  tax     = SIMULATE.out.tax
  fastq   = SEQKIT_SPLIT2.out
}
