process SUBSAMPLE {
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