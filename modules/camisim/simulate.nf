process CAMISIM {
  cpus "${params.cpus}"
  tag "$nb"

  conda "$projectDir/envs/camisim.yml"
  
  input:
  tuple val(nb), path(config)

  output:
  tuple val(nb), path("sample*/*/reads/*.fq.gz"), emit: fastq
  tuple val(nb), path("sample*/*/bam/*.bam"), emit: bam
  tuple val(nb), path("sample*/*/contigs/*.gz"), emit: contigs

  
  script:
  """
  mkdir sample$nb
  $CAMI_PATH/metagenomesimulation.py $config
  """
}