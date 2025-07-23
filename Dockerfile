FROM ubuntu:noble

RUN apt-get update \
    && apt-get install -y \
      curl \
      git \
      lsb-release \
      python3-venv \
    && rm -rf /var/lib/apt/lists/*

RUN curl -s https://packages.osrfoundation.org/gazebo.gpg -o /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-nightly $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/gazebo-nightly.list > /dev/null

RUN apt-get update \
    && apt-get install -y libgz-sim10-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/RL

ENV PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION=python
ENV PYTHONPATH=${PYTHONPATH}:/usr/lib/python3/dist-packages/
# Force BaseLine3 to use CPU
# This is necessary to avoid issues with CUDA and the RL library
ENV CUDA_VISIBLE_DEVICES=

RUN python3 -m venv venv \
    && . venv/bin/activate \
    && pip3 install stable-baselines3[extra] \
    && pip3 uninstall -y opencv-python \
    && pip3 install opencv-python-headless

RUN git clone https://github.com/gazebosim/gz-sim/ -b main

WORKDIR /opt/RL/gz-sim/examples/scripts/reinforcement_learning/simple_cart_pole

RUN echo '#!/bin/bash\n\
source /opt/RL/venv/bin/activate\n\
python3 cart_pole_env.py\n\
' > /opt/entrypoint.sh \
    && chmod +x /opt/entrypoint.sh

ENTRYPOINT ["/opt/entrypoint.sh"]
