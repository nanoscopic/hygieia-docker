#!/bin/bash
docker run -it -v "$(pwd)/github:/data"  -v "$(pwd)/m2repo:/root/.m2/repository" livxtrm/hy_build bash