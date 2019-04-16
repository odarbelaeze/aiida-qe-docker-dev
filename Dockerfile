FROM ubuntu:latest

ARG UID=1000
ARG GID=1000
ARG PYTHON=python3

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -y update && apt-get install -y locales
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone

ENV TZ=Europe/Zurich
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && locale-gen

ENV PYTHONDONTWRITEBYTECODE 1
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get install -y \
    ${PYTHON} ${PYTHON}-virtualenv ${PYTHON}-dev \
    postgresql build-essential \
    rabbitmq-server \
    quantum-espresso \
    sudo git wget unzip

RUN addgroup --gid ${GID} aiida \
    && adduser --disabled-password --gecos '' --gid ${GID} --uid ${UID} aiida \
    && adduser aiida sudo \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER aiida:aiida
WORKDIR /home/aiida

# Prepare virtual environment with latest aiida core develop and latest plugin
RUN wget https://github.com/aiidateam/aiida-quantumespresso/archive/develop.zip \
    && unzip develop.zip && rm develop.zip \
    && wget https://www.materialscloud.org/discover/data/discover/sssp/downloads/SSSP_efficiency_pseudos.tar.gz \
    && tar -xzf SSSP_efficiency_pseudos.tar.gz && rm SSSP_efficiency_pseudos.tar.gz \
    && ${PYTHON} -m virtualenv --python=${PYTHON} venv && . venv/bin/activate \
    && pip install -U "pip<19" \
    && pip install -U git+https://github.com/aiidateam/aiida_core@develop \
    && pip install "./aiida-quantumespresso-develop[dev]"


# Prepare the database so that verdi has some prerequisits to run from
COPY bootstrap.sh bootstrap.sh
RUN ./bootstrap.sh

# The entrypoint runs the database and rabbitmq before running any other code
WORKDIR /home/aiida/code
COPY entrypoint.sh /bin/entrypoint.sh
ENTRYPOINT ["/bin/entrypoint.sh"]
CMD ["/bin/bash"]
