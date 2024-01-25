process MESS {
  tag "$nb"

  conda "/home/fchaaban/mambaforge/envs/mess"

  input:
  tuple val(nb), path(tsv), path(asm_summary), path(fasta)
  val err_profile
  val size
  val mean_len
  val frag_len
  val frag_sd

  output:
  tuple val(nb), path("sample*/*")
  
  script:
  """
  mess simulate --threads $task.cpus -i $tsv -o sample$nb \\
  --fasta . --asm-summary $asm_summary --bam True \\
  --tech illumina --custom-err $err_profile --bases ${size}G \\
  --mean-len $mean_len --frag-len $frag_len \\
  --frag-sd $frag_sd --no-use-conda
  """
}