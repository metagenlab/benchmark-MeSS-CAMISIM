process CAMISIM_CONFIG {
  tag "$nb"

  input:
  path config
  val cpus
  val size
  tuple val(nb), path(tsv)
  
  output:
  tuple val(nb), path("*.ini")
  
  script:
  """
  camisim_config.py $CAMI_PATH $cpus $nb $size $config sample${nb}.ini
  """
}