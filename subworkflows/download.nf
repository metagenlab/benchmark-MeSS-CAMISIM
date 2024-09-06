#!/usr/bin/env nextflow

workflow DOWNLOAD {
  take:
  samples
  key

  main:
  TAXDUMP()
  UNIQUE_ACCESSIONS(samples)
  ASSEMBLY_FINDER(UNIQUE_ACCESSIONS.out, TAXDUMP.out, key)
  
  emit:
  taxdump = TAXDUMP.out
  summary = ASSEMBLY_FINDER.out 
}


process TAXDUMP {
  label "process_low"

  container 'docker://quay.io/biocontainers/curl:7.80.0'

  output:
  path("*.{dmp,prt,txt,tar.gz}")
  
  script:
  """
  curl https://ftp.ncbi.nih.gov/pub/taxonomy/taxdump.tar.gz \\
  -o taxdump.tar.gz
  tar -xzvf taxdump.tar.gz 
  """
}


process UNIQUE_ACCESSIONS {
  label "process_single"

  container "docker://quay.io/biocontainers/csvtk:0.30.0--h9ee0642_2"
  
  input:
  path samples
  
  output:
  path("accessions.txt")
  
  script:
  """
  csvtk concat $samples | \\
  csvtk -t uniq -f accession | \\
  csvtk -t cut -f accession | \\
  csvtk -t del-header > accessions.txt
  """
}



process ASSEMBLY_FINDER {
  label "process_medium"

  container 'docker://ghcr.io/metagenlab/assembly_finder:v0.7.7'
  
  input:
  path tsv
  path taxdump, stageAs: "taxdump/*"
  val ncbi_key
  
  output:
  path("accessions/assembly_summary.tsv")
  
  script:
  def args = task.ext.args ?: ''
  """
  assembly_finder \\
  $args \\
  --threads $task.cpus \\
  -i $tsv \\
  --accession \\
  --taxonkit taxdump \\
  --api-key $ncbi_key \\
  -o accessions
  """
}



