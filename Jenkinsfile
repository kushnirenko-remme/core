node ('ubuntu18') {
    properties([disableConcurrentBuilds()])
    cleanWs()
    stage("git"){
        checkout scm
        sh 'git submodule update --init --recursive'
    }
    stage("build"){
        sh '''
        export HOME="${PWD}"
        ./scripts/eosio_build.sh -y REM -m
        '''
    }
    stage("test"){
        sh '''
        kill -9 %% || true
        $PWD/bin/mongod --dbpath $PWD/data/mongodb -f $PWD/etc/mongod.conf --logpath $PWD/var/log/mongodb/mongod.log &
        cd ./build && PATH=$PATH:$PWD/opt/mongodb/bin make test
        kill -9 %% || echo "ok"
        '''
    }
}
