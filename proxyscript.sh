#!/bin/bash

enableProxy()
{
    echo "echo \"Setting proxy to: \"$PROXY"

    echo "export http_proxy="$PROXY
    echo "export https_proxy="$PROXY
    echo "export HTTP_PROXY="$PROXY
    echo "export HTTPS_PROXY="$PROXY

    echo "echo \"Set ENV proxy OK...\""

    echo "npm config set proxy $PROXY"
    echo "npm config set https-proxy $PROXY"

    echo "echo \"Set NPM proxy config OK...\""
}

deleteProxy()
{
    echo "unset http_proxy"
    echo "unset https_proxy"
    echo "unset HTTP_PROXY"
    echo "unset HTTPS_PROXY"

    echo "echo \"Deleted ENV proxy OK...\""

    echo "npm config delete proxy"
    echo "npm config delete https-proxy"

    echo "echo \"Deleted NPM proxy config OK...\""
}

if [ "$2" != "" ]; then
    PROXY=$2
else
    PROXY="http://localhost:8118"
fi



if [ "$1" == "enable" ] || [ "$1" == "" ]; then
    enableProxy
elif [ "$1" == "delete" ]; then
    echo "echo \"Deleting proxy variables...\""
    deleteProxy
else
    echo "echo \"No comma (\"$1\") not understood!\""
fi
