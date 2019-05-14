#!groovy
@Library('my-lib') _

pipeline {
  agent none
  triggers {
    cron('H H 7 * *')
  }
  stages {
    stage('Quality Check') {
      steps {
       QualityChecks()
      }
    }
    stage('Unit Tests') {
      steps {
        parallel(
          "Ruby 2.2.0 - Puppet 4.9.4": { UnitTests('2.2.0', '4.9.4') },
          "Ruby 2.2.0 - Puppet 4.10.12": { UnitTests('2.2.0', '4.10.12') },
          "Ruby 2.4.0 - Puppet 5.0.1": { UnitTests('2.4.0', '5.0.1') },
          "Ruby 2.4.0 - Puppet 5.1.0": { UnitTests('2.4.0', '5.1.0') },
          "Ruby 2.4.0 - Puppet 5.2.0": { UnitTests('2.4.0', '5.2.0') },
          "Ruby 2.4.0 - Puppet 5.3.1": { UnitTests('2.4.0', '5.3.1') }
        )
      }
    }
  }
}
