rule trim_pe:
    input:
        r1=lambda wildcards: units.loc[(wildcards.sample, wildcards.unit), ["fq1"]],
        r2=lambda wildcards: units.loc[(wildcards.sample, wildcards.unit), ["fq2"]]
    output:
        r1="trimmed/{sample}-{unit}.1.fq.gz",
        r2="trimmed/{sample}-{unit}.2.fq.gz",
        r1_unpaired=temp("trimmed/{sample}-{unit}.1.unpaired.fq.gz"),
        r2_unpaired=temp("trimmed/{sample}-{unit}.2.unpaired.fq.gz")
    log:
        "logs/{sample}-{unit}.trimmomatic.log"
    params:
        trimmer=["LEADING:3", "TAILING:3", "SLIDINGWINDOW:4:15", "MINLEN:15"]
    threads:
        32
    wrapper:
        "0.49.0/bio/trimmomatic/pe"

rule trim_se:
    input:
        lambda wildcards: units.loc[(wildcards.sample, wildcards.unit), ["fq1", "fq2"]].dropna()
    output:
        "trimmed/{sample}-{unit, [^.]+}.fq.gz"
    log:
        "logs/{sample}-{unit}.trimmomatic.log"
    params:
        trimmer=["LEADING:3", "TAILING:3", "SLIDINGWINDOW:4:15", "MINLEN:15"]
    threads:
        32
    wrapper:
        "0.49.0/bio/trimmomatic/se"

