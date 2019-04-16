FROM ubuntu:latest

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
    python3 python3-venv python3-dev \
    postgresql build-essential \
    rabbitmq-server \
    quantum-espresso \
    sudo git

RUN adduser --disabled-password --gecos '' aiida
RUN adduser aiida sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER aiida:aiida
WORKDIR /home/aiida
COPY --chown=aiida:aiida ./latest-dev.tar.gz /home/aiida/latest-dev.tar.gz
RUN tar -xf latest-dev.tar.gz \
    && python3 -m venv venv && . venv/bin/activate \
    && pip install -U "pip<19" \
    && pip install -U git+https://github.com/aiidateam/aiida_core@develop \
    && pip install -e "./original[dev]"

COPY --chown=aiida:aiida ./SSSP_efficiency_pseudos /home/aiida/pseudos
COPY bootstrap.sh bootstrap.sh
RUN ./bootstrap.sh

WORKDIR /home/aiida/code
COPY entrypoint.sh /bin/entrypoint.sh
ENTRYPOINT ["/bin/entrypoint.sh"]
CMD ["/bin/bash"]
