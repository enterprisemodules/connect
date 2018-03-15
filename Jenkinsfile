#!groovy
@Library('my-lib') _

pipeline {
  agent none
  triggers {
    cron('H H * * *')
  }
  stages {
    // stage('Quality Checks') {
    //   steps {
    //     QualityChecks()
    //   }
    // }
    stage('Unit tests') {
      steps {
        parallel(
          // It uses data in modules. So needs at least puppet 4.9
          "Ruby 2.1.10 - Puppet 4.9.4":  { UnitTests('2.1.10', '4.9.4') },
          "Ruby 2.1.10 - Puppet 4.10.8": { UnitTests('2.1.10', '4.10.8') },
          "Ruby 2.4.0 - Puppet 5.0.1":  { UnitTests('2.4.0', '5.0.1') },
          "Ruby 2.4.0 - Puppet 5.1.0":  { UnitTests('2.4.0', '5.1.0') },
          "Ruby 2.4.0 - Puppet 5.2.0":  { UnitTests('2.4.0', '5.2.0') },
          "Ruby 2.4.0 - Puppet 5.3.1":  { UnitTests('2.4.0', '5.3.1') },
        )
      }
    }
    // stage('Acceptance tests') {
    //   steps {
    //     parallel(
    //       "Ruby 2.1.10 - Puppet 5.2.0": { AcceptanceTests('2.1.10', '5.2.0') }
    //     )
    //   }
    // }
  }
}
