FROM python:3.12-slim AS base

ARG API_HOST
ARG API_PORT

ENV API_HOST=${API_HOST} \
    API_PORT=${API_PORT}


# ---------- Builder ----------
FROM base AS builder

ENV VENV=/opt/venv
RUN python -m venv $VENV
ENV PATH="$VENV/bin:$PATH"

WORKDIR /build
COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# ---------- Runtime ----------
FROM base AS main

ENV VENV=/opt/venv
ENV PATH="$VENV/bin:$PATH"

RUN useradd -ms /bin/bash appuser

COPY --from=builder $VENV $VENV

WORKDIR /app
COPY app.py .

EXPOSE ${API_PORT}
USER appuser

CMD ["sh", "-c", "gunicorn -b ${API_HOST}:${API_PORT} app:app"]
