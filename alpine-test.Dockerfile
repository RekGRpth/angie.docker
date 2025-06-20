FROM ghcr.io/rekgrpth/angie.docker:latest
ADD bin /usr/local/bin
ADD NimbusSans-Regular.ttf /usr/local/share/fonts/
CMD [ "nginx" ]
ENV GROUP=nginx \
    HOME=/var/cache/nginx \
    USER=nginx
STOPSIGNAL SIGQUIT
WORKDIR "$HOME"
RUN set -eux; \
    chmod +x /usr/local/bin/*.sh; \
    apk update --no-cache; \
    apk upgrade --no-cache; \
    apk add --no-cache --virtual .build \
        autoconf \
        automake \
        bison \
        brotli-dev \
        check-dev \
        cjson-dev \
        clang \
        cups-dev \
        curl \
        expat-dev \
        expect \
        expect-dev \
        file \
        findutils \
        flex \
        fltk-dev \
        g++ \
        gcc \
        gd-dev \
        geoip-dev \
        gettext-dev \
        git \
        gnu-libiconv-dev \
        jansson-dev \
        jpeg-dev \
        json-c-dev \
        krb5-dev \
        libbsd-dev \
        libc-dev \
        libgcrypt-dev \
        libpng-dev \
        libpq-dev \
        libtool \
        libxml2-dev \
        libxslt-dev \
        linux-headers \
        linux-pam-dev \
        lmdb-dev \
        make \
        musl-dev \
        openjpeg-dev \
        openldap-dev \
        pcre2-dev \
        pcre-dev \
        perl-dev \
        perl-lwp-protocol-https \
        perl-test-nginx \
        perl-utils \
        postgresql \
        postgresql-dev \
        readline-dev \
        subunit-dev \
        sqlite-dev \
        util-linux-dev \
        valgrind \
        yaml-dev \
        zlib-dev \
    ; \
    apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing --virtual .edge \
        perl-test-file \
    ; \
    mkdir -p "$HOME/src"; \
    cd "$HOME/src"; \
    git clone -b master https://github.com/RekGRpth/angie.git; \
    mkdir -p "$HOME/src/angie/modules"; \
    cd "$HOME/src/angie/modules"; \
    git clone -b main https://github.com/RekGRpth/nginx-ejwt-module.git; \
    git clone -b main https://github.com/RekGRpth/ngx_http_error_page_inherit_module.git; \
    git clone -b main https://github.com/RekGRpth/ngx_http_include_server_module.git; \
    git clone -b main https://github.com/RekGRpth/ngx_http_json_var_module.git; \
    git clone -b main https://github.com/RekGRpth/ngx_pq_module.git; \
    git clone -b master https://github.com/RekGRpth/echo-nginx-module.git; \
    git clone -b master https://github.com/RekGRpth/encrypted-session-nginx-module.git; \
    git clone -b master https://github.com/RekGRpth/form-input-nginx-module.git; \
    git clone -b master https://github.com/RekGRpth/headers-more-nginx-module.git; \
#    git clone -b master https://github.com/RekGRpth/iconv-nginx-module.git; \
    git clone -b master https://github.com/RekGRpth/nginx_csrf_prevent.git; \
    git clone -b master https://github.com/RekGRpth/nginx-push-stream-module.git; \
#    git clone -b master https://github.com/RekGRpth/nginx-upload-module.git; \
    git clone -b master https://github.com/RekGRpth/nginx-upstream-fair.git; \
    git clone -b master https://github.com/RekGRpth/nginx-uuid4-module.git; \
    git clone -b master https://github.com/RekGRpth/ngx_brotli.git; \
    git clone -b master https://github.com/RekGRpth/ngx_devel_kit.git; \
    git clone -b master https://github.com/RekGRpth/ngx_http_auth_basic_ldap_module.git; \
    git clone -b master https://github.com/RekGRpth/ngx_http_auth_pam_module.git; \
    git clone -b master https://github.com/RekGRpth/ngx_http_captcha_module.git; \
    git clone -b master https://github.com/RekGRpth/ngx_http_evaluate_module.git; \
    git clone -b master https://github.com/RekGRpth/ngx_http_headers_module.git; \
    git clone -b master https://github.com/RekGRpth/ngx_http_htmldoc_module.git; \
    git clone -b master https://github.com/RekGRpth/ngx_http_json_module.git; \
    git clone -b master https://github.com/RekGRpth/ngx_http_mustach_module.git; \
    git clone -b master https://github.com/RekGRpth/ngx_http_remote_passwd.git; \
    git clone -b master https://github.com/RekGRpth/ngx_http_response_body_module.git; \
    git clone -b master https://github.com/RekGRpth/ngx_http_sign_module.git; \
#    git clone -b master https://github.com/RekGRpth/ngx_http_substitutions_filter_module.git; \
    git clone -b master https://github.com/RekGRpth/ngx_http_time_var_module.git; \
    git clone -b master https://github.com/RekGRpth/ngx_http_zip_var_module.git; \
    git clone -b master https://github.com/RekGRpth/set-misc-nginx-module.git; \
    cd "$HOME/src/angie"; \
    ./configure \
        --add-dynamic-module="modules/ngx_devel_kit $(find modules -type f -name "config" | grep -v -e ngx_devel_kit -e "\.git" -e "\/t\/" | while read -r NAME; do echo -n "`dirname "$NAME"` "; done)" \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --group="$GROUP" \
        --http-client-body-temp-path=/var/tmp/nginx/client_body_temp \
        --http-fastcgi-temp-path=/var/tmp/nginx/fastcgi_temp \
        --http-log-path=/var/log/nginx/access.log \
        --http-proxy-temp-path=/var/tmp/nginx/proxy_temp \
        --http-scgi-temp-path=/var/tmp/nginx/scgi_temp \
        --http-uwsgi-temp-path=/var/tmp/nginx/uwsgi_temp \
        --lock-path=/run/nginx/nginx.lock \
        --modules-path=/usr/local/lib/nginx \
        --pid-path=/run/nginx/nginx.pid \
        --prefix=/etc/nginx \
        --sbin-path=/usr/local/bin/nginx \
        --user="$USER" \
        --with-cc-opt="-O0 -g3 -fno-omit-frame-pointer -Werror=implicit-function-declaration -Werror=incompatible-pointer-types -Wextra -Wwrite-strings -Werror -Wno-discarded-qualifiers" \
        --with-compat \
        --with-debug \
        --with-file-aio \
        --with-http_addition_module \
        --with-http_auth_request_module \
        --with-http_dav_module \
        --with-http_degradation_module \
        --with-http_flv_module \
        --with-http_geoip_module=dynamic \
        --with-http_gunzip_module \
        --with-http_gzip_static_module \
        --with-http_image_filter_module=dynamic \
        --with-http_mp4_module \
        --with-http_random_index_module \
        --with-http_realip_module \
        --with-http_secure_link_module \
        --with-http_slice_module \
        --with-http_ssl_module \
        --with-http_stub_status_module \
        --with-http_sub_module \
        --with-http_v2_module \
        --with-http_xslt_module=dynamic \
        --with-pcre \
        --with-pcre-jit \
        --with-poll_module \
        --with-select_module \
        --with-stream=dynamic \
        --with-stream_geoip_module=dynamic \
        --with-stream_realip_module \
        --with-stream_ssl_module \
        --with-stream_ssl_preread_module \
        --with-threads \
    ; \
    make -j"$(nproc)" install; \
    install -d -m 1775 -o postgres -g postgres /run/postgresql /var/log/postgresql; \
    gosu postgres initdb --auth=trust --encoding=UTF8 --pgdata=/var/lib/postgresql/data; \
    gosu postgres pg_ctl -w start --pgdata=/var/lib/postgresql/data; \
    cd "$HOME"; \
    find "$HOME/src/angie/modules" -type d -name "t" | grep -v "\.git" | sort | while read -r NAME; do cd "$(dirname "$NAME")" && prove; done; \
    gosu postgres pg_ctl -m fast -w stop --pgdata=/var/lib/postgresql/data; \
    cd /; \
    apk add --no-cache --virtual .nginx \
        apache2-utils \
        $(scanelf --needed --nobanner --format '%n#p' --recursive /usr/local | tr ',' '\n' | grep -v "^$" | sort -u | while read -r lib; do test -z "$(find /usr/local/lib -name "$lib")" && echo "so:$lib"; done) \
    ; \
    find /usr/local/bin -type f -exec strip '{}' \;; \
    find /usr/local/lib -type f -name "*.so" -exec strip '{}' \;; \
    apk del --no-cache .build; \
    apk del --no-cache .edge; \
    rm -rf "$HOME" /usr/share/doc /usr/share/man /usr/local/share/doc /usr/local/share/man; \
    find /usr -type f -name "*.la" -delete; \
    mkdir -p "$HOME"; \
    chown -R "$USER":"$GROUP" "$HOME"; \
    install -d -m 0700 -o "$USER" -g "$GROUP" /var/tmp/nginx; \
    echo done
