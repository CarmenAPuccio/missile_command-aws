FROM amazonlinux:latest

RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
    && yum install -y nginx \
    && touch /var/log/nginx/access.log \
    && touch /var/log/nginx/error.log \
	# forward request and error logs to docker log collector
	&& ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

COPY missile_command /usr/share/nginx/html/

EXPOSE 80

COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
HEALTHCHECK --interval=30s --timeout=5s --retries=5 --start-period=30s CMD curl --fail http://127.0.0.1: || exit 1