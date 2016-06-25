FROM  centos:7

# Define args and set a default value
ARG maintainer=jay.p.h.johnson@gmail.com
ARG imagename=sphinx-bootstrap
ARG registry=docker.io

MAINTAINER $maintainer
LABEL Vendor="Anyone"
LABEL ImageType="DocumentationAndDocs"
LABEL ImageName=$imagename
LABEL ImageOS=$basename
LABEL Version=$version

RUN yum -y install epel-release; yum clean all
RUN yum -y install python-pip; yum clean all; pip install --upgrade pip

RUN yum install -y texlive texlive-latex-recommended texlive-latex-extra texlive-fonts-recommended
RUN pip install Sphinx==1.4
RUN pip install sphinx_rtd_theme
RUN pip install alabaster 
RUN pip install sphinx_bootstrap_theme

# Set default environment variables.
ENV HOME /root

# Define working directory.
WORKDIR /root

# Allow triggerable events on the first time running
RUN touch /tmp/firsttimerunning

# Add Volumes and Set permissions
RUN mkdir -p -m 777 /opt/shared \
    && mkdir -p -m 777 /root/containerfiles \
    && chmod -R 777 /root 

# Add the starters and installers:
ADD ./containerfiles/ /root/containerfiles

RUN chmod -R 777 /root

ENV ENV_DEFAULT_ROOT_VOLUME /opt/blog
ENV ENV_DOC_SOURCE_DIR /opt/blog/repo/source
ENV ENV_DOC_OUTPUT_DIR /opt/blog/repo/release
ENV ENV_BASE_DOMAIN http://jaypjohnson.com
ENV ENV_GOOGLE_ANALYTICS_CODE UA-79840762-99

CMD ["/root/containerfiles/start-container.sh"]
