
include { MESS } from "../modules/mess/simulate"
include { CAMISIM } from "../modules/camisim/simulate"

workflow SIMULATE {
    take:
    ch_mess_input
    ch_cami_input
    custom_profile
    size
    mean_len
    frag_len
    frag_sd

    main:
    MESS(ch_mess_input, 
    custom_profile, 
    size,
    mean_len,
    frag_len, 
    frag_sd)
    ch_mess_reads = MESS.out.fastq

    CAMISIM(ch_cami_input)
    ch_camisim_reads = CAMISIM.out.fastq

    emit:
    mess_reads = ch_mess_reads
    camisim_reads = ch_camisim_reads
}