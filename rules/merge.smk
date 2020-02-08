rule merge_bam:
    input:
        expand("mapped/{sample}-{unit}.F1804.filtered.bam", **wildcards, unit=units.loc[sample, 'unit'])
    output:
        "mapped/{sample}.merged.bam"
    params:
        "-n"
    threads:
        32
    wrapper:
        "0.49.0/bio/samtools/merge"

rule merge_bed:
    input:
        coverage=expand("mapped/{sample}-{unit}.coverage.1b.bg", **wildcards, unit=units.loc[sample, 'unit'])
        midpoint=expand("mapped/{sample}-{unit}.coverage.1b.bg", **wildcards, unit=units.loc[sample, 'unit'])
    output:
        coverage="mapped/{sample}.merged.coverage.1b.bg"
        midpoint="mapped/{sample}.merged.coverage.1b.bg"
    shell:
        """
        cat {input.coverage} > {output.coverage}
        cat {input.midpoint} > {output.midpoint}
        """