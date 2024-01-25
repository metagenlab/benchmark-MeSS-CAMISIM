process MESS_TABLES {
  tag "$nb"

  input:
  tuple val(nb), path(tsv)
  
  output:
  tuple val(nb), path("*.tsv")
  
  script:
  """
  mess_tables.py $tsv sample${nb}.tsv
  """
}