process CAT_FASTQ {
  tag "$sample"
  
  input:
  tuple val(sample), path(fastq, stageAs: 'in/*')
  
  output:
  tuple val(sample), path("${sample}.fq.gz")
  
  script:
  """
  cat in/* > ${sample}.fq.gz
  """
}