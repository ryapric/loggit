pipeline {
  agent any
  stages {
    stage('R CMD check') {
      steps {
        sh '''








prevars="--no-site-file --no-environ --no-save --no-restore"
R CMD $prevars build . --no-resave-data --no-manual
R CMD $prevars check *.tar.gz --as-cran --timings --no-manual
'''
      }
    }
  }
}