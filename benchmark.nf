process MeSS {
  conda "envs/mess.yml" 
  
  tag "${config.baseName}"
  
  cpus params.cores
  
  input: file config from Channel.fromPath("results/mess/*.yml") 
  
  output: file "simreads/*.fq.gz"
  
  script:
  """
  ln -s $baseDir/assembly_gz .
  ln -s $baseDir/*.tsv .
  snakemake --snakefile $params.mess/mess/scripts/Snakefile --configfile $config --use-conda --conda-prefix $params.conda \
  --resources ncbi_requests=3 nb_simulation=2 parallel_cat=2 --cores ${task.cpus} all_sim
  """
}

process CAMISIM {
  conda "envs/camisim.yml"
  
  tag "${config.baseName}"
  
  cpus params.cores
  
  input: file config from Channel.fromPath("results/camisim/*.ini")
  
  output: file "*_sample_*/reads/*fq.gz"
  
  script:
  """
  $params.camisim/metagenomesimulation.py $config
  """
}