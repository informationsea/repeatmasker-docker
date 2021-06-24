FROM debian:10-slim AS download-repeat-masker
ARG REPEAT_MASKER_VERSION=4.1.2-p1
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*
RUN curl -OLf https://www.repeatmasker.org/RepeatMasker/RepeatMasker-${REPEAT_MASKER_VERSION}.tar.gz
RUN tar xzf RepeatMasker-${REPEAT_MASKER_VERSION}.tar.gz

FROM debian:10-slim AS download-RMBlast
ARG RMBlast_VERSION=2.11.0
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*
RUN curl -OLf http://www.repeatmasker.org/rmblast-${RMBlast_VERSION}+-x64-linux.tar.gz
RUN tar xzf rmblast-${RMBlast_VERSION}+-x64-linux.tar.gz

FROM debian:10-slim
ARG REPEAT_MASKER_VERSION=4.1.2-p1
ARG RMBlast_VERSION=2.11.0
RUN apt-get update
RUN apt-get install -y perl python3 python3-pip pkg-config python3-h5py h5utils libhdf5-dev
RUN mkdir -p /opt /opt/trf
COPY --from=download-repeat-masker /RepeatMasker /opt/RepeatMasker-${REPEAT_MASKER_VERSION}
COPY --from=download-RMBlast /rmblast-${RMBlast_VERSION} /opt/rmblast-${RMBlast_VERSION}
COPY third_party/trf409.linux64 /opt/trf/trf
RUN chmod 755 /opt/trf/trf
ENV PATH=/opt/RepeatMasker-${REPEAT_MASKER_VERSION}:/opt/trf:/opt/rmblast-${RMBlast_VERSION}/bin:${PATH}
WORKDIR /opt/RepeatMasker-${REPEAT_MASKER_VERSION}
RUN perl configure -trf_prgm /opt/trf/trf -rmblast_dir /opt/rmblast-${RMBlast_VERSION}/bin -default_search_engine rmblast
WORKDIR /