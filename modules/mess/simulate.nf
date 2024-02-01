process MESS {
  cpus "${params.cpus}"
  tag "$nb"

  conda "$projectDir/envs/mess.yml"

  input:
  tuple val(nb), path(tsv), path(asm_summary), path(fasta)
  val err_profile
  val size
  val mean_len
  val frag_len
  val frag_sd

  output:
  tuple val(nb), path("sample*/fastq/*.fq.gz"), emit: fastq
  tuple val(nb), path("sample*/bam/*.bam"), emit: bam
  
  script:
  """
  mess simulate --threads $task.cpus -i $tsv -o sample$nb \\
  --skip-fa-proc True --bam True --compressed False \\
  --asm-summary $asm_summary --tech illumina \\
  --custom-err $err_profile --bases ${size}G \\
  --mean-len $mean_len --frag-len $frag_len \\
  --frag-sd $frag_sd --no-use-conda
  """
}