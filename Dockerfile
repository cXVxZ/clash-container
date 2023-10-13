FROM --platform=${TARGETPLATFORM} dreamacro/clash:latest

RUN apk add --no-cache iptables

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT []
CMD ["sh", "/entrypoint.sh"]
