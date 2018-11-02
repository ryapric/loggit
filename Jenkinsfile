pipeline {
  agent {
    docker {
      image 'rocker/tidyverse:3.5.1'
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
    stage('Set environment variable(s)') {
      steps {
        sh '''
        prevars="--no-site-file --no-environ --no-save --no-restore --quiet"
        '''
      }
    }
    stage('R CMD build') {
      steps {
        sh '''
        R $prevars CMD build . --no-resave-data --no-manual
        '''
      }
    }
    stage('R CMD check') {
      steps {
        sh '''
        R $prevars CMD check  *.tar.gz --as-cran --timings --no-manual
        '''
      }
    }
  }
}
