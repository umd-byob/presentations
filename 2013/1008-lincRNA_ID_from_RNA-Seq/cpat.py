#!/usr/bin/env python
'''---------------------------------------------------------------------------------------
CPAT: Coding Potential Assessing Tool
------------------------------------------------------------------------------------------'''

#import built-in modules
import os,sys

import os,sys
if sys.version_info[0] != 2 or sys.version_info[1] != 7:
	print >>sys.stderr, "\nYou are using python" + str(sys.version_info[0]) + '.' + str(sys.version_info[1]) + " CPAT needs python2.7!\n"
	sys.exit()



import string
from optparse import OptionParser
import warnings
import string
import collections
import sets
import signal
from numpy import mean,median,std,nansum
from string import maketrans
import subprocess

#import 3rd party modules
import pysam
from bx.bbi.bigwig_file import BigWigFile
import numpy as np

#import my own modules
from cpmodule import fickett
from cpmodule  import orf
from cpmodule  import fasta
from cpmodule  import annoGene
from cpmodule  import FrameKmer
from cpmodule  import ireader

__author__ = "Liguo Wang"
__contributor__="Liguo Wang, Hyun Jung Park, Wei Li"
__copyright__ = "Copyright 2012, Mayo Clinic"
__credits__ = []
__license__ = "GPL"
__version__="1.2"
__maintainer__ = "Liguo Wang"
__email__ = "wang.liguo@mayo.edu; wangliguo78@gmail.com"
__status__ = "Production"


def coding_prediction(rdata,idata,outfile):
	'''rdata stored the linear regression model, idata is data matrix containing features'''
	RCMD = open(outfile + '.r','w')
	print >>RCMD, 'load(\"%s\")' % (rdata)
	print >>RCMD, 'test <- read.table(file=\"%s\",sep="\\t",col.names=c("ID","mRNA","ORF","Fickett","Hexamer"))' % (idata)
	print >>RCMD, 'test$prob <- predict(mylogit,newdata=test,type="response")'
	print >>RCMD, 'attach(test)'
	print >>RCMD, 'output <- cbind("mRNA_size"=mRNA,"ORF_size"=ORF,"Fickett_score"=Fickett,"Hexamer_score"=Hexamer,"coding_prob"=test$prob)'
	print >>RCMD, 'write.table(output,file=\"%s\",quote=F,sep="\\t",row.names=ID)' % (outfile)
	RCMD.close()
	try:
		subprocess.call("Rscript " + outfile + '.r', shell=True)
	except:
		pass
	#os.remove(idata)
	
def sum_bwfile(inbedline,bwfile):
	'''retrieve sum of conservation score for all exons from input bed line'''
	line = inbedline
	bw_signal = []
	try:
		fields=line.rstrip('\r\n').split()
		txStart=int(fields[1])
		chrom=fields[0]
		strand=fields[5]
		geneName=fields[3]
		score=fields[4]
		exon_start=map(int,fields[11].rstrip(',').split(','))
		exon_start=map((lambda x: x + txStart),exon_start)
		exon_end=map(int,fields[10].rstrip(',').split(','))
		exon_end=map((lambda x,y:x+y),exon_start,exon_end)
	except:
		print >>sys.stderr, "Incorrect bed format."
	try:
		for st,end in zip(exon_start,exon_end):           
			#print chrom +'\t'+ str(st) +'\t'+ str(end)    
			bw_signal.extend(bwfile.get_as_array(chrom,st,end))
			wigsum = nansum(bw_signal)
	except:
		wigsum = 0
	wigsum=np.nan_to_num(wigsum)
	return wigsum
		
		
def bed_or_fasta(infile):
	'''determine if the input file is bed or fasta format'''
	format = "UNKNOWN"
	for line in ireader.reader(infile):
		#line = line.strip()
		if line.startswith('#'):
			continue
		if line.startswith('>'):
			format="FASTA"
			return format
		elif len(line.split())==12:
			format='BED'
			return format
	return format

