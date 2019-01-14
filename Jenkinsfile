pipeline {
  agent {
    docker {
      image 'rocker/tidyverse:3.5.2'
    }

  }
  stages {
    stage('Install/Update Dependency Pkgs') {
      steps {
        sh '''
        Rscript -e \'devtools::install_deps()\'
        '''
      }
    }
    stage('R CMD build') {
      steps {
        sh '''
        make build
        '''
      }
    }
    stage('R CMD check') {
      steps {
        sh '''
        make check
        '''
      }
    }
  }
}
