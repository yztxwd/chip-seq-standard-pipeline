def checkcontrol(samples):
    return 'control' in samples['condition'].values

if checkcontrol(samples):
    rule macs2:
        input:
            treatment="output/mapped/{sample}-{rep}.merged.bam",
            control=f"output/mapped/{samples.loc[samples['condition']=='control', 'sample'].iloc[0]}-{{rep}}.merged.bam"
        output:
            "output/macs2/{sample}-{rep, [^.]+}_peaks.broadPeak" if config["mode"]=='histone' else 'output/macs2/{sample}-{rep, [^.]+}_peaks.narrowPeak'
        log:
            log="output/logs/macs2/{sample}-{rep}.macs2.log",
            err="output/logs/macs2/{sample}-{rep}.macs2.err"
        params:
            format=lambda wildcards: "BAM" if any(pd.isnull(samples.loc[wildcards.sample, "fq2"])) else "BAMPE",
            name="output/macs2/{sample}-{rep}",
            extra=config["macs2"]["extra"],
            mode="--broad" if config["mode"]=="histone" else ""
        conda:
            "../envs/macs2.yaml"
        shell:
            "macs2 callpeak -t {input.treatment} -c {input.control} -f {params.format} -n {params.name} {params.mode} {params.extra} 1> {log.log} 2> {log.err} "
    
else:
    rule macs2:
        input:
            treatment="output/mapped/{sample}-{rep}.merged.bam",
        output:
            "output/macs2/{sample}-{rep, [^.]+}_peaks.broadPeak" if config['mode']=='histone' else 'output/macs2/{sample}-{rep, [^.]+}_peaks.narrowPeak'
        log:
            log="output/logs/macs2/{sample}-{rep}.macs2.log",
            err="output/logs/macs2/{sample}-{rep}.macs2.err"
        params:
            format=lambda wildcards: "BAM" if any(pd.isnull(samples.loc[wildcards.sample, "fq2"])) else "BAMPE",
            name="output/macs2/{sample}-{rep}",
            extra=config["macs2"]["extra"],
            mode="--broad" if config["mode"]=="histone" else ""
        conda:
            "../envs/macs2.yaml"
        shell:
            "macs2 callpeak -t {input.treatment} -f {params.format} -n {params.name} {params.mode} {params.extra} 1> {log.log} 2> {log.err}"
