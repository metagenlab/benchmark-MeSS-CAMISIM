process CAMISIM_TABLES {
  tag "$nb"

  input:
  tuple val(nb), path(tsv)
  
  output:
  tuple val(nb), path("*.{tsv,txt}")
  
  script:
  """
  camisim_tables.py $tsv sample$nb
  """
}