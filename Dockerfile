FROM ubuntu:18.04

LABEL maintainer="Cedric Gerber <gerber.cedric@gmail.com>"

#Install all packages needed
#see https://askubuntu.com/questions/551840/unable-to-locate-package-libc6-dbgi386-in-docker
#http://processors.wiki.ti.com/index.php/Linux_Host_Support_CCSv6

RUN apt-get update && apt-get install -y \
  unzip         				\
  wget                          \
  software-properties-common    \
  python3-pip

#Wrapper for python 2 and 3
COPY py /scripts/py

RUN ["chmod", "+x", "/scripts/py"]

ENV PATH="/scripts:${PATH}"

RUN py -3 -m pip install --upgrade pip

RUN py -3 -m pip install -U bottleneck teamcity-messages intelhex pytest pytest-cov mock xmltodict requests pylint coloredlogs pyserial nfcpy ipaddress flaky pyopenssl python-dateutil pytz rauth tqdm 
RUN py -3 -m pip install -U patch

VOLUME /workdir
WORKDIR /workdir

CMD ["py -3.6 -m pytest"]
