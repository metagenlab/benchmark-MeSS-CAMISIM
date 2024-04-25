process CAMISIM_SIMULATE {
  cpus "${params.cpus}"
  tag "$sample"

  conda "$projectDir/envs/camisim.yml"
  
  input:
  tuple val(sample), path(config)

  output:
  tuple val(sample), path("*/*/reads/*.fq.gz"), emit: fastq
  tuple val(sample), path("*/*/bam/*.bam"), emit: bam
  tuple val(sample), path("*/*/contigs/*.gz"), emit: contigs
  tuple val(sample), path("*/*.txt"), emit: tax

  script:
  """
  mkdir $sample
  $CAMI_PATH/metagenomesimulation.py $config
  """
}