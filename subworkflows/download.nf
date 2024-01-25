#!/usr/bin/env nextflow

process TAXDUMP {
  publishDir "download", mode: 'copy'
  
  output:
  path("*.{dmp,prt,txt}")
  
  script:
  """
  wget https://ftp.ncbi.nih.gov/pub/taxonomy/taxdump.tar.gz 
  tar -xzvf taxdump.tar.gz --directory .
  """
}


process ASSEMBLY_FINDER {
  publishDir "download", mode: 'copy'
  
  conda 'envs/mess.yml'
  
  input:
  path tsv
  val ncbi_email
  val ncbi_key
  

  output:
  path("download/assemblies/*.fna.gz")
  path("download/*summary.tsv")
  
  script:
  """
  assembly_finder -i $tsv -ne $ncbi_email -nk $ncbi_key -o download 
  """
}