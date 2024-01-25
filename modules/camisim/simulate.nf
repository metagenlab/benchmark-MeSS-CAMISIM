process CAMISIM {
  tag "$nb"

  conda "$projectDir/envs/camisim.yml"
  
  input:
  tuple val(nb), path(config)

  output:
  tuple val(nb), path("sample*/*")
  
  script:
  """
  mkdir sample$nb
  $CAMI_PATH/metagenomesimulation.py $config
  """
}