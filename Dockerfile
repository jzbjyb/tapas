FROM pytorch/pytorch:1.7.1-cuda11.0-cudnn8-devel

# essential tools
RUN echo 1
RUN apt-get update
RUN apt-get -y install openssh-client vim tmux sudo apt-transport-https apt-utils curl \
    git wget lsb-release ca-certificates gnupg gcc g++ pv iftop libopenmpi-dev

# conda environment
ENV MINICONDA_VERSION py37_4.9.2
ENV PATH /opt/miniconda/bin:$PATH
RUN wget -qO /tmp/miniconda.sh https://repo.continuum.io/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh && \
    bash /tmp/miniconda.sh -bf -p /opt/miniconda && \
    conda clean -ay && \
    rm -rf /opt/miniconda/pkgs && \
    rm /tmp/miniconda.sh && \
    find / -type d -name __pycache__ | xargs rm -rf

# bugs for amulet
RUN pip install pip==9.0.0
RUN pip install ruamel.yaml==0.16 --disable-pip-version-check
RUN pip install --upgrade pip

# TAPAS env
RUN conda create -n tapas python=3.7
SHELL ["conda", "run", "-n", "tapas", "/bin/bash", "-c"]
RUN apt-get -y install protobuf-compiler
COPY requirements.txt /tmp/scripts/.
RUN pip install -r /tmp/scripts/requirements.txt
RUN conda install cudatoolkit=10.1
RUN conda install -c anaconda cudnn=7.6.5

# deepspeed
RUN pip install deepspeed
RUN apt-get -y install pdsh

# wandb
RUN pip install wandb==0.10.33
