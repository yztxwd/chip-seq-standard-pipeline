rule idr:
    input:
        samples=lambda wildcards: expand("output/macs2/{sample}-{rep}_peaks" + (".narrowPeak" if config["mode"]=="tf" else ".broadPeak"), **wildcards, rep=["rep1", "rep2"])
    output:
        "output/idr/{sample}.idr.peaks"
    params:
        extra=config["idr"]
    log:
        "logs/idr/{sample}.log"
    conda:
        "../envs/idr.yaml"
    shell:
        "idr --samples {input} --input-file-type narrowPeak --output-file {output} {params.extra} > {log}"
