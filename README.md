## Overview

A webpage that curates Yale University resources, datasets owned or produced by affiliated groups, and commonly used datasets in public health or epidemiological research.

&nbsp;

![GitHub Repo stars](https://img.shields.io/github/stars/ysph-dsde/resources-page) ![GitHub watchers](https://img.shields.io/github/watchers/ysph-dsde/resources-page) ![GitHub forks](https://img.shields.io/github/forks/ysph-dsde/resources-page) [![License: CC BY-NC 4.0](https://img.shields.io/badge/License-CC%20BY--NC%204.0-lightgrey.svg)](http://creativecommons.org/licenses/by-nc/4.0/)

![GitHub Issues or Pull Requests](https://img.shields.io/github/issues/ysph-dsde/resources-page) ![GitHub Issues or Pull Requests](https://img.shields.io/github/issues-pr/ysph-dsde/resources-page) ![GitHub Release Date](https://img.shields.io/github/release-date/ysph-dsde/resources-page) ![GitHub repo size](https://img.shields.io/github/repo-size/ysph-dsde/resources-page)

![GitHub contributors](https://img.shields.io/github/contributors/ysph-dsde/resources-page) ![GitHub last commit](https://img.shields.io/github/last-commit/ysph-dsde/resources-page) ![GitHub commit activity](https://img.shields.io/github/commit-activity/w/ysph-dsde/resources-page) ![GitHub language count](https://img.shields.io/github/languages/count/ysph-dsde/resources-page) ![GitHub top language](https://img.shields.io/github/languages/top/ysph-dsde/resources-page)

## How to Publish Edits

Additional scripts were created to effectively render the site. Follow the procedure below to ensure smooth rendering and publishing.

1. Ensure all work is saved and committed.

    ```
    git add <file|.>
    git commit -m "Your message"
    git push
    ```

2. Render the site locally. The configuration updates the `_site` directory, which is excluded from version control by the `.gitignore` file. This process may take a few minutes to complete.

    ```
    quarto render
    ```

3. Make sure the shell script used for rendering the site is executable.

    ```
    chmod +x Code/copy_images.sh
    ```
  
4. Run the script.

    ```
    ./Code/copy_images.sh
    ```
    
5. (OPTIONAL): Verify that all the correct files have been rendered to the _site directory.
  
    ```
    ls -R _site
    ```

6. If everything looks correct, publish the site. Follow the prompts by entering "Yes" to proceed with updating the site and entering any required passwords when prompted.
     
    ```
    quarto publish gh-pages --no-render
    ```

Sometimes the webpage may fail to publish, but this is not necessarily a critical error. If you encounter this issue after attempting to publish, you will first need to clear any working trees generated during the incomplete process before retrying Step 6.

1. To retry publishing the site, you first need to clear any unfinished working trees that remain in the Git environment. For example, if the working tree is called `17fef8679f581e08/`:

    ```
    git status                                            # This should show the working tree that failed to complete.
    git worktree remove --force "17fef8679f581e08/"       # Remove it from the Git environment.
    ```

2. Retry publishing the site. Follow the prompts by entering "Yes" to proceed with updating the site and entering any required passwords when prompted.
     
    ```
    quarto publish gh-pages --no-render
    ```
