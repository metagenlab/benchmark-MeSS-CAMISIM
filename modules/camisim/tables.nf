process CAMISIM_TABLES {
  tag "$sample"

  input:
  tuple val(sample), path(tsv)
  
  output:
  tuple val(sample), path("metadata_*.tsv"), emit: meta
  tuple val(sample), path("distribution_*.tsv"), emit: dist
  tuple val(sample), path("genome_to_id_*.tsv"), emit: g2id
  script:
  """
  camisim_tables.py $tsv $sample
  """
}