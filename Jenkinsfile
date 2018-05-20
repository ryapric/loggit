pipeline {
  agent any
  stages {
    stage('R CMD check') {
      steps {
        sh '''devtools::install_deps()
prevars="--no-site-file --no-environ --no-save --no-restore --quiet"
R $prevars CMD build . --no-resave-data --no-manual
R $prevars CMD check  *.tar.gz --as-cran --timings --no-manual
'''
      }
    }
  }
}