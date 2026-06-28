function exit_if_empty
    test -z (commandline | string collect --allow-empty); and exit
end
