#!/bin/bash
#
# This script creates a new local issue branch for the given issue id.
# Previous changes are stashed before the issue branch is created and are reapplied after branch creation.
# 
# executing new-issue-branch.sh DATACMNS-42 
# will create a new (local) branch issue/DATACMNS-42

TICKET_ID=${1:?"TICKET_ID Parameter is missing!"}
OLD_VERSION_TMP=$(mvn -o org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate -Dexpression=project.version | grep -Ev '^\[.*')

OLD_POM_VERSION=${OLD_VERSION_TMP:?"Could not extract current project version from pom.xml"}

# Replaces BUILD in BUILD-SNAPSHOT with the given TICKET_ID
NEW_POM_VERSION=${OLD_POM_VERSION/"BUILD"/$TICKET_ID}
ISSUE_BRANCH="issue/$TICKET_ID"

echo "Creating feature branch $TICKET_ID: $OLD_POM_VERSION -> $NEW_POM_VERSION"

echo "Stashing potential intermediate changes..." && git stash\
&& git checkout -b $ISSUE_BRANCH\
&& mvn -o -q versions:set -DgenerateBackupPoms=false -DnewVersion=$NEW_POM_VERSION\
&& ( \
      (\
         git commit -am "$TICKET_ID - Prepare branch"\
         && echo "Created feature branch: $ISSUE_BRANCH"\
         && echo "Reapplying potentially stashed changes... " && git stash pop)\
  || echo "Something went wrong!")

