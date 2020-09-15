def is_single_end(sample, rep, unit):
    return pd.isnull(samples.loc[(sample, rep, unit), "fq2"])
