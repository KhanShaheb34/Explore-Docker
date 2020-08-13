FROM ubuntu
RUN apt -y update
RUN apt -y install g++
COPY . /usr/src/myapp
WORKDIR /usr/src/myapp
RUN g++ -o test test.cpp
CMD ./test