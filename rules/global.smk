def is_single_end(sample, rep, unit):
    return pd.isnull(samples.loc[(sample, rep, unit), "fq2"])

def checkcontrol(samples):
    return 'control' in samples['condition'].values

snake_dir = workflow.basedir    # define relative directory path
