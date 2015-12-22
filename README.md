# Spring Data Build Infrastructure

This repository contains common infrastructure to be used by Spring Data modules that build with Maven. It consists of a *resources* project that bundles up resources that are needed during the build CSS for reference documentation generation and JavaDoc. The second project is *parent* that can be used as parent project to pre-configure core dependencies, properties, reference documentation generation and most important of all the appropriate distribution assembly.

The parent project can be eased for either a single-module Maven project or a multi-module one. Each of the setups requires a slightly different setup of the project.

## Project setup

### General setup

The parent project configures the following aspects of the project build:

Shared resources are pulled in from the `spring-data-build-resources` dependency (images, CSS, XSLTs for documentation generation). Renders reference documentation from Docbook file named `index.xml` within `src/docbkx`. In the `distribute` profile, two assemblies are generated: A ZIP to be uploaded to static.springsource.org (incl. javadoc (browsable), reference docs as described before) with the following content:

```
- changelog.txt
- license.txt
- notice.txt
- readme.txt
+ reference -> Docbook generated reference documentation
  + html
  + pdf
  + epub
+ api -> JavaDoc
```

A second ZIP is generated to be uploaded to static.springsource.org to contain all Spring namespace XSDs.
  
The following dependencies are pre-configured.
  
- Logging dependencies: SLF4j + Commons Logging bridge and Logback as test dependency
- Test dependencies: JUnit / Hamcrest / Mockito
- Dependency versions for commonly used dependencies

### Single project setup

If the client project is a project consisting of a single project only all that needs to be done is declaring the parent project:

```xml
<parent>
	<groupId>org.springframework.data.build</groupId>
	<artifactId>spring-data-parent</artifactId>
	<version>${most-recent-release-version}</version>
</parent>
```
    
Be sure to adapt the version number to the latest release version. The second and already last step of the setup is to activate the assembly and wagon plugin in the build section:

```xml
<plugin>
	<groupId>org.apache.maven.plugins</groupId>
	<artifactId>maven-assembly-plugin</artifactId>
</plugin>
<plugin>
	<groupId>org.codehaus.mojo</groupId>
	<artifactId>wagon-maven-plugin</artifactId>
</plugin>
```
	
As an example have a look at the build of [Spring Data JPA](http://github.com/spring-projects/spring-data-jpa).

### Multi project setup
	
A multi module setup requires slightly more setup and some structure being set up. 

- The root `pom.xml` needs to configure the `project.type` property to `multi`.
- Docbook documentation sources need to be in the root project.
- The assembly needs to be build in a dedicated sub-module (e.g. `distribution`), declare the assembly plugin (see single project setup) in that submodule and reconfigure the `project.root` property in that module to `${basedir}/..`.
- Configure `${dist.id}` in the root project to the basic artifact id (e.g. `spring-data-mongodb`) as this will serve as file name for distribution artifacts, static resources etc. It will default to the artifact id and thus usually resolve to a `…-parent` if not configured properly.

As an example have a look at the build of [Spring Data MongoDB](http://github.com/spring-projects/spring-data-mongodb).

## Build configuration

- Configure "Artifactory Maven 3" task
- Goals to execute `clean (dependency:tree) install -Pci`
- A nightly build can then use `clean (dependency:tree) deploy -Pdistribute` to publish static resources and reference documentation

## Additional build profiles

- `ci` - Packages the JavaDoc as JAR for distribution (needs to be active on the CI server to make sure we distribute JavaDoc as JAR).
- `distribute` - Creates Docbook documentation, assembles the distribution zip, etc.
- `milestone` - Configures the binary distribution to upload to the milestone S3 repository.
- `release` - Configures the binary distribution to upload to the release S3 repository.
- `spring4-next` - Configures the Spring version to be used to be the next 4.0.x snapshot version.
- `spring41` - Configures the Spring version to be used to be the latest 4.1.x release version.
- `spring41-next` - Configures the Spring version to be used to be the next 4.1.x release version.
- `querydsl-next` - Configures the Querydsl version to be used to be the next available snapshot version.