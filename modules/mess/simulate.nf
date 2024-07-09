process MESS_SIMULATE {
  cpus "${params.cpus}"
  
  tag "$sample"

  conda "$projectDir/envs/mess.yml"

  input:
  tuple val(sample), path(tsv)
  path summary
  val seed
  val size
  val err_profile
  val mean_len
  val frag_len
  val frag_sd

  output:
  tuple val(sample), path("*/processing/cov.tsv"), emit: cov
  tuple val(sample), path("*/fastq/*.fq.gz"), emit: fastq
  tuple val(sample), path("*/bam/*.bam*"), emit: bam
  tuple val(sample), path("*/tax/*.txt"), emit: tax
  
  script:
  """
  mess simulate --threads $task.cpus \\
  --seed $seed -i $tsv -o $sample --bam --bases $size \\
  --asm-summary $summary --tech illumina \\
  --custom-err $err_profile \\
  --mean-len $mean_len --frag-len $frag_len \\
  --frag-sd $frag_sd --no-use-conda
  """
}