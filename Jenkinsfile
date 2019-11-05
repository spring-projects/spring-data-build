pipeline {
	agent none

	triggers {
		pollSCM 'H/10 * * * *'
		cron '@daily'
	}

	options {
		disableConcurrentBuilds()
		buildDiscarder(logRotator(numToKeepStr: '14'))
	}

	stages {
		stage("test: baseline (jdk8)") {
			when {
				anyOf {
					branch 'master'
					not { triggeredBy 'UpstreamCause' }
				}
			}
			agent {
				docker {
					image 'adoptopenjdk/openjdk8:latest'
					label 'data'
					args '-v $HOME:/tmp/jenkins-home'
				}
			}
			options { timeout(time: 30, unit: 'MINUTES') }
			steps {
				sh 'MAVEN_OPTS="-Duser.name=jenkins -Duser.home=/tmp/jenkins-home" ./mvnw clean dependency:list verify -Dsort -B'
			}
		}

		stage("Test other configurations") {
			parallel {
				stage("test: baseline (jdk11)") {
					when {
						anyOf {
							branch 'master'
							not { triggeredBy 'UpstreamCause' }
						}
					}
					agent {
						docker {
							image 'adoptopenjdk/openjdk11:latest'
							label 'data'
							args '-v $HOME:/tmp/jenkins-home'
						}
					}
					options { timeout(time: 30, unit: 'MINUTES') }
					steps {
						sh 'MAVEN_OPTS="-Duser.name=jenkins -Duser.home=/tmp/jenkins-home" ./mvnw -Pjava11 clean dependency:list verify -Dsort -B'
					}
				}

				stage("test: baseline (jdk13)") {
					when {
						anyOf {
							branch 'master'
							not { triggeredBy 'UpstreamCause' }
						}
					}
					agent {
						docker {
							image 'adoptopenjdk/openjdk13:latest'
							label 'data'
							args '-v $HOME:/tmp/jenkins-home'
						}
					}
					options { timeout(time: 30, unit: 'MINUTES') }
					steps {
						sh 'MAVEN_OPTS="-Duser.name=jenkins -Duser.home=/tmp/jenkins-home" ./mvnw -Pjava11 clean dependency:list verify -Dsort -B'
					}
				}
			}
		}

		stage('Build project & BOM then release to artifactory') {
			when {
				anyOf {
					branch 'master'
					not { triggeredBy 'UpstreamCause' }
				}
			}
			agent {
				docker {
					image 'adoptopenjdk/openjdk8:latest'
					label 'data'
					args '-v $HOME:/tmp/jenkins-home'
				}
			}
			options { timeout(time: 20, unit: 'MINUTES') }

			environment {
				ARTIFACTORY = credentials('02bd1690-b54f-4c9f-819d-a77cb7a9822c')
			}

			steps {
				sh 'MAVEN_OPTS="-Duser.name=jenkins -Duser.home=/tmp/jenkins-home" ./mvnw -Pci,artifactory ' +
						'-Dartifactory.server=https://repo.spring.io ' +
						"-Dartifactory.username=${ARTIFACTORY_USR} " +
						"-Dartifactory.password=${ARTIFACTORY_PSW} " +
						"-Dartifactory.staging-repository=libs-snapshot-local " +
						"-Dartifactory.build-name=spring-data-build-without-bom " +
						"-Dartifactory.build-number=${BUILD_NUMBER} " +
						'-Dmaven.test.skip=true clean dependency:tree source:jar javadoc:javadoc javadoc:jar deploy -pl "!bom" -B -U'

				sh 'MAVEN_OPTS="-Duser.name=jenkins -Duser.home=/tmp/jenkins-home" ./mvnw -Pwith-bom-client verify -pl bom,bom-client -B -U'
				
				sh 'MAVEN_OPTS="-Duser.name=jenkins -Duser.home=/tmp/jenkins-home" ./mvnw -Pci,artifactory ' +
						'-Dartifactory.server=https://repo.spring.io ' +
						"-Dartifactory.username=${ARTIFACTORY_USR} " +
						"-Dartifactory.password=${ARTIFACTORY_PSW} " +
						"-Dartifactory.staging-repository=libs-snapshot-local " +
						"-Dartifactory.build-name=spring-data-build-bom " +
						"-Dartifactory.build-number=${BUILD_NUMBER} " +
						'-Dmaven.test.skip=true clean deploy -pl bom -B -U'
			}
		}
	}

	post {
		changed {
			script {
				slackSend(
						color: (currentBuild.currentResult == 'SUCCESS') ? 'good' : 'danger',
						channel: '#spring-data-dev',
						message: "${currentBuild.fullDisplayName} - `${currentBuild.currentResult}`\n${env.BUILD_URL}")
				emailext(
						subject: "[${currentBuild.fullDisplayName}] ${currentBuild.currentResult}",
						mimeType: 'text/html',
						recipientProviders: [[$class: 'CulpritsRecipientProvider'], [$class: 'RequesterRecipientProvider']],
						body: "<a href=\"${env.BUILD_URL}\">${currentBuild.fullDisplayName} is reported as ${currentBuild.currentResult}</a>")
			}
		}
	}
}
