#!/bin/bash

sudo apt update \
	&& sudo apt -y --no-install-recommends upgrade \
	&& sudo apt -y --no-install-recommends install ansible

