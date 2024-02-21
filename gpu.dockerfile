# 使用 nvidia/cuda 作为基础镜像
FROM nvidia/cuda:12.3.1-base-ubuntu22.04
USER root

# 设置环境变量
ARG version=1.8.6
ENV name="1" 
ENV num=1
ENV token="MUHHZYNAUSWPQAPQVEEDPWVOIQTBJBBZFAJKZURUGBAIKFAPHRUYPUMFGFEG"
ENV url="https://mine.qubic.li/"


# 换源为清华源并更新源，创建目录并下载解压qli-Client，更改appsettings.json
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak && \
  echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy main restricted universe multiverse" >> /etc/apt/sources.list && \
  echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse" >>/etc/apt/sources.list && \
  echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse" >>/etc/apt/sources.list && \
  echo "deb http://security.ubuntu.com/ubuntu/ jammy-security main restricted universe multiverse" >>/etc/apt/sources.list && \
  apt-get update && apt-get install -y libicu-dev wget && \
  rm -rf /var/lib/apt/lists/* && \
  mkdir /q && \
  wget -O /q/qli-Client-${version}-Linux-x64.tar.gz https://dl.qubic.li/downloads/qli-Client-${version}-Linux-x64.tar.gz && \
  tar -xzvf /q/qli-Client-${version}-Linux-x64.tar.gz -C /q/ && \ 
  rm /q/qli-Client-${version}-Linux-x64.tar.gz && \   
  mv /q/qli-Client /q/trainer

# 设置工作目录
WORKDIR /q

# 在容器启动时运行命令
CMD sh -c "echo '{\"Settings\": {\"baseUrl\": \"$url\",\"amountOfThreads\": $num,\"payoutId\": \"$token\",\"accessToken\": null,\"overwrites\": {\"CUDA\": \"12\"},\"allowHwInfoCollect\": true,\"alias\": \"$name\"}}' > appsettings.json && ./trainer"