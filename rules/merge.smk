rule merge_bam:
    input:
        lambda wildcards: expand("output/mapped/{sample}-{rep}-{unit}.flag.filtered.bam", **wildcards, unit=samples.loc[(wildcards.sample, wildcards.rep),  'unit'])
    output:
        "output/mapped/{sample}-{rep, [^.]+}.merged.bam"
    params:
        "-n"
    threads:
        config['threads']
    wrapper:
        f"file:{snake_dir}/wrappers/samtools/merge"

rule merge_bed:
    input:
        coverage=lambda wildcards: expand("output/mapped/{sample}-{rep}-{unit}.coverage.1b.bg", **wildcards, unit=samples.loc[(wildcards.sample, wildcards.rep), 'unit']),
        midpoint=lambda wildcards: expand("output/mapped/{sample}-{rep}-{unit}.midpoint.1b.bg", **wildcards, unit=samples.loc[(wildcards.sample, wildcards.rep), 'unit'])
    output:
        coverage="output/mapped/{sample}-{rep, [^.]+}.merged.coverage.1b.bg",
        midpoint="output/mapped/{sample}-{rep, [^.]+}.merged.midpoint.1b.bg"
    shell:
        """
        cat {input.coverage} > {output.coverage}
        cat {input.midpoint} > {output.midpoint}
        """
