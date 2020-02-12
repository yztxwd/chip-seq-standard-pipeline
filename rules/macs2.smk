def get_control(wildcards):
    # extract fastq files of first unit corresponding to this control
    fq = df.loc[(wildcards.sample, "control"), ["fq1", "fq2"]].values[0]
    # select the first sample with the occurance of these fastq files
    sample, replicate = units.set_index(["fq1", "fq2"]).loc[tuple(fq), ["sample", "replicate"]].values[0]
    return f"output/mapped/{sample}-{replicate}.merged.bam"

rule macs2:
    input:
        treatment="output/mapped/{sample}-{replicate}.merged.bam"
        control=get_control
    output:
        "output/macs2/{sample}-{replicate}_peaks.narrowPeaks"
    params:
        format=lambda wildcards: "BAM" if any(pd.isnull(df.loc[wildcards.sample, wildcards.replicate])) else "BAMPE"
        name="{sample}-{replicate}"
        extra=""
    conda:
    shell:
        "macs2 -t {input.treatment} -c {input.control} -f {params.format} -n {params.name} {params.extra}"