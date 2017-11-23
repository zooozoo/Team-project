FROM            klee2017/base
MAINTAINER      kaythechemist@gmail.com

# 실수 방지 : base를 오랫동안 업데이트하지 않았을 때 대비.
ENV             LANG C.UTF-8
ENV             DJANGO_SETTINGS_MODULE config.settings.dev

# 파일 복사 및 설치
COPY            . /srv/app
RUN             /root/.pyenv/versions/app/bin/pip install -r /srv/app/requirements.txt

WORKDIR         /srv/app
RUN             pyenv local app

# Nginx
RUN             cp /srv/app/.config/dev/nginx/nginx.conf /etc/nginx/nginx.conf
RUN             cp /srv/app/.config/dev/nginx/app.conf /etc/nginx/sites-available/
RUN             rm -rf /etc/nginx/sites-enabled/*
RUN             ln -sf /etc/nginx/sites-available/app.conf /etc/nginx/sites-enabled/app.conf

# uWSGI
RUN             mkdir -p /var/log/uwsgi/app

# manage.py
WORKDIR         /srv/app/explog
RUN             /root/.pyenv/versions/app/bin/python manage.py collectstatic --noinput
RUN             /root/.pyenv/versions/app/bin/python manage.py migrate --noinput

# supervisor
RUN             cp /srv/app/.config/dev/supervisor/* /etc/supervisor/conf.d/
CMD             supervisord -n

EXPOSE          80