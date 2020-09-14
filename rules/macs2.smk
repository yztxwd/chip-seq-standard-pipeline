def checkcontrol(samples):
    return 'control' in samples['condition'].values

if checkcontrol(samples):
    rule macs2:
        input:
            treatment="output/mapped/{sample}.merged.bam",
            control=f"output/mapped/{samples.loc[samples['condition']=='control', 'sample'].iloc[0]}.merged.bam"
        output:
            "output/macs2/{sample}_peaks.narrowPeak"
        params:
            format=lambda wildcards: "BAM" if any(pd.isnull(units.loc[wildcards.sample, "fq2"])) else "BAMPE",
            name="{sample}",
            extra=config["macs2"]["extra"]
        conda:
            "../envs/macs2.yaml"
        shell:
            "macs2 callpeak -t {input.treatment} -c {input.control} -f {params.format} -n {params.name} {params.extra}"
else:
    rule macs2:
        input:
            treatment="output/mapped/{sample}.merged.bam",
        output:
            "output/macs2/{sample}_peaks.narrowPeak"
        params:
            format=lambda wildcards: "BAM" if any(pd.isnull(units.loc[wildcards.sample, "fq2"])) else "BAMPE",
            name="{sample}",
            extra=""
        conda:
            "../envs/macs2.yaml"
        shell:
            "macs2 callpeak -t {input.treatment} -f {params.format} -n {params.name} {params.extra}"
