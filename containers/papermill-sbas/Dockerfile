FROM nfcore/base:1.9

LABEL authors="Christina Chatzipantsiou <chatzipantsiou@gmail.com>" \
      description="Docker image containing dependencies for the TheJacksonLaboratory/sbas analysis"

RUN apt-get update -y && \
    apt-get install --no-install-recommends -y \
    nano \
    procps \
    zlib1g-dev \
    libzmq3-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    jupyter-core \
    jupyter-client && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

COPY environment.yml /
COPY install.R /

RUN conda install r-base r-devtools r-biocmanager -y && \
    conda env update --name base --file /environment.yml && \
    conda clean -a && \
    Rscript /install.R

ENV PATH /opt/conda/envs/base/bin:$PATH
ENV PATH /opt/conda/envs/:$PATH