FROM golang:buster

RUN apt update && apt install -y git cmake python3 clang unzip && apt clean

WORKDIR /opt

RUN git clone --depth 1 --branch 4.5.3 https://github.com/opencv/opencv.git && \
    git clone --depth 1 --branch 4.5.3 https://github.com/opencv/opencv_contrib.git && \
    cd opencv && \
    mkdir build && \
    cd build && \
    cmake \
    -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/ \
    -D PYTHON3_PACKAGES_PATH=/usr/lib/python3/dist-packages \
    -D WITH_V4L=ON \
    -D WITH_QT=OFF \
    -D WITH_OPENGL=ON \
    -D WITH_GSTREAMER=ON \
    -D OPENCV_GENERATE_PKGCONFIG=ON \
    -D OPENCV_ENABLE_NONFREE=ON \
    -D OPENCV_EXTRA_MODULES_PATH=/opt/opencv_contrib/modules \
    -D INSTALL_PYTHON_EXAMPLES=OFF \
    -D INSTALL_C_EXAMPLES=OFF \
    -D BUILD_EXAMPLES=OFF .. && \
   make -j"$(nproc)" && \
   make install


WORKDIR /app
ADD . .
RUN cd cgotorch && go mod download --json && ./build.sh && cd .. && go build ./example/resnet