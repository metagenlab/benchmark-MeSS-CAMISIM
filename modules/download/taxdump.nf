process TAXDUMP {
  output:
  path("*.{dmp,prt,txt}"), emit: tax
  
  script:
  """
  wget https://ftp.ncbi.nih.gov/pub/taxonomy/taxdump.tar.gz 
  tar -xzvf taxdump.tar.gz --directory .
  """
}