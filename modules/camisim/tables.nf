process CAMISIM_TABLES {
  label 'process_single'

  tag "$sample"
  
  container 'docker://quay.io/biocontainers/pandas:2.2.1'

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