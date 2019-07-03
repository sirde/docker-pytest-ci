#FROM resin/rpi-raspbian
#FROM balenalib/raspberrypi3-debian
FROM balenalib/raspberrypi3-ubuntu-python:latest

LABEL maintainer="Cedric Gerber <gerber.cedric@gmail.com>"


#Install all packages needed
#see https://askubuntu.com/questions/551840/unable-to-locate-package-libc6-dbgi386-in-docker
#http://processors.wiki.ti.com/index.php/Linux_Host_Support_CCSv6

RUN apt-get clean && apt-get update && apt-get install -y   \
   python3-numpy 				\
  build-essential               \
  python3-pip                   \
  usbutils dos2unix             \
  python3-dev                    \
  libffi6                        \
  libffi-dev                     \
  libssl-dev       

    
#Wrapper for python 2 and 3
COPY py /scripts/py

RUN ["chmod", "+x", "/scripts/py"]

ENV PATH="/scripts:${PATH}"

RUN pip3 install --upgrade pip setuptools

RUN py -3 -m pip install -U bottleneck rtree teamcity-messages pytest pytest-cov mock xmltodict requests pylint coloredlogs pyserial nfcpy ipaddress flaky pyopenssl

COPY patch.txt /scripts/patch.txt
RUN dos2unix /scripts/patch.txt

RUN find / -name "tt2_nxp.py"
RUN patch --verbose /usr/local/lib/python3.6/dist-packages/nfc/tag/tt2_nxp.py < /scripts/patch.txt 

#COPY bitscope-library_2.0.FE26B_armhf.deb /scripts/bitscope-library_2.0.FE26B_armhf.deb
#RUN dpkg -i /scripts/bitscope-library_2.0.FE26B_armhf.deb

#COPY python-bindings-2.0-DC01L /scripts/python-bindings-2.0-DC01L
#WORKDIR /scripts/python-bindings-2.0-DC01L
#RUN pwd
#RUN ls
#RUN  BASECFLAGS="" OPT="" CFLAGS="-O3" py -2 setup-bitlib.py install


VOLUME /workdir
WORKDIR /workdir

CMD ["py -3 -m pytest"]
