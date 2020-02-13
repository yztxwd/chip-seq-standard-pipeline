rule macs2:
    input:
        treatment="output/mapped/{sample}.merged.bam"
        control=f"output/mapped/{samples.loc[samples["condition"]=="control", "sample"]}.merged.bam"
    output:
        "output/macs2/{sample}_peaks.narrowPeaks"
    params:
        format=lambda wildcards: "BAM" if any(pd.isnull(df.loc[wildcards.sample, wildcards.replicate])) else "BAMPE"
        name="{sample}"
        extra=""
    conda:
    shell:
        "macs2 -t {input.treatment} -c {input.control} -f {params.format} -n {params.name} {params.extra}"