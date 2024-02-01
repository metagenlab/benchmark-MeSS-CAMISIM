process SUBSAMPLE {
  tag "$nb"

  input:
  val(nb)
  val(seed)
  val(mu)
  val(sigma)
  path(summary)
  
  output:
  tuple val(nb), path("*.tsv"), emit: table
  tuple val(nb), path("*.{fna,fa,fasta}*"), emit: fasta

  script:
  """
  subsample.py $nb $seed $mu $sigma $summary ${nb}_genomes_summary.tsv
  """
}