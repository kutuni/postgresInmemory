FROM postgres:10.5-alpine


# make the "en_US.UTF-8" locale so postgres will be utf-8 enabled by default
# alpine doesn't require explicit locale-file generation
ENV LANG en_EN.utf8

# make the sample config easier to munge (and "correct by default")
#RUN sed -ri "s!^#?(listen_addresses)\s*=\s*\S+.*!\1 = '*'!" /usr/local/share/postgresql/postgresql.conf
#RUN sed -ri "s!^#?(shared_buffers)\s*=\s*\S+.*!\1 = '1024MB'!" /usr/local/share/postgresql/postgresql.conf
#RUN echo "shared_preload_libraries = 'pg_stat_statements'" >> /usr/local/share/postgresql/postgresql.conf
#RUN echo "pg_stat_statements.max = 10000" >> /usr/local/share/postgresql/postgresql.conf
#RUN echo "pg_stat_statements.track = all" >> /usr/local/share/postgresql/postgresql.conf

RUN mkdir -p /var/run/postgresql && chown -R postgres:postgres /var/run/postgresql && chmod 2777 /var/run/postgresql

ENV PATH /usr/lib/postgresql/$PG_MAJOR/bin:$PATH
EXPOSE 5432

COPY docker-entrypoint.sh /

ADD createramfs.sh /docker-entrypoint-initdb.d/

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["postgres"]

ADD createtables.sh /
ADD run.sh /
RUN chmod +x /createtables.sh /run.sh

RUN chmod +x /docker-entrypoint-initdb.d/* /docker-entrypoint.sh  /run.sh /createtables.sh

COPY postgresql.conf /
#ENV LC_ALL="en_US.UTF-8" #for ubunru
#ENV LC_CTYPE="en_US.UTF-8"
#RUN localedef -i en_US -f UTF-8 en_US.UTF-8