docker build \
    --build-arg GID=`id -g` \
    --build-arg UID=`id -u` \
    --build-arg PYTHON=python3 \
    -t aiida-qe-dev:py3 .

docker build \
    --build-arg GID=`id -g` \
    --build-arg UID=`id -u` \
    --build-arg PYTHON=python \
    -t aiida-qe-dev:py2 .