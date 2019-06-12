FROM resin/rpi-raspbian
#FROM balenalib/raspberrypi3-debian

LABEL maintainer="Cedric Gerber <gerber.cedric@gmail.com>"


#Install all packages needed
#see https://askubuntu.com/questions/551840/unable-to-locate-package-libc6-dbgi386-in-docker
#http://processors.wiki.ti.com/index.php/Linux_Host_Support_CCSv6

RUN apt-get clean && apt-get update && apt-get install -y   \
   python3-numpy 				\
#  libpython2.7				    \
#  unzip         				\
#  wget                          \
#  python2.7                     \
#  software-properties-common    \
#  build-essential               \
#  python-dev                    \
#  python-distlib                \
#  python-setuptools             \
#  python-pip                    \
  python3-pip                   \
#  python-wheel                  \
#  libzmq-dev                    \
#  libgdal-dev                   \
#  libfreetype6-dev              \
#  xsel xclip libxml2-dev libxslt-dev python3-numpy \
#  python-lxml python-h5py python-numexpr python-dateutil python-six python-tz python-bs4 python-html5lib python-openpyxl python-tables python-xlrd python-xlwt cython python-sqlalchemy python-xlsxwriter python-jinja2 python-boto python-gflags python-googleapi python-httplib2 python-zmq libspatialindex-dev \
#  python-numpy python-matplotlib python-mpltoolkits.basemap python-scipy python-sklearn python-statsmodels python-pandas \
  usbutils dos2unix 
#  python3-dev

    
#Wrapper for python 2 and 3
COPY py /scripts/py

RUN ["chmod", "+x", "/scripts/py"]

ENV PATH="/scripts:${PATH}"

#RUN pip install --upgrade pip setuptools
#RUN pip3 install --upgrade pip setuptools

#RUN apt-get install libffi6 libffi-dev

#RUN py -2 -m pip install -U bottleneck rtree teamcity-messages pytest mock pytest-cov pytest mock xmltodict requests pylint coloredlogs pyserial nfcpy ipaddress flaky pyopenssl
RUN py -3 -m pip install -U bottleneck rtree teamcity-messages pytest mock pytest-cov pytest mock xmltodict requests pylint coloredlogs pyserial nfcpy ipaddress flaky pyopenssl

COPY patch.txt /scripts/patch.txt
RUN dos2unix /scripts/patch.txt
RUN patch --verbose /usr/local/lib/python2.7/dist-packages/nfc/tag/tt2_nxp.py < /scripts/patch.txt 

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
