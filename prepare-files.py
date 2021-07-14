#!/usr/bin/env python

import random
import pandas as pd
import numpy as np
import os
from argparse import ArgumentParser

class PrepareFiles(object):
    """
    class for preparing config and input files for MeSS and CAMISIM
    """
    def __init__(self, table, outdir, nb_genomes, tool, replicate, camisim, ncbi_key, ncbi_email,seed=0, mu=1, sigma=2):
        self.assemblies = str(table)
        self.ncbi_key = str(ncbi_key)
        self.ncbi_email = str(ncbi_email)
        self.toolname = str(tool)
        self.rep = str(replicate)
        self.camipath = str(camisim)
        self.outdir = str(outdir)
        self.replicates = [int(n) for n in nb_genomes.split()] 
        self.seed = int(seed)
        self.mu = int(mu)
        self.sigma = int(sigma)
        random.seed(self.seed)
        
    def get_lognormal_dist(self, tb):
        d = [random.lognormvariate(mu=self.mu, sigma=self.sigma) for i in range(len(tb))]
        tb.insert(loc=tb.shape[1], column='lognormal', value=d)
        tb['RelativeProp'] = tb['lognormal']/tb['lognormal'].sum()
        return tb 
    

    def prepare_camisim_files(self, sample):
        """
        function for preparing CAMISIM files from MeSS files
        """
        summary = pd.read_csv(f'{self.outdir}/mess/{sample}-assemblies-summary.tsv', sep='\t')
        input_tb = pd.read_csv(f'{self.outdir}/mess/{sample}.tsv', sep='\t')
        merged = summary.merge(input_tb, on='AssemblyInput')
        ids=[]
        otus=[]
        names=[]
        for n, taxid in enumerate(merged['AssemblyInput']):
            names.append(f'Genome{float(n+1)}')
            otus.append(n+1)
            ids.append(taxid)
        merged['genome_ID'] = names
        merged['OTU'] = otus
        merged['NCBI_ID'] = ids
        merged['novelty_category']=['known_strain'] * len(merged)
        fullpaths = [os.path.join(self.outdir, f'mess/assembly_gz/{sample}', 
                        str(assemblyname)+'_genomic.fna') for assemblyname in merged['AssemblyNames']]
        merged['fullpath'] = fullpaths
        merged[['genome_ID','OTU','NCBI_ID','novelty_category']].to_csv(f'metadata_{sample}.tsv', sep='\t', index=None)
        merged[['genome_ID','fullpath']].to_csv(f'genome_to_id_{sample}.tsv', sep='\t', index=None, header=False)
        merged[['genome_ID','RelativeProp']].to_csv(f'distribution_{sample}.txt', sep='\t', index=None, header=False)
        

    def run(self):
        """
        function for preparing MeSS files and CAMISIM config
        """
        if self.toolname == 'mess':
            for n in self.replicates:
                self.seed = n
                tb = pd.read_csv(self.assemblies, sep='\t').sample(n) #sample n assemblies from all-asssemblies.tsv
                print(tb)
                dist = self.get_lognormal_dist(tb)
                input_path = os.path.join(self.outdir, f'{n}.tsv')
                assembly_path = os.path.join(self.outdir,'mess/assembly_gz',f'{n}')
                dist.to_csv(f'{n}.tsv', sep='\t', index=None)
                config=[f"input_table_path: {input_path}\n",
                f"assemblies_dir: {assembly_path}\n","sd_read_num: 0\n","replicates: 1\n",
                f"community_name: {n}\n","seq_tech: illumina\n","total_reads: 400000\n","read_status: paired\n"
                "illumina_sequencing_system: HS20\n","illumina_read_len: 100\n","illumina_mean_frag_len: 170\n",
                "illumina_sd_frag_len: 17\n",f"seed: {self.seed}\n","bam: True\n",f"NCBI_key: {self.ncbi_key}\n",
                f"NCBI_email: {self.ncbi_email} \n","complete_assemblies: False\n","reference_assemblies: False\n",
                "representative_assemblies: False\n","exclude_from_metagenomes: True\n","Genbank_assemblies: True\n",
                "Refseq_assemblies: True\n","Rank_to_filter_by: 'None'"]
            config_file=open(f'{n}.yml',"w+")
            config_file.writelines(config)
            config_file.close()

        elif self.toolname == 'camisim':
            self.seed = self.rep
            config = ['[Main]\n',f'seed={self.seed}\n','phase=2\n','max_processors=10\n',f'dataset_id={self.rep}\n','output_directory=.\n',
            'temp_directory=.\n','gsa=False\n','pooled_gsa=False\n','anonymous=False\n','compress=1\n',
            '[ReadSimulator]\n',
            f'readsim={self.camipath}/tools/art_illumina-2.3.6/art_illumina\n',
            f'error_profiles={self.camipath}/tools/art_illumina-2.3.6/profiles\n',
            f'samtools={self.camipath}/tools/samtools-1.3/samtools\n',
            'profile=hi\n','size=0.1\n','type=art\n','fragments_size_mean=170\n','fragment_size_standard_deviation=17\n',
            '[CommunityDesign]\n',f'distribution_file_paths={self.outdir}/distribution_{self.rep}.txt\n',
            'ncbi_taxdump=/scratch/hdd2/farid/bench_CAMI_MeSS/taxdump\n',
            f'strain_simulation_template={self.camipath}/scripts/StrainSimulationWrapper/sgEvolver/simulation_dir\n',
            'number_of_samples=1\n','[community0]\n',f'metadata={self.outdir}/metadata_{self.rep}.tsv\n',
            f'id_to_genome_file={self.outdir}/genome_to_id_{self.rep}.tsv\n',f'genomes_total={self.rep}\n',f'genomes_real={self.rep}\n',
            'max_strains_per_otu=1\n','ratio=1\n','mode=differential\n','log_mu=1\n','log_sigma=2\n','gauss_mu=1\n',
            'gauss_sigma=1\n','view=False']
            self.prepare_camisim_files(self.rep)
            config_file=open(f'{self.rep}.ini',"w+")
            config_file.writelines(config)
            config_file.close()

