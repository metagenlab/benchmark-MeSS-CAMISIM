process MESS_TABLES {
  tag "$sample"

  input:
  tuple val(sample), path(tsv)
  
  output:
  tuple val(sample), path("*.tsv")
  
  script:
  """
  mess_tables.py $tsv ${sample}.tsv
  """
}