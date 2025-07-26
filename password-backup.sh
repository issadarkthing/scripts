#!/usr/bin/env bash

cd /tmp
tar -czf password-store.tar.gz -C "$HOME" .password-store
export AWS_PROFILE=raziman 
aws s3 cp /tmp/password-store.tar.gz s3://pass-iesdfk2buzee8kkg/
