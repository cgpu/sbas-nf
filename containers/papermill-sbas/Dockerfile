FROM nfcore/base:1.9

LABEL authors="Christina Chatzipantsiou <chatzipantsiou@gmail.com>" \
      description="Docker image containing dependencies for the TheJacksonLaboratory/sbas analysis"

ADD hello-papermill /hello-papermill

COPY environment.yml /
COPY install.R /

RUN conda env update --name base --file /environment.yml &&  \
    Rscript /install.R && \
    conda clean -a

ENV PATH /opt/conda/envs/base/bin:$PATH
ENV PATH /opt/conda/envs/:$PATH