FROM ubuntu

RUN apt-get update && apt-get install -qq --yes bash curl unzip tar

WORKDIR /root
RUN curl -o miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
RUN bash ./miniconda.sh -b -p $HOME/miniconda3
ENV PATH="/root/miniconda3/bin:${PATH}"

RUN conda install -y -c conda-forge notebook
RUN conda install -y -c conda-forge widgetsnbextension
RUN conda install -y -c conda-forge xeus-cling=0.9.0
RUN conda install -y -c conda-forge xwidgets
RUN conda update conda

RUN curl -o algoviz.tar.gz https://abbozza.informatik.uos.de/aud/jupyter/algoviz.tar.gz
RUN tar xv -C "$HOME/miniconda3" -f algoviz.tar.gz

RUN mkdir -p $HOME/AuD/jupyter

RUN echo "AUD_HOME=$HOME/AuD/jupyter" > $HOME/.audrc
RUN echo "AUD_PORT=8888" >> $HOME/.audrc

RUN echo "PATH=$HOME/miniconda3/bin:\$PATH" >> .bashrc

ADD aud_patch miniconda3/bin/
RUN chmod +x $HOME/miniconda3/bin/aud_patch

EXPOSE 8888

ADD start.sh /root/
RUN ["chmod", "+x", "/root/start.sh"]
ENTRYPOINT [ "/root/start.sh" ]