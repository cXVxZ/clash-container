FROM --platform=${TARGETPLATFORM} dreamacro/clash:latest

RUN apk add --no-cache iptables

COPY --chmod=755 entrypoint.sh /entrypoint.sh

ENTRYPOINT []
CMD ["sh", "/entrypoint.sh"]
