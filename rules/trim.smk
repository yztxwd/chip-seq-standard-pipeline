rule trim_pe:
    input:
        r1=lambda wildcards: "data/" + units.loc[(wildcards.sample, wildcards.replicate, wildcards.unit), "fq1"],
        r2=lambda wildcards: "data/" + units.loc[(wildcards.sample, wildcards.replicate,wildcards.unit), "fq2"]
    output:
        r1=temp("output/trimmed/{sample}-{replicate}-{unit}.1.fq.gz"),
        r2=temp("output/trimmed/{sample}-{replicate}-{unit}.2.fq.gz"),
        r1_unpaired=temp("output/trimmed/{sample}-{replicate}-{unit}.1.unpaired.fq.gz"),
        r2_unpaired=temp("output/trimmed/{sample}-{replicate}-{unit}.2.unpaired.fq.gz")
    log:
        "output/logs/trimmomatic/{sample}-{replicate}-{unit}.trimmomatic.log"
    params:
        trimmer=[config["trimmomatic"]["trimmer"], config["trimmomatic"]["adapter"]]
    threads:
        config["threads"]
    wrapper:
        "0.49.0/bio/trimmomatic/pe"

rule trim_se:
    input:
        lambda wildcards: "data/" + units.loc[(wildcards.sample, wildcards.replicate, wildcards.unit), "fq1"]
    output:
        temp("output/trimmed/{sample}-{replicate}-{unit, [^.]+}.fq.gz")
    log:
        "output/logs/trimmomatic/{sample}-{replicate}-{unit}.trimmomatic.log"
    params:
        trimmer=[config["trimmomatic"]["trimmer"], config["trimmomatic"]["adapter"]]
    threads:
        config["threads"]
    wrapper:
        "0.49.0/bio/trimmomatic/se"

