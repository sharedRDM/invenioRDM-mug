#!/bin/sh

docs_link="https://github.com/sharedRDM/invenioRDM-mug/blob/main/README.md"

cleanup() {
    echo "Cleaning existing docker environment..."
    if [ -z "$1" ]; then
        echo "Nothing to clean."
        return 1
    fi
    docker stop $1
    docker rm $1
    docker volume prune --force
}

demo_data() {
    echo "Adding demo data"
    docker exec -it $1 bash -c "invenio rdm-records demo"
}

demo_users() {
    echo "Create demo normal user: mail: user01@inveniordm.example.com, password: 1234567"
    docker exec -it $1 bash -c "invenio users create user01@inveniordm.example.com --password 1234567 --active --confirm"
    echo "Create admin user: mail: admin@inveniordm.example.com, password: 1234567"
    docker exec -it $1 bash -c "\
    invenio users create admin@inveniordm.example.com --password 1234567 --active --confirm;
    invenio roles add admin@inveniordm.example.com administrator;
    "
    echo "For creating more users please check the docs. $docs_link"
}

rebuild_indices() {
    docker exec -it $1 bash -c "invenio rdm rebuild-all-indices"
}

publications() {
    echo "Setting up Publications"
    echo "Make sure to have the correct configuration for Publications.\n\
    Please visit the docs for more details: $docs_link"
    
    docker cp ./setup_publications.sh $ui_container_id:/setup_publications.sh
    docker exec $1 /setup_publications.sh
}

publications_demo() {
    publications "$1"
    echo "Adding demo data for publications"
    docker exec -it $1 bash -c "invenio marc21 demo -b -m -n 10"
}

help() {
  echo  "Usage: script.sh [OPTION]...\n\n\
    Script used to initialize the demo instance. For the optional init steps you can pass one or more of the following options:\n\n\

        demo_data           Adds invenio-rdm demo data to the instance.
        demo_users          Registers 1 regular user and 1 admin user.
        rebuild_indices     Rebuilds opensearch indices.
        publications        Sets up the necessary steps to have Publications feature available.
        publications_demo   Sets up publications + adds demo data.

    Example usecase: ./start-demo-app.sh demo_data demo_users publications_demo rebuild_indices

    If you pass more than 1 option they will be run iteratively in the passed order.\n\
    Please use with care. Calling the script a second time will delete all docker containers and start from scratch.
    For more info please visit $docs_link"
}


if [ "$1" = "help" ]; then
    help
    exit 0
fi

echo "Starting demo app..."

cleanup "$(docker ps -a -q)"

docker compose -f demo-compose.yml up -d

ui_container_id=$(docker ps | grep web-ui | awk '{print $1}')
if [ -z "$ui_container_id" ]; then
    echo "ERROR: could not identify web-ui container."
    exit 1
fi

docker cp ./wipe_recreate.sh $ui_container_id:/wipe_recreate.sh
docker exec $ui_container_id /wipe_recreate.sh

for func in "$@"
do
    $func "$ui_container_id"
done
