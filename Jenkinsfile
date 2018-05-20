pipeline {
  agent {
    docker {
      image 'rocker/tidyverse:3.5.0'
    }

  }
  stages {
    stage('Install/Update Dependency Pkgs') {
      steps {
        sh '''
        Rscript -e \'devtools::install_deps()\''''
      }
    }
    stage('R CMD build') {
      steps {
        sh '''
        prevars="--no-site-file --no-environ --no-save --no-restore --quiet"
        R $prevars CMD build . --no-resave-data --no-manual'''
      }
    }
    stage('R CMD check') {
      steps {
        sh '''        R $prevars CMD check  *.tar.gz --as-cran --timings --no-manual
        '''
      }
    }
  }
}