def run_prepare_files(opts):
    pf = PrepareFiles(opts.table, opts.outdir, opts.nb_genomes, opts.tool, opts.replicate, opts.camisim,
                      opts.ncbi_key, opts.ncbi_email, opts.seed, opts.mu, opts.sigma)
    pf.run()

def get_args(parser):
    parser.add_argument('-i', '--table', required=False, help='path to all assemblies table')
    parser.add_argument('-o', '--outdir', required=True, help='output directory to print in config files')
    parser.add_argument('-l', '--nb_genomes', required=True, help='list of number of genomes for each replicate')
    parser.add_argument('-t', '--tool', required=True, help='ncbi email to print in MeSS config')
    parser.add_argument('-r', '--replicate', required=False, help='replicate name for CAMISIM required files')
    parser.add_argument('-c', '--camisim', required=False, help='local camisim install path to print in config file')
    parser.add_argument('-n', '--ncbi_key', required=False, help='ncbi key to print in MeSS config')
    parser.add_argument('-e', '--ncbi_email', required=False, help='ncbi email to print in MeSS config')
    parser.add_argument('--seed', required=False, help='seed used for generating log-normal distribution')
    parser.add_argument('--mu', required=False, help='mu value for log-normal distribution')
    parser.add_argument('--sigma', required=False, help='sigma value for log-normal distribution')
    return parser

if __name__ == "__main__":
    # args
    parser = ArgumentParser(description='Script to prepare MeSS and CAMISIM config and input files')
    parser=get_args(parser)
    opts, unknown_args = parser.parse_known_args()
    # run
    run_prepare_files(opts)


            





        