# Severus 1.7 with the --whitelist fixes from the whitelist-reciprocal-corroboration branch
# (https://github.com/AmberVerhasselt/Severus/tree/whitelist-reciprocal-corroboration).
# Built by .github/workflows/container.yml and published as
# docker.io/amberverhasselt/severus:1.7-whitelist-<source commit> (OCI) and
# oras://docker.io/amberverhasselt/severus-sif:1.7-whitelist-<source commit> (Apptainer SIF)
# for the lrsomatic pipeline, until KolmogorovLab/Severus releases these changes.

# The bioconda 1.7 build already carries every runtime dependency plus samtools, bgzip, tabix and
# a busybox ps (needed by Nextflow's task monitoring); only the severus package itself is replaced.
FROM quay.io/biocontainers/severus:1.7--pyhdfd78af_0

ARG SEVERUS_SRC_COMMIT=6813dee
LABEL org.opencontainers.image.title="severus (whitelist fixes)" \
      org.opencontainers.image.source="https://github.com/AmberVerhasselt/Severus" \
      org.opencontainers.image.revision="${SEVERUS_SRC_COMMIT}" \
      org.opencontainers.image.version="1.7-whitelist-${SEVERUS_SRC_COMMIT}" \
      org.opencontainers.image.description="Severus 1.7 whose --whitelist reports SVs inside the bed past the quality, minimum-support and VNTR filters, with corroboration for single-read junctions" \
      org.opencontainers.image.licenses="BSD-3-Clause"

COPY severus /opt/severus_src

# Same effect as bind-mounting the source over site-packages/severus, as the standalone scripts did.
RUN SP=$(python -c 'import os, severus; print(os.path.dirname(severus.__file__))') \
    && rm -rf "$SP" \
    && cp -r /opt/severus_src "$SP" \
    && rm -rf /opt/severus_src \
    && severus --help | grep -q -- --whitelist-single-read

CMD ["severus", "--help"]
