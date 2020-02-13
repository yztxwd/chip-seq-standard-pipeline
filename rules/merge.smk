rule merge_bam:
    input:
        lambda wildcards: expand("output/mapped/{sample}-{unit}.flag.filtered.bam", **wildcards, unit=units.loc[wildcards.sample,  'unit'])
    output:
        "output/mapped/{sample}.merged.bam"
    params:
        "-n"
    threads:
        config['threads']
    wrapper:
        "0.49.0/bio/samtools/merge"

rule merge_bed:
    input:
        coverage=lambda wildcards: expand("output/mapped/{sample}-{unit}.coverage.1b.bg", **wildcards, unit=units.loc[wildcards.sample, 'unit']),
        midpoint=lambda wildcards: expand("output/mapped/{sample}-{unit}.midpoint.1b.bg", **wildcards, unit=units.loc[wildcards.sample, 'unit'])
    output:
        coverage="output/mapped/{sample}.merged.coverage.1b.bg",
        midpoint="output/mapped/{sample}.merged.midpoint.1b.bg"
    shell:
        """
        cat {input.coverage} > {output.coverage}
        cat {input.midpoint} > {output.midpoint}
        """
