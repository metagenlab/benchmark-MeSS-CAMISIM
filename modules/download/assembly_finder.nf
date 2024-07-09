process ASSEMBLY_FINDER {
  cpus "${params.cpus}"
  
  conda "$CONDA_PREFIX/envs/mess"
  
  input:
  val entry
  val nb
  val ncbi_email
  val ncbi_key
  
  output:
  path("download/assembly_summary.tsv"), emit: summary
  path("download/assemblies/*.fna.gz"), emit: fasta
  
  script:
  """
  assembly_finder -i $entry -nb $nb -ne $ncbi_email -nk $ncbi_key -o download 
  """
}