def index_fasta(infile):
	'''index fasta file using samTools'''
	if os.path.isfile(infile):
		pass
	else:
		print >>sys.stderr, "Indexing " + infile + ' ...',
		pysam.faidx(infile)
		print >>sys.stderr, "Done!"
		
def extract_feature_from_bed(inbed,refgenome,stt,stp,c_tab,g_tab):
	'''extract features of sequence from bed line'''
		
	stt_coden = stt.strip().split(',')
	stp_coden = stp.strip().split(',')
	transtab = maketrans("ACGTNX","TGCANX")
	mRNA_seq = ''
	mRNA_size = 0
	if inbed.strip():
		try:
			fields = inbed.split()
			chrom = fields[0]
			tx_start = int( fields[1] )
			tx_end = int( fields[2] )
			geneName = fields[3]
			strand = fields[5].replace(" ","_")			
			exon_num = int(fields[9])
			exon_sizes = map(int,fields[10].rstrip(',\n').split(','))
			exon_starts = map(int, fields[11].rstrip( ',\n' ).split( ',' ) )
			exon_starts = map((lambda x: x + tx_start ), exon_starts)
			exon_ends = map( int, fields[10].rstrip( ',\n' ).split( ',' ) )
			exon_ends = map((lambda x, y: x + y ), exon_starts, exon_ends);   
			intron_starts = exon_ends[:-1]
			intron_ends = exon_starts[1:]
		except:
			print >>sys.stderr,"Wrong format!" + inbed 
			return None
		mRNA_size = sum(exon_sizes)
		for st,end in zip(exon_starts, exon_ends):
			exon_coord = chrom + ':' + str(st +1) + '-' + str(end)
			tmp = pysam.faidx(refgenome,exon_coord)
			mRNA_seq += ''.join([i.rstrip('\n\r') for i in tmp[1:]])
		if strand =='-':
			mRNA_seq = mRNA_seq.upper().translate(transtab)[::-1]				
		tmp = orf.ORFFinder(mRNA_seq)
		(CDS_size, CDS_frame, CDS_seq) = tmp.longest_orf(direction="+",start_coden=stt_coden, stop_coden=stp_coden)
		fickett_score = fickett.fickett_value(CDS_seq)		
		hexamer = FrameKmer.kmer_ratio(CDS_seq,6,3,c_tab,g_tab)
		#print CDS_seq
		return (geneName, mRNA_size, CDS_size, fickett_score,hexamer)

def extract_feature_from_seq(seq,stt,stp,c_tab,g_tab):
	'''extract features of sequence from fasta entry'''
	
	stt_coden = stt.strip().split(',')
	stp_coden = stp.strip().split(',')
	transtab = maketrans("ACGTNX","TGCANX")
	mRNA_seq = seq.upper()
	mRNA_size = len(seq)
	tmp = orf.ORFFinder(mRNA_seq)
	(CDS_size1, CDS_frame1, CDS_seq1) = tmp.longest_orf(direction="+",start_coden=stt_coden, stop_coden=stp_coden)
	fickett_score1 = fickett.fickett_value(CDS_seq1)
	hexamer = FrameKmer.kmer_ratio(CDS_seq1,6,3,c_tab,g_tab)
	return (mRNA_size, CDS_size1, fickett_score1,hexamer)
		
