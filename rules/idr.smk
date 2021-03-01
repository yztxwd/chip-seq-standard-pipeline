rule idr:
    input:
        samples=lambda wildcards: expand("output/macs2/{sample}-{rep}_peaks.narrowPeak", **wildcards, rep=["rep1", "rep2"])
    output:
        "output/idr/{sample}.idr.peaks"
    params:
        extra=""
    logs:
        "logs/idr/{sample}.log"
    conda:
        f"{snake_dir}/envs/common.yaml"
    shell:
        "idr --samples {input} --input-file-type narrowPeak --output-file {output} {params.extra} > {log}"
