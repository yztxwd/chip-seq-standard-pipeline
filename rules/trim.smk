rule trim_pe:
    input:
        r1=lambda wildcards: "data/" + samples.loc[(wildcards.sample, wildcards.rep, wildcards.unit), "fq1"],
        r2=lambda wildcards: "data/" + samples.loc[(wildcards.sample, wildcards.rep, wildcards.unit), "fq2"],
        adapter=config["trimmomatic"]["adapter"]
    output:
        r1=temp("output/trimmed/{sample}-{rep, [^-]+}-{unit}.trim.1.fq.gz"),
        r2=temp("output/trimmed/{sample}-{rep, [^-]+}-{unit}.trim.2.fq.gz"),
        r1_unpaired=temp("output/trimmed/{sample}-{rep, [^-]+}-{unit}.trim.1.unpaired.fq.gz"),
        r2_unpaired=temp("output/trimmed/{sample}-{rep, [^-]+}-{unit}.trim.2.unpaired.fq.gz")
    log:
        "output/logs/trimmomatic/{sample}-{rep}-{unit}.trimmomatic.log"
    params:
        trimmer=["ILLUMINACLIP:" + config["trimmomatic"]["adapter"] + config["trimmomatic"]["adapter_trimmer"], config["trimmomatic"]["trimmer"]]
    threads:
        config["threads"]
    wrapper:
        f"file:{snake_dir}/wrappers/trimmomatic/pe" 

rule trim_se:
    input:
        lambda wildcards: "data/" + samples.loc[(wildcards.sample, wildcards.rep, wildcards.unit), "fq1"]
    output:
        temp("output/trimmed/{sample}-{rep, [^-]+}-{unit, [^.]+}.trim.fq.gz")
    log:
        "output/logs/trimmomatic/{sample}-{rep}-{unit}.trimmomatic.log"
    params:
        trimmer=["ILLUMINACLIP:" + config["trimmomatic"]["adapter"] + config["trimmomatic"]["adapter_trimmer"], config["trimmomatic"]["trimmer"]]
    threads:
        config["threads"]
    wrapper:
        f"file:{snake_dir}/wrappers/trimmomatic/se" 

