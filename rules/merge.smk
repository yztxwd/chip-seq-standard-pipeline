rule merge_bam:
    input:
        lambda wildcards: expand("output/mapped/{sample}-{replicate}-{unit}.flag.filtered.bam", **wildcards, unit=units.loc[(wildcards.sample, wildcards.replicate), 'unit'])
    output:
        "output/mapped/{sample}-{replicate}.merged.bam"
    params:
        "-n"
    threads:
        config['threads']
    wrapper:
        "0.49.0/bio/samtools/merge"

rule merge_bed:
    input:
        coverage=lambda wildcards: expand("output/mapped/{sample}-{replicate}-{unit}.coverage.1b.bg", **wildcards, unit=units.loc[(wildcards.sample, wildcards.replicate), 'unit']),
        midpoint=lambda wildcards: expand("output/mapped/{sample}-{replicate}-{unit}.midpoint.1b.bg", **wildcards, unit=units.loc[(wildcards.sample, wildcards.replicate),'unit'])
    output:
        coverage="output/mapped/{sample}-{replicate}.merged.coverage.1b.bg",
        midpoint="output/mapped/{sample}-{replicate}.merged.midpoint.1b.bg"
    shell:
        """
        cat {input.coverage} > {output.coverage}
        cat {input.midpoint} > {output.midpoint}
        """
