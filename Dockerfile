FROM amazonlinux:latest

ENV APP /usr/local/aws.batch/

RUN mkdir -p ${APP}
COPY ./install.sh ./config.sh ./run.sh ${APP}
RUN ${APP}install.sh

CMD ["/bin/bash"]