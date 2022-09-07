docker build -t kaist984 \ 
    --build-arg USER_NAME=kaist984 \
    --build-arg PASSWORD=geometry \
    --build-arg UID=$UID \
    --build-arg GID=$UID \
    .