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
          // "Ruby 2.1.10 - Puppet 4.0.0":  { UnitTests('2.1.10', '4.0.0') },
          // "Ruby 2.1.10 - Puppet 4.1.0":  { UnitTests('2.1.10', '4.1.0') },
          // "Ruby 2.1.10 - Puppet 4.2.3":  { UnitTests('2.1.10', '4.2.3') },
          // "Ruby 2.1.10 - Puppet 4.3.2":  { UnitTests('2.1.10', '4.3.2') },
          // "Ruby 2.1.10 - Puppet 4.4.2":  { UnitTests('2.1.10', '4.4.2') },
          // "Ruby 2.1.10 - Puppet 4.5.3":  { UnitTests('2.1.10', '4.5.3') },
          // "Ruby 2.1.10 - Puppet 4.6.2":  { UnitTests('2.1.10', '4.6.2') },
          // "Ruby 2.1.10 - Puppet 4.7.1":  { UnitTests('2.1.10', '4.7.1') },
          // "Ruby 2.1.10 - Puppet 4.8.2":  { UnitTests('2.1.10', '4.8.2') },
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
