process CAMISIM_CONFIG {
  tag "$sample"
  
  input:
  tuple val(sample), path(summary)
  path config
  val seed
  val cpus
  val readlen
  val fraglen
  val fragsd
  tuple val(sample), path(tsv)
  
  output:
  tuple val(sample), path("*.ini")
  
  script:
  """
  camisim_config.py $summary $CAMI_PATH $seed $cpus $sample $readlen $fraglen $fragsd $config ${sample}.ini
  """
}