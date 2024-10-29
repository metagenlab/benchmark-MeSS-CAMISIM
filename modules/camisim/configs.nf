process CAMISIM_CONFIG {
  label 'process_single'
  tag "${sample}"
  container 'docker://quay.io/biocontainers/pandas:2.2.1'

  input:
  tuple val(sample), path(abundance), path(dist), path(meta), path(gen2id), path(config), path(taxdump, stageAs: "taxdump/*")
  val seed
  val cpus
  val readlen
  val fraglen
  val fragsd

  output:
  tuple val(sample), path("*.ini")

  script:
  """
  camisim_config.py ${abundance} ${dist} ${meta} ${gen2id} ${seed} \\
  ${cpus} ${sample} ${readlen} ${fraglen} ${fragsd} ${config} ${sample}.ini
  """
}
