process MESS {
  tag "$sample"

  container "docker://ghcr.io/metagenlab/mess:dev"

  input:
  tuple val(sample), path(tsv), path(summary), path(taxdump, stageAs: "taxdump/*"), path(prefix), path (err_path, stageAs: "profiles/*")
  val err_name
  val bases
  val seed
  val mean_len
  val frag_len
  val frag_sd

  output:
  tuple val(sample), path("*/coverages.tsv"), emit: cov
  tuple val(sample), path("*/*.fq.gz"), emit: fastq
  tuple val(sample), path("*/bam/*.bam*"), emit: bam
  tuple val(sample), path("*/tax/*.txt"), emit: tax
  
  script:
  def total_bases = bases ? "--bases $bases" : ""
  """
  mess simulate --threads $task.cpus \\
  --sdm apptainer --prefix $prefix \\
  --taxonkit taxdump \\
  --seed $seed -i $tsv -o $sample --bam \\
  $total_bases --tech illumina \\
  --asm-summary $summary  \\
  --custom-err $err_path/$err_name \\
  --mean-len $mean_len --frag-len $frag_len \\
  --frag-sd $frag_sd
  mv $sample/fastq/*R1.fq.gz $sample/mess_${sample}_R1.fq.gz
  mv $sample/fastq/*R2.fq.gz $sample/mess_${sample}_R2.fq.gz
  """
}