FROM clojure:openjdk-11-tools-deps-bullseye

RUN apt install -y --no-install-recommends wget && \
    apt autoremove -y && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# Set non-root user
ENV USER="user"
RUN useradd -ms /bin/bash $USER
USER $USER 
ENV HOME="/home/$USER"
WORKDIR $HOME
RUN mkdir -p .clojure
COPY .clojure/deps.edn .clojure
RUN clj -P

EXPOSE 9000-10000

ENTRYPOINT ["clojure", "-M:alpha/hotload-libs:repl/nrepl", "-p", "9999", "-b", "0.0.0.0"]
# ENTRYPOINT ["/bin/bash"]
