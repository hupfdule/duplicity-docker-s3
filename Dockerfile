FROM debian:buster-slim

# Install required packages
RUN apt-get update \
  && apt-get install \
    librsync-dev \
    wget \
    gettext \
    gcc \
    gnupg \
    python3 \
    python3-pip \
    python3-six \
    librsync1 \
    --yes \
  && apt-get clean --yes \
  && rm -rf /var/lib/apt/lists/*

# Install required python packages
RUN pip3 install \
  --no-cache-dir \
  boto==2.49.0 \
  boto3==1.14.18 \
  fasteners==0.15 \
  future==0.18.2 \
  python-gettext==4.0 \
  urllib3==1.25.9

# Download and install duplicity
RUN DUPLICITY_VERSION=0.8.14 \
      && DUPLICITY_URL=https://code.launchpad.net/duplicity/0.8-series/$DUPLICITY_VERSION/+download/duplicity-$DUPLICITY_VERSION.tar.gz \
      && cd /tmp/ \
      && wget $DUPLICITY_URL \
      && tar xf duplicity-$DUPLICITY_VERSION.tar.gz \
      && rm -f duplicity-$DUPLICITY_VERSION.tar.gz \
      && cd duplicity-$DUPLICITY_VERSION \
      && python3 setup.py install --prefix=/usr/local \
      && cd .. \
      && rm -rf duplicity-$DUPLICITY_VERSION

# Remove dependencies that were only necessary for installation
RUN apt-get remove --purge --autoremove \
  gcc \
  librsync-dev \
  python3-pip \
  --yes

# Create specific duplicity user
# and create mount points
#RUN useradd -u 1896 duplicity \
#      && mkdir -p /home/duplicity/.cache/duplicity \
#      && chown duplicity:duplicity /home/duplicity/.cache/duplicity \
#      && mkdir -p /home/duplicity/.gnupg \
#      && chmod -R go+rwx /home/duplicity \
#      && mkdir /backup_source
#
#USER duplicity

# Set the ENTRYPOINT
ENTRYPOINT ["/usr/local/bin/duplicity"]
