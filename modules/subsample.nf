process SUBSAMPLE {
  container 'docker://quay.io/biocontainers/pandas:2.2.1'
  
  input:
  val(subsets)
  val(seed)
  path(summary)
  
  output:
  path("subset_*.tsv")

  script:
  """
  subsample.py $subsets $seed $summary 
  """
}