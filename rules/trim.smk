rule trim_pe:
    input:
        r1=lambda wildcards: "data/" + units.loc[(wildcards.sample, wildcards.unit), "fq1"],
        r2=lambda wildcards: "data/" + units.loc[(wildcards.sample, wildcards.unit), "fq2"]
    output:
        r1="trimmed/{sample}-{unit}.1.fq.gz",
        r2="trimmed/{sample}-{unit}.2.fq.gz",
        r1_unpaired=temp("trimmed/{sample}-{unit}.1.unpaired.fq.gz"),
        r2_unpaired=temp("trimmed/{sample}-{unit}.2.unpaired.fq.gz")
    log:
        "logs/{sample}-{unit}.trimmomatic.log"
    params:
        trimmer=[config["trimmomatic"]["trimmer"], "ILLUMINACLIP:"config["trimmomatic"]["adapter"]]
    threads:
        config["threads"]
    wrapper:
        "0.49.0/bio/trimmomatic/pe"

rule trim_se:
    input:
        lambda wildcards: "data/" + units.loc[(wildcards.sample, wildcards.unit), "fq1"]
    output:
        "trimmed/{sample}-{unit, [^.]+}.fq.gz"
    log:
        "logs/{sample}-{unit}.trimmomatic.log"
    params:
        trimmer=[config["trimmomatic"]["trimmer"], "ILLUMINACLIP:"config["trimmomatic"]["adapter"]]
    threads:
        config["threads"]
    wrapper:
        "0.49.0/bio/trimmomatic/se"

