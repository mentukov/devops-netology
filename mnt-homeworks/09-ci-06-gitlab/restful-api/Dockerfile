FROM centos:centos7
RUN yum -y update;
#RUN yum install python3 python3-pip
#COPY requirements.txt requirements.txt
RUN yum install -y gcc openssl-devel bzip2-devel libffi-devel zlib-devel xz-devel wget make
RUN cd /usr/src; wget https://www.python.org/ftp/python/3.7.11/Python-3.7.11.tgz ; tar xzf Python-3.7.11.tgz; cd Python-3.7.11; \
    ./configure --enable-optimizations && make altinstall
RUN /usr/local/bin/python3.7 -m pip install --upgrade pip
RUN /usr/local/bin/python3.7 -m pip install flask flask-jsonpify flask-restful
#RUN pip3 install -r requirements.txt
RUN mkdir /python_api
COPY python-api.py /python_api/python-api.py
#CMD ["python3","/python_api/python-api.py"]
CMD ["python3.7","/python_api/python-api.py"]
CMD /bin/sh
