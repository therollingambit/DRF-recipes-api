# alpine is great and lightweight for docker
FROM python:3.9-alpine3.13
LABEL maintainers="ahmadenaya"

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

# - create virtual env
# - install dependencies
# - rm tmp dir as we dont want any extra dependencies once image created
# - add new user inside image (best practice not to use root user)
# - django-user is name of user
ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
      then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    adduser \
      --disabled-password \
      --no-create-home \
      django-user

# where executables are run
ENV PATH="/py/bin:$PATH"

USER django-user