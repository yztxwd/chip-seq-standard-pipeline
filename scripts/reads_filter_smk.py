#!/usr/bin/python
import sys, pysam, re
import pandas as pd
import numpy as np

from optparse import OptionParser, IndentedHelpFormatter

class CustomHelpFormatter(IndentedHelpFormatter):
    def format_description(self, description):
        return description

description = """reads_filter_smk.py

snakemake version of reads_filter.py
filter reads given the MAPQ threshold or paired-end fragment size

Example:
    rule mapq_filter:
		input:
			"mapped/{sample}-{unit, [^.]+}.F1804.sort.bam"
		output:
			"mapped/{sample}-{unit, [^.]+}.F1804.filtered.bam"
		params:
			"-m pair -f 0 -s 0 -t 20"
		conda:
			"envs/py3.yaml"
		script:
			"scripts/reads_filter_smk.py"

Dependencies:
    numpy
    pandas

@Copyright 2020, Jianyu Yang, Southern Medical University
"""

parser = OptionParser(description=description, formatter=CustomHelpFormatter())
parser.add_option('-m', '--mode', dest='mode', help="single/pair end mode")
parser.add_option('-f', '--fragment-size', dest='fragment', help="fragment size threshold for paired-end reads, keep reads < threshold")
parser.add_option('-s', '--shit-size', dest='shift', help="'shift single end reads along 5'-3'")
parser.add_option('-t', '--mapq-threshold', dest='threshold', help="MAPQ threshold to filter reads")
pattern = re.compile("[ ]+")
option, argument = parser.parse_args(pattern.split(str(snakemake.params)))

#Read in snakemake parameters
input = snakemake.input[0]
output = snakemake.output[0]
mode = option.mode
frag_size_threshold = int(option.fragment)
shift_size = int(option.shift)
mapq_threshold = int(option.threshold)

prefix = output.split(".")[0]	# extract prefix for additional output

#One could look at the file name too see if we're dealing with a SAM or BAM file, but this is simpler
ifile = pysam.AlignmentFile(input, "rb")
ofile = pysam.AlignmentFile(output, "wb", template=ifile)
chr = []
mid_coor = []
left_coor = []
right_coor = []
name = []

#iterate
if mode == 'pair':
	count = 0
	for read in ifile:
		if count % 2 == 0 :
			r1 = read
			count += 1
		elif count % 2 == 1 :
			r2 = read
			count += 1
			if(r1.mapping_quality >= mapq_threshold and r2.mapping_quality >= mapq_threshold) :
				r1_coor = r1.reference_start + 1
				r2_coor = r2.reference_start + 1
				if (r1.reference_name != r2.reference_name) or (abs(r2_coor - r1_coor) >= 1000) or (abs(r2_coor - r1_coor) == 0):
					continue
				else:
					left = r1_coor if r1_coor < r2_coor else r2_coor
					right = r2_coor if r1_coor < r2_coor else r1_coor
					read_length = r2.infer_read_length() if r1_coor < r2_coor else r1.infer_read_length()
					if (frag_size_threshold > 0):
						if ((right - left + read_length) >= frag_size_threshold):
							continue				
					left_coor.append(left)
					right_coor.append(right + read_length - 1)
					chr.append(r1.reference_name)
					mid_coor.append(int((r1_coor + r2_coor + read_length - 1)/2))
					ofile.write(r1)
					ofile.write(r2)
					name.append("%s/%s" %(r1.qname, r2.qname))

elif mode == 'single':
	for read in ifile:
		if read.mapping_quality >= frag_size_threshold:
			chr.append(read.reference_name)
			ofile.write(read)
			coor = read.reference_start + 1
			if read.is_reverse:
				mid_coor.append(int(coor + read.infer_read_length()/2 - shift_size-1))
				left_coor.append(coor - shift_size)
				right_coor.append(coor - shift_size + read.infer_read_length()-1)
			else:
				mid_coor.append(int(coor + read.infer_read_length()/2 + shift_size-1))
				left_coor.append(coor + shift_size)
				right_coor.append(coor + shift_size + read.infer_read_length()-1)
			name.append(read.qname)
else:
	raise Exception("Please input a valid mode: single/pair")
		
ifile.close()
ofile.close()
coverage = pd.DataFrame({'chr':chr, 'left':left_coor, 'right':right_coor})
coverage['depth'] = 1
coverage['name'] = name
midpoint = pd.DataFrame({'chr':chr, 'mid_coor': mid_coor})
midpoint['right'] = midpoint['mid_coor']
midpoint['depth'] = 1
midpoint['name'] = name
coverage.to_csv(prefix + '.coverage.1b.bg', header=None, sep='\t', index=False)
midpoint.to_csv(prefix + '.midpoint.1b.bg', header=None, sep='\t', index=False)



