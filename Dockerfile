FROM ubuntu:18.04

LABEL maintainer="Cedric Gerber <gerber.cedric@gmail.com>"


#Install all packages needed
#see https://askubuntu.com/questions/551840/unable-to-locate-package-libc6-dbgi386-in-docker
#http://processors.wiki.ti.com/index.php/Linux_Host_Support_CCSv6

RUN apt-get update && apt-get install -y \
#  libpython2.7				    \
  unzip         				\
  wget                          \
#  python2.7                     \
  software-properties-common

RUN add-apt-repository ppa:jonathonf/python-3.6
RUN apt-get update && apt-get install -y \
  python3-pip               \
#  python-pip                \
  python3.6
  
#Wrapper for python 2 and 3
COPY py /scripts/py

RUN ["chmod", "+x", "/scripts/py"]

ENV PATH="/scripts:${PATH}"

#RUN pip install --upgrade pip
RUN pip3 install --upgrade pip
RUN py -3.6 -m pip install --upgrade pip

#RUN py -2 -m pip install teamcity-messages pytest mock pytest-cov pytest mock xmltodict requests pylint coloredlogs plotnine pyopenssl
RUN py -3.6 -m pip install teamcity-messages pytest mock pytest-cov pytest mock xmltodict requests pylint coloredlogs plotnine pyopenssl

RUN py -3.6 -m pip install pyserial intelhex

VOLUME /workdir
WORKDIR /workdir

CMD ["py -3.6 -m pytest"]
