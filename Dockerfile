FROM registry.cn-hangzhou.aliyuncs.com/mszs/alpine:3.10
COPY ./proxy /proxy
CMD ["/proxy"]
