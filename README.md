# Volant

[![Build Status](https://travis-ci.org/HakubJozak/volant.svg)](https://travis-ci.org/HakubJozak/volant.svg?branch=ember)

An ad-hoc system for a volunteering organization (INEX-SDA)[http://www.inex-sda.cz] that is organizing workcamps in Czech Republic and
sending volunteers to similar organizations across the globe. As all those NGOs have similar workflow, this 'placement tool' should be useful
for any of them. See the [web for more details](http://hakubjozak.github.io/volant/).

## Install

### Requirements

 - Postgres client

    sudo apt-get install libpq-dev 

 - wkhtmltopdf (for PDF versions of VEFs)

    sudo apt-get install wkhtmltopdf xvfb
    echo 'xvfb-run --server-args="-screen 0, 1024x768x24" /usr/bin/wkhtmltopdf $*' | sudo tee --apend /usr/local/bin/wkhtmltopdf

### Database Requirements

- Postgres server 9.4 or higher with unaccent extension

    sudo apt-get install postgresql postgresql-contrib
