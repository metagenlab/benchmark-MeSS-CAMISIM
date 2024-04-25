process CAMISIM_TABLES {
  tag "$sample"

  input:
  tuple val(sample), path(tsv)
  
  output:
  tuple val(sample), path("*.{tsv,txt}")
  
  script:
  """
  camisim_tables.py $tsv $sample
  """
}