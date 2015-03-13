# To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/passenger-docker/blob/master/Changelog.md for
# a list of version numbers.

FROM phusion/passenger-ruby21:0.9.15
MAINTAINER stirnamanj@gmail.com

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

# Install GEOS for ffi-geos required by Taxonworks
RUN apt-get update && apt-get install -y libgeos-dev libproj-dev

COPY . /home/app/taxonworks
WORKDIR /home/app/taxonworks
RUN cd /home/app/taxonworks && bundle install

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
