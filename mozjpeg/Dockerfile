FROM alpine:3.12.3 AS mozjpeg
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk add --no-cache alpine-sdk sudo \
    && adduser -s /bin/sh -D -G abuild abuild \
    && echo "%abuild ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER abuild
RUN abuild-keygen -a -i -n -q

# Buildind mozjpeg and installing it
WORKDIR /tmp/mozjpeg
COPY --chown=abuild:abuild APKBUILD ./
RUN sudo chown abuild:abuild ./ \
    && abuild deps \
    && abuild -r \
    && sudo apk add --allow-untrusted /home/abuild/packages/tmp/x86_64/*.apk

# Create Release image without dev dependencies
FROM alpine:3.12.3 AS release
COPY --from=mozjpeg /home/abuild/packages/tmp/x86_64/mozjpeg*.apk /release/