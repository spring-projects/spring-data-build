# Spring Data Build Infrastructure

This repository contains common infrastructure to be used by Spring Data modules that build with Maven. It consists of a *resources* project that bundles up resources that are needed during the build like XSLT stylesheets for reference documentation generation and the according CSS and images. The second project is *parent* that can be used as parent project to pre-configure core dependencies, properties, reference documentation generation and most important of all the appropriate distribution assembly.

The parent project can be eased for either a single-module Maven project or a multi-module one. Each of the setups requires a slightly different setup of the project.

## Project setup

### General setup

The parent project configures the following aspects of the project build:

Shared resources are pulled in from the `spring-data-build-resources` dependency (images, CSS, XSLTs for documentation generation). Renders reference documentation from Docbook file named `index.xml` within `src/docbkx`. In the `distribute` profile, two assemblies are generated: A ZIP to be uploaded to static.springsource.org (incl. javadoc (browsable), reference docs as described before) with the following content:

```
+ schemas -> containing all XSD namespace schemas
- changelog.txt
- license.txt
- notice.txt
- readme.txt
+ docs
  + reference -> Docbook generated reference documentation
  + html
  + htmlsingle
  + pdf
+ api -> JavaDoc
```

A second ZIP is generated to be uploaded to S3 to automatically make it into the downloads section on the Spring website. It contains the same content as listed above plus the following:

```
+ src -> Sources packaged into a JAR
+ dist -> Binary JARs
```
  
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
	<version>1.0.0.RELEASE</version>
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
	
As an example have a look at the build of [Spring Data JPA](http://github.com/SpringSource/spring-data-jpa).

### Multi project setup
	
A multi module setup requires slightly more setup and some structure being set up. 

- The root `pom.xml` needs to configure the `project.type` property to `multi`.
- Docbook documentation sources need to be in the root project.
- The assembly needs to be build in a dedicated sub-module (e.g. `distribution`), declare the assembly plugin (see single project setup) in that submodule and reconfigure the `project.root` property in that module to `${basedir}/..`.
- Configure `${dist.id}` in the root project to the basic artifact id (e.g. `spring-data-mongodb`) as this will serve as file name for distribution artifacts, static resources etc. It will default to the artifact id and thus usually resolve to a `…-parent` if not configured properly.

As an example have a look at the build of [Spring Data MongoDB](http://github.com/SpringSource/spring-data-mongodb).

## Build configuration

- Configure "Artifactory Maven 3" task
- Goals to execute `clean (dependency:tree) install -Pci`
- A nightly build can then use `clean (dependency:tree) deploy -Pdistribute` to publish static resources and reference documentation