def main():
	usage = "\n%prog  [options]"
	parser = OptionParser(usage,version="%prog " + __version__)
	parser.add_option("-g","--gene",action="store",dest="gene_file",help="Transcripts either in BED format or mRNA sequences in FASTA format: If this is BED format file, '-r' must be specified; if this is mRNA sequence file in FASTA format, ignore the '-r' option. The input BED or FASTA file could be regular text file or compressed file (*.gz, *.bz2) or accessible url.")
	parser.add_option("-o","--outfile",action="store",dest="out_file",help="output file. Tab separated text file: geneID <tab> mRNA size <tab> ORF size <tab> Fickett Score <tab> Hexamer Score<tab>Coding Probability.")
	parser.add_option("-x","--hex",action="store",dest="hexamer_dat",help="Prebuilt hexamer frequency table (Human, Mouse, Fly, Zebrafish). Run 'make_hexamer_tab.py' to make this table out of your own training dataset.")
	parser.add_option("-d","--logitModel",action="store",dest="logit_model",help="Prebuilt training model (Human, Mouse, Fly, Zebrafish). Run 'make_logitModel.py' to build logit model out of your own training datset")
	parser.add_option("-r","--ref",action="store",dest="ref_genome",help="Reference genome sequences in FASTA format. Ignore this option if mRNA sequences file was provided to '-g'. Reference genome file will be indexed automatically (produce *.fai file along with the original *.fa file within the same directory) if hasn't been done.")
	parser.add_option("-s","--start",action="store",dest="start_codons",default='ATG',help="Start codon (DNA sequence, so use 'T' instead of 'U') used to define open reading frame (ORF). default=%default")
	parser.add_option("-t","--stop",action="store",dest="stop_codons",default='TAG,TAA,TGA',help="Stop codon (DNA sequence, so use 'T' instead of 'U') used to define open reading frame (ORF). Multiple stop codons should be separated by ','. default=%default")
	
	(options,args)=parser.parse_args()
	
	#check input and output files
	for file in ([options.gene_file,options.out_file,options.logit_model,options.hexamer_dat]):
		if not (file):
			parser.print_help()
			sys.exit(0)
	#build hexamer table from hexamer frequency file
	coding={}
	noncoding={}	
	for line in open(options.hexamer_dat):
		line = line.strip()
		fields = line.split()
		if fields[0] == 'hexamer':continue
		coding[fields[0]] = float(fields[1])
		noncoding[fields[0]] =  float(fields[2])
	
	count=0		
	TMP = open(options.out_file + '.dat', 'w')

	file_format = bed_or_fasta(options.gene_file)
	if file_format == 'UNKNOWN':
		print >>sys.stderr, "\nError: unknown file format of '-g'\n"
		parser.print_help()
		sys.exit(0)		
	elif file_format == 'BED':
		print >>sys.stderr, "Input gene file is in BED format"
		if not options.ref_genome:
			print >>sys.stderr, "\nError: Reference genome file must be provided\n"
			parser.print_help()
			sys.exit(0)
		index_fasta(options.ref_genome)
		
		for line in ireader.reader(options.gene_file):
			count +=1
			if line.startswith('track'):continue
			if line.startswith('#'):continue
			if line.startswith('browser'):continue
			#if not line.strip(): continue
			(gene_id, mRNA_size, CDS_size, fickett_score,hexamer)=extract_feature_from_bed(line, options.ref_genome, options.start_codons, options.stop_codons,coding,noncoding)
			
			print >>TMP, '\t'.join([str(i) for i in [gene_id, mRNA_size, CDS_size, fickett_score,hexamer]])
			print >>sys.stderr, "%d genes finished\r" % count,
			
	elif file_format == 'FASTA':
		if options.ref_genome:
			print >>sys.stderr, "Reference genome sequence [-r] and conservation score [-c] will be ignored when input genes are fasta format."
		print >>sys.stderr, "Input gene file is in FASTA format"
		#fa = fasta.Fasta(options.gene_file)
		for sname,seq in FrameKmer.seq_generator(options.gene_file):
			count +=1
			#geneSeq = fa.getSeq(seqID = geneID)
			(mRNA_size, CDS_size, fickett_score,hexamer) = extract_feature_from_seq(seq = seq, stt = options.start_codons,stp = options.stop_codons,c_tab=coding,g_tab=noncoding)
			print >>TMP, '\t'.join(str(i) for i in (sname, mRNA_size, CDS_size, fickett_score,hexamer))
			print >>sys.stderr, "%d genes finished\r" % count,
	TMP.close()
	coding_prediction(options.logit_model, options.out_file + '.dat', options.out_file)
	
if __name__ == '__main__':
	main()
