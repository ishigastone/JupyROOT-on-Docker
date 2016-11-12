FROM ubuntu:14.04

RUN apt-get update && apt-get install -y --no-install-recommends \
	binutils \
	build-essential \
	dpkg-dev \	
	git \
	g++ \
	gcc \
	libx11-dev \
	libxpm-dev \
	libxft-dev \
	libxext-dev \
	make \
	python-dev \
	python-pip 

RUN apt-get install -y --no-install-recommends imagemagick

#RUN mkdir -p /home/root/tmp
#ADD root_v6.06.08.source.tar.gz /home/root/tmp
#RUN cd /home/root/tmp/root-6.06.08/
#RUN mkdir -p root_build && cd root_build
#RUN cmake ../ -DCMAKE_INSTALL_PREFIX=/opt/root && cmake --build . -- -j8
#RUN cmake --build . --target install
#RUN rm -rf /home/root/tmp/root-6.06.08/

ADD root_v6.06.08.Linux-ubuntu14-x86_64-gcc4.8.tar.gz /opt/
ENV ROOTSYS /opt/root
ENV PATH $ROOTSYS/bin:$PATH
ENV LD_LIBRARY_PATH $ROOTSYS/lib:$LD_LIBRARY_PATH
ENV PYTHONPATH $ROOTSYS/lib:$PYTHONPATH

RUN pip install -U pip
RUN pip install metakernel zmq
RUN pip install jupyter

RUN mkdir -p /root/.local/share/jupyter/kernels
RUN cp -r $ROOTSYS/etc/notebook/kernels/root /root/.local/share/jupyter/kernels
EXPOSE 8888

RUN mkdir /rootbook && cd /rootbook

ENV TINI_VERSION v0.10.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini
ENTRYPOINT ["/usr/bin/tini", "--"]

EXPOSE 8888
CMD ["jupyter", "notebook", "--port=8888", "--no-browser", "--ip=0.0.0.0", "--notebook-dir=/rootbook"]