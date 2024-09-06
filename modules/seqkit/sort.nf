process SEQKIT_SORT {
  label "process_medium"

  tag "$sample"
  
  container 'docker://quay.io/biocontainers/seqkit:2.8.2--h9ee0642_0'
  
  input:
  tuple val(sample), path(fastq)
  
  output:
  tuple val(sample), path("*.sorted.fq.gz")
  
  script:  
  """
  seqkit \\
    sort \\
    --threads $task.cpus \\
    $fastq \\
    > ${sample}.sorted.fq.gz
  """
}