#!/usr/bin/env nextflow

assembly_tb = Channel.fromPath("all-assemblies.tsv")

process prepare_input_and_config_files {
  conda 'envs/mess.yml'

  publishDir "$params.outdir/mess", mode: 'copy'
  
  input: file assemblyTb from assembly_tb
  
  output: file "*.yml" into mess_config_ch
          file "*.tsv" into mess_input_ch
  script:
  """
  $baseDir/prepare-files.py -i $assemblyTb -o $params.outdir -l "$params.genomesNb" -t mess -n $params.NCBIkey -e $params.NCBIemail \
  --seed $params.seed --mu $params.mu --sigma $params.sigma
  """
}

mess_config_ch.flatten().set{flattened_mess_configs_ch}

process download_assemblies {
  conda 'envs/mess.yml'
  
  tag "${config.baseName}"
  
  publishDir "$params.outdir/mess", mode: 'copy'
  
  cpus params.cores

  input: file config from flattened_mess_configs_ch
  
  output: 
  
  file "assembly_gz/${config.baseName}/*.gz" into assembly_gz_ch

  tuple val("${config.baseName}"), file("${config.baseName}-assemblies-summary.tsv") into summaries_ch
  
  script:
  """
  snakemake --snakefile $params.mess/mess/scripts/Snakefile --configfile $config --use-conda --conda-prefix $params.conda \
  --resources ncbi_requests=3 --cores ${task.cpus} all_download 
  """
}


process prepare_input_and_config_files_CAMISIM {
  conda 'envs/mess.yml'
  
  tag "${replicateId}"

  publishDir "$params.outdir/camisim", mode: 'copy'
  
  input: set replicateId, file(assemblySummary) from summaries_ch
  
  output: file "metadata_${replicateId}.tsv" into metadata_ch
          file "genome_to_id_${replicateId}.tsv" into genome_to_id_ch
          file "distribution_${replicateId}.txt" into distribution_ch
  
  script:
  """
  $baseDir/prepare-files.py -o $params.outdir -l $params.genomesNb -t camisim -r $replicateId -c $params.camisim \
  --seed $params.seed --mu $params.mu --sigma $params.sigma 
  """
}