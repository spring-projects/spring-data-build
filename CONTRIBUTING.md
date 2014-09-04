# Spring Data contribution guidelines

## Quickstart

For the impatient, if you want to submit a quick pull request:

- Make sure there is a ticket in the bug tracker for the project in our [JIRA](https://jira.springsource.org).
- Make sure you use the code formatters provided [here](https://github.com/spring-projects/spring-data-build/tree/master/etc/ide) and have them applied to your changes. Don't submit any formatting related changes.
- Make sure you submit test cases (unit or integration tests) that back your changes.
- Try to reuse existing test sample code (domain classes). Try not to amend existing test cases but create new ones dedicated to the changes you're making to the codebase. Try to test as locally as possible but potentially also add integration tests.
- In the Javadoc for the newly added test cases refer to the ticket the changes apply to like this

```java
/**
 * @see DATA…-???
 */
@Test
public void yourTestMethod() { … }
```

- Make sure you added yourself as author in the headers of the classes you touched. Amend the date range in the Apache license header if needed. For new types, add the license header (copy from another file and set the current year only).
- The commit message should follow the following style:
    - First line starts with the ticket id.
    - Separate ticket id and summary with a dash.
    - Finish summary with a dot.
    - In the description, don't use single line breaks. No manual wrapping. Separate paragraphs by a blank line.
    - Add related references at the very bottom (also see the section on pull requests below).

```
DATA…-??? - Summary of the commit (try to stay under 80 characters).

Additional explanations if necessary.

See also: DATA…-???. (optionally refer to related tickets)
```

- Make sure you provide your full name and an email address registered with your GitHub account. If you're a first-time submitter, make sure you have completed the [Contributor's License Agreement form](https://support.springsource.com/spring_committer_signup).

# Advanced

This section contains some advanced information, mainly targeted at developers of the individual projects.

## General

- Fix bugs in master first, if it's reasonable to port the fix back into a bugfix branch, try to do so with cherry picking.
- Try to keep the lifespan of a feature branch as short as possible. For simple bug fixes they should only be used for code review in pull requests.
- On longer running feature branches, don't pull changes that were made to master in the meantime. Instead, rebase the feature branch onto current master, sorting out issues and making sure the branch will fast-forward merge eventually.

## Change tracking

- Make sure you don't commit without referring to a ticket. If we have a rather general task to work on, create a ticket for it and commit against that one.
- Try to resolve a ticket in a single commit. I.e. don't have separate commits for the fix and the test cases. When polishing pull requests requires some more effort, have a separate commit to clearly document the polishing (and attribute the efforts to you).
- We usually use feature branches to work on tickets and potentially let multiple people work on a feature. There's a [new-issue-branch script](https://github.com/spring-projects/spring-data-build/tree/master/etc/scripts) available that sets up a feature branch for you, and adds a commit changing the Maven version numbers so that the branch builds can still publish snapshot artifacts but don't interfere with each other.
- Follow the commit message style described in [quickstart]. Especially the summary line should adhere to the style documented there.
- After pushing fixes to the remote repository, mark the tickets as resolved in JIRA and set the fixed versions according to which branches you pushed to.
- Avoid merge commits as they just tend to make it hard to understand what comes from where. Using the ticket identifier in the summary line will allow us to keep track fo commits belonging together.

## Code style

This section contains some stuff that the IDE formatters do not enforce. Try to keep track of those as well

- Make sure, your IDE uses `.*` imports for all static ones.
- Eclipse users should activate Save Actions to format sources on save, organize imports and also enable the standard set of
- For methods only consisting of a single line, don't use any blank lines around the line of code. For methods consisting of more than one line of code, have a blank line after the method signature.

## Handling pull requests

- Be polite. It might be the first time someone contributes to an OpenSource project so we should forgive violations to the contribution guidelines. Use some gut feeling to find out in how far it makes sense to ask the reporter to fix stuff or just go ahead and add a polishing commit yourself.
- If you decide to merge stuff back make sure that all the infrastructure requirements are met (set up a JIRA ticket to commit against if necessary, etc.).
- Before merging stuff back into master, make sure you rebase the branch. We generally do not allow merge commits, so a merge should always be fast-forward. The ticket IDs and the timestamps give enough tracking information already.
- The simplest way to merge back a pull request submitted by someone external is `curl`ing the patch into `git am`. You can then polish it by either adding a commit or amending the provided commit. Make sure you keep the original author when amending.

```
curl $PULL_REQUEST_URL.patch | git am --ignore-whitespace
```

- If the you merge back a feature branch and multiple developers contributed to that, try to rearrange to commits and squash the into a single commit per developer. Combine the commit messages and edit them to make sense.
- Before pushing the changes to the remote repository, amend the commit(s) to be pushed and add a reference to the pull request to them. This will cause the pull request UI in GitHub show and link those commits.

```
…

Original pull request: #??.
```

Important pieces here: colon and the sence completed with a dot.
