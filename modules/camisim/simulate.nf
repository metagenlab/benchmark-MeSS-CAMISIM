process CAMISIM_SIMULATE {
  tag "$sample"

  container "docker://docker.io/cami/camisim:1.3.0"
  
  input:
  tuple val(sample), path(config)

  output:
  tuple val(sample), path("*/*/reads/*.fq.gz"), emit: fastq
  tuple val(sample), path("*/*/bam/*.bam"), emit: bam
  tuple val(sample), path("*/*/contigs/*.gz"), emit: contigs
  tuple val(sample), path("*/*.txt"), emit: tax

  script:
  def prefix = "python3 /usr/local/bin"
  """
  mkdir $sample
  ulimit -n 100000 && $prefix/metagenomesimulation.py $config
  """
}