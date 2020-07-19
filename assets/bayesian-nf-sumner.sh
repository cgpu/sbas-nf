# SE
nextflow run 'https://github.com/cgpu/sbas-nf' -with-dag flowchart.png -with-trace trace.txt -resume \
--tissues_csv 'gs://robinson-bucket/notebooks/bayesian-modeling/tissues/tissue_list_17_SE_v2.csv'  \
--notebook 'https://raw.githubusercontent.com/cgpu/sbas-nf/adds-ontologizer/papermill-notebooks/bayesian-modelling-100-events.ipynb' \
--data 'gs://robinson-bucket/notebooks/bayesian-modeling/data_bayesian_se_AS_model_B_sex_as_events.tar.gz' \
--assets 'gs://robinson-bucket/notebooks/bayesian-modeling/assets_bayesian_AS_model_B_sex_as_events.tar.gz' \
--analysis bayesian-modeling \
--model AS_model_B_sex_as_events \
--as_site_type se \
--top_n_events 100

# MXE
nextflow run 'https://github.com/cgpu/sbas-nf' -with-dag flowchart.png -with-trace trace.txt -resume \
--tissues_csv 'gs://robinson-bucket/notebooks/bayesian-modeling/tissues/tissue_index_2_MXE_v2.csv'  \
--notebook 'https://raw.githubusercontent.com/cgpu/sbas-nf/adds-ontologizer/papermill-notebooks/bayesian-modelling-100-events.ipynb' \
--data 'gs://robinson-bucket/notebooks/bayesian-modeling/data_bayesian_mxe_AS_model_B_sex_as_events.tar.gz' \
--assets 'gs://robinson-bucket/notebooks/bayesian-modeling/assets_bayesian_AS_model_B_sex_as_events.tar.gz' \
--analysis bayesian-modeling \
--model AS_model_B_sex_as_events \
--as_site_type mxe \
--top_n_events 100

# A3SS
nextflow run 'https://github.com/cgpu/sbas-nf' -with-dag flowchart.png -with-trace trace.txt -resume \
--tissues_csv 'gs://robinson-bucket/notebooks/bayesian-modeling/tissues/tissue_index_1_A3SS_v2.csv'  \
--notebook 'https://raw.githubusercontent.com/cgpu/sbas-nf/adds-ontologizer/papermill-notebooks/bayesian-modelling-100-events.ipynb' \
--data 'gs://robinson-bucket/notebooks/bayesian-modeling/data_bayesian_a3ss_AS_model_B_sex_as_events.tar.gz' \
--assets 'gs://robinson-bucket/notebooks/bayesian-modeling/assets_bayesian_AS_model_B_sex_as_events.tar.gz' \
--analysis bayesian-modeling \
--model AS_model_B_sex_as_events \
--as_site_type a3ss \
--top_n_events 100

# A5SS
nextflow run 'https://github.com/cgpu/sbas-nf' -with-dag flowchart.png -with-trace trace.txt  -resume \
--tissues_csv 'gs://robinson-bucket/notebooks/bayesian-modeling/tissues/tissue_index_1_A5SS_v2.csv'  \
--notebook 'https://raw.githubusercontent.com/cgpu/sbas-nf/adds-ontologizer/papermill-notebooks/bayesian-modelling-100-events.ipynb' \
--data 'gs://robinson-bucket/notebooks/bayesian-modeling/data_bayesian_a5ss_AS_model_B_sex_as_events.tar.gz' \
--assets 'gs://robinson-bucket/notebooks/bayesian-modeling/assets_bayesian_AS_model_B_sex_as_events.tar.gz' \
--analysis bayesian-modeling \
--model AS_model_B_sex_as_events \
--as_site_type a5ss \
--top_n_events 100

# RI
nextflow run 'https://github.com/cgpu/sbas-nf' -with-dag flowchart.png -with-trace trace.txt -resume \
--tissues_csv 'gs://robinson-bucket/notebooks/bayesian-modeling/tissues/tissue_index_3_RI_v2.csv'  \
--notebook 'https://raw.githubusercontent.com/cgpu/sbas-nf/adds-ontologizer/papermill-notebooks/bayesian-modelling-100-events.ipynb' \
--data 'gs://robinson-bucket/notebooks/bayesian-modeling/data_bayesian_ri_AS_model_B_sex_as_events.tar.gz' \
--assets 'gs://robinson-bucket/notebooks/bayesian-modeling/assets_bayesian_AS_model_B_sex_as_events.tar.gz' \
--analysis bayesian-modeling \
--model AS_model_B_sex_as_events \
--as_site_type ri \
--top_n_events 100

