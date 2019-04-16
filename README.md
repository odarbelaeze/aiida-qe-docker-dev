# AiiDA Quantum espresso dockerized dev environment

A complete development environment for the aiida quantumespresso plugin.

## Usage

First you need to build the image:

```
git clone https://github.com/odarbelaeze/aiida-qe-docker-dev.git
cd aiida-qe-docker-dev
# The args make the aiida user match your user
docker build \
    --build-arg GID=`id -g` \
    --build-arg UID=`id -u` \
    --build-arg PYTHON=python3 \
    -t aiida-qe-dev:py3 -t aiida-qe-dev:latest .
```

You can also build an image to work with legacy python:

```
docker build \
    --build-arg GID=`id -g` \
    --build-arg UID=`id -u` \
    --build-arg PYTHON=python \
    -t aiida-qe-dev:py2 .
```

Then you're ready to start developing against your own clone of aiida quantum
espresso:

```
# This will drop you into a shell with aiida-quantumespresso on it
docker run --rm -it -v /path/to/aiida/quantumespresso:/home/aiida/code aiida-qe-dev
# You should install your "local version of the repo"
pip install -e .
# Then you can issue some commands as though you were in your terminal
verdi code list
python -m pytest tests/
```

## Links of interest

- Link to the repo: [plugin repo]
- Lattest aiida develop: [aiida develop]
- SSSP Efficiency pseudos family: [sssp efficiency]


[plugin repo]: https://github.com/aiidateam/aiida-quantumespresso
[aiida develop]: https://github.com/aiidateam/aiida_core
[sssp efficiency]: https://www.materialscloud.org/discover/data/discover/sssp/downloads/SSSP_efficiency_pseudos.tar.gz
