#!/bin/sh
# File: "fynapp_gitops/gitlab_runner/gitlab_runner_run.sh"
# 2022-03-9 | CR
#
# Reference: https://docs.gitlab.com/runner/install/docker.html
# Option 1: Use local system volume mounts to start the Runner container
#
ACTION_PARAM=$1

. "../scripts/get_os_name_type.sh" ;
if [ "$OS_NAME_LOWERCASED" == "darwin" ]; then
    RUNNER_BASE_CONFIG_DIR="/Users/Shared" # MacOS
else
    RUNNER_BASE_CONFIG_DIR="/srv" # Linux
fi
RUNNER_CONFIG_DIR="${RUNNER_BASE_CONFIG_DIR}/gitlab-runner/config"

if [ "${ACTION_PARAM}" = "" ]; then
    echo "";
    echo "*** Gitlab_runner_run.sh ***";
    echo "Run the Gitlab runner on a docker container.";
    echo "The first parameter is the action to be made."
    echo "Available options:";
    echo "start, stop, restart, logs, register, install-selinux-dockersock, update-config, upgrade-version, enable-privileged, check-conectivity";
    echo "";
fi

# Action: Run the runner
if [ "${ACTION_PARAM}" = "start" ]
then
    echo "" ;
    echo "Action: Run the runner" ;
    echo "" ;
    docker run -d --name gitlab-runner --restart always \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v ${RUNNER_CONFIG_DIR}:/etc/gitlab-runner:Z \
        -p 8093:8093 \
        gitlab/gitlab-runner:latest \
        $2 $3 $4 $5 $6 $7 $8 $9 ;
    docker ps ;
fi

# Action: Stop and remove the container
if [ "${ACTION_PARAM}" = "stop" ]
then
    echo "" ;
    echo "Action: Stop and remove the container" ;
    echo "" ;
    docker stop gitlab-runner && docker rm gitlab-runner ;
fi

# Action: Restart
if [ "${ACTION_PARAM}" = "restart" ]
then
    echo "" ;
    echo "Action: Restart" ;
    echo "" ;
    docker restart gitlab-runner ;
fi

# Action: View logs
if [ "${ACTION_PARAM}" = "logs" ]
then
    echo "" ;
    echo "Action: View logs" ;
    echo "" ;
    docker logs -t -f --details gitlab-runner ;
fi

# Action: Update configuration
if [ "${ACTION_PARAM}" = "update-config" ]
then
    echo "" ;
    echo "Action: Update configuration" ;
    echo "" ;
    sh $0 restart ;
fi

# Action: Upgrade the docker image
if [ "${ACTION_PARAM}" = "upgrade-version" ]
then
    echo "" ;
    echo "Action: Upgrade the docker image" ;
    echo "" ;
    docker pull gitlab/gitlab-runner:latest ;
    sh $0 stop ;
    sh $0 start ;
fi

# Action: Register the runner
if [ "${ACTION_PARAM}" = "register" ]
then
    echo "" ;
    echo "Action: Register the runner" ;
    echo "" ;
    # https://docs.gitlab.com/runner/register/index.html#docker
    docker run --rm -it -v ${RUNNER_CONFIG_DIR}:/etc/gitlab-runner gitlab/gitlab-runner:latest register ;
    #
    # Answers:
    #
    # Enter the GitLab instance URL: https://gitlab.com/
    # Enter the registration token: <-- Check on Gitlab > Repo > Settings > CI/C > Runners
    # Enter a description for the runner: Runner on ... Server
    # >>--> Enter tags for the runner (comma-separated): fynapp-runner
    # Enter optional maintenance note for the runner: Fynapp runner @ ... in maintenance
    # >>--> Enter an executor: docker
    # Enter the default Docker image: ruby:2.7
fi

# Action: Enable privileged mode
if [ "${ACTION_PARAM}" = "enable-privileged" ]
then
    echo "" ;
    echo "Action: Enable privileged mode" ;
    echo "" ;
    echo "${RUNNER_CONFIG_DIR}/config.toml | Before the change" ;
    cat ${RUNNER_CONFIG_DIR}/config.toml
    echo "" ;
    sed -i -re 's/privileged\ =\ false/privileged\ =\ true/g' "${RUNNER_CONFIG_DIR}/config.toml"
    echo "" ;
    echo "${RUNNER_CONFIG_DIR}/config.toml | After the change" ;
    cat ${RUNNER_CONFIG_DIR}/config.toml
    sh $0 restart ;
fi

# Action: Check conectivity
if [ "${ACTION_PARAM}" = "check-conectivity" ]
then
    echo "" ;
    echo "Action: Check conectivity" ;
    echo "" ;
    URL_TO_CHECK=$2
    if [ "$URL_TO_CHECK" = "" ]; then
        URL_TO_CHECK="http://gitlab.com/api/v4/runners"
    fi
    docker run --rm -t -i alpine sh -c "apk add --no-cache curl; echo 'URL to check: ' ${URL_TO_CHECK}; echo ''; curl -X POST -I ${URL_TO_CHECK}" ;
fi

# Action: Install selinux-dockersock
if [ "${ACTION_PARAM}" = "install-selinux-dockersock" ]
then
    echo "" ;
    echo "Action: Install selinux-dockersock" ;
    echo "" ;
    # selinux-dockersock
    # A nice trick with docker is to mount the docker daemon's unix socket into a container, so that container can act as a client to the docker daemon it is running under, e.g.:
    # docker run ... -v /var/run/docker.sock:/var/run/docker.sock
    # But this doesn't work with Fedora or RHEL as the host because of their use of SELinux to harden containers. When the docker client attempts to access /var/run/docker.sock within the container, you'll get "Permission denied" errors.
    # This repo contains a small SELinux module that fixes this issue, allowing containers to access the socket.
    sudo yum install -y git policycoreutils policycoreutils-python checkpolicy ;
    sudo cd /root ;
    sudo git clone https://github.com/dpw/selinux-dockersock ;
    sudo cd /root/selinux-dockersock ;
    sudo make ;
    # Or if you are paranoid, without being root you can do
    # make dockersock.pp
    # to build the SELinux policy module package, and then load it as root with
    # semodule -i dockersock.pp
    # Should you ever wish to remove the module, do
    # semodule -r dockersock
fi

# 
# if [ "${ACTION_PARAM}" = "???" ]
# then
# fi
