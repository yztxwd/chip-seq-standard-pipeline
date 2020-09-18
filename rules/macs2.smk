def checkcontrol(samples):
    return 'control' in samples['condition'].values

if checkcontrol(samples):
    rule macs2:
        input:
            treatment="output/mapped/{sample}-{rep}.merged.bam",
            control=f"output/mapped/{samples.loc[samples['condition']=='control', 'sample'].iloc[0]}-{{rep}}.merged.bam"
        output:
            "output/macs2/{sample}-{rep, [^.]+}.broadPeak" if config["mode"]=='histone' else 'output/macs2/{sample}-{rep, [^.]+}.narrowPeak'
        log:
            "output/logs/macs2/{sample}-{rep}.macs2.log"
        params:
            format=lambda wildcards: "BAM" if any(pd.isnull(samples.loc[wildcards.sample, "fq2"])) else "BAMPE",
            name="{sample}",
            extra=config["macs2"]["extra"],
            mode="--broad" if config["mode"]=="histone" else ""
        conda:
            "../envs/macs2.yaml"
        shell:
            "macs2 callpeak -t {input.treatment} -c {input.control} -f {params.format} -n {params.name} {params.mode} {params.extra}"
    
else:
    rule macs2:
        input:
            treatment="output/mapped/{sample}-{rep}.merged.bam",
        output:
            "output/macs2/{sample}-{rep, [^.]+}.broadPeak" if config['mode']=='histone' else 'output/macs2/{sample}-{rep, [^.]+}.narrowPeak'
        log:
            "output/logs/macs2/{sample}-{rep}.macs2.log"
        params:
            format=lambda wildcards: "BAM" if any(pd.isnull(samples.loc[wildcards.sample, "fq2"])) else "BAMPE",
            name="{sample}",
            extra=config["macs2"]["extra"],
            mode="--broad" if config["mode"]=="histone" else ""
        conda:
            "../envs/macs2.yaml"
        shell:
            "macs2 callpeak -t {input.treatment} -f {params.format} -n {params.name} {params.mode} {params.extra}"
