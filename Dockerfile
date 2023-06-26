# https://www.keycloak.org/server/containers
FROM quay.io/keycloak/keycloak:latest as builder

ENV KC_METRICS_ENABLED=true
ENV KC_HEALTH_ENABLED=true
ENV KC_FEATURES=token-exchange
ENV KC_DB=postgres

RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:latest
COPY --from=builder /opt/keycloak/lib/quarkus/ /opt/keycloak/lib/quarkus/
WORKDIR /opt/keycloak

ENV KEYCLOAK_ADMIN=admin
ENV KC_DB=postgres
ENV KC_DB_USERNAME=keycloak
ENV KC_PROXY=edge
ENV KC_HOSTNAME_STRICT=true
ENV KC_HOSTNAME_STRICT_BACKCHANNEL=true
ENV KC_HTTP_ENABLED=true

ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start"]
