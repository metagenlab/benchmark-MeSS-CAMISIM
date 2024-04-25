process SEQKIT_SORT {
  cpus 10
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