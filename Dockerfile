FROM ubuntu:16.04

LABEL maintainer="Cedric Gerber <gerber.cedric@gmail.com>"


#Install all packages needed
#see https://askubuntu.com/questions/551840/unable-to-locate-package-libc6-dbgi386-in-docker
#http://processors.wiki.ti.com/index.php/Linux_Host_Support_CCSv6

RUN apt-get update && apt-get install -y \
  libpython2.7				    \
  unzip         				\
  wget                          \
  python2.7                     \
  software-properties-common

RUN add-apt-repository ppa:jonathonf/python-3.6
RUN apt-get update && apt-get install -y \
  python3-pip               \
  python-pip                \
  python3.6
  
RUN pip install --upgrade pip
RUN pip3 install --upgrade pip
  
  
RUN pip install teamcity-messages pytest mock pytest-cov pytest mock xmltodict requests
RUN pip3 install teamcity-messages pytest mock pytest-cov pytest mock xmltodict requests

#Wrapper for python 2 and 3
COPY py /scripts/py

ENV PATH="/scripts:${PATH}"

VOLUME /workdir
WORKDIR /workdir

CMD ["py.test"]
