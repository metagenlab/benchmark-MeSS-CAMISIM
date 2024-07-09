process CAMISIM_CONFIG {
  tag "$sample"
  
  input:
  tuple val(sample), path(abundance), path(dist), path(meta), path(gen2id)
  path config
  val seed
  val cpus
  val readlen
  val fraglen
  val fragsd
  
  output:
  tuple val(sample), path("*.ini")
  
  script:
  """
  camisim_config.py $abundance $dist $meta $gen2id $CAMI_PATH $seed $cpus $sample $readlen $fraglen $fragsd $config ${sample}.ini
  """
}