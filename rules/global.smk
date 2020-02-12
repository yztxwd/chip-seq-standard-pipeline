def is_single_end(sample, replicate, unit):
    return pd.isnull(units.loc[(sample, replicate, unit), "fq2"])