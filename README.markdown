# News Index

## Install

    brew install resque
    brew install mongodb
    bundle install

## Check specs

    rake spec

## Run web

    rackup config.ru # Now visit http://localhost:9292/resque/overview

## Queue up some jobs

    rake queue_indicies

## Run the workers

    # Increase count for fatser processing, 10 nearly killed my laptop!
    COUNT=5 QUEUE=* rake resque:workers
