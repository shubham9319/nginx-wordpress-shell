# Mastering Infrastructure Automation: Nginx, LAMP Stack, and WordPress with GitHub Actions

Learn how to automate the deployment of Nginx on node1, followed by the setup of LAMP Stack and WordPress on node2 using GitHub Actions. This comprehensive guide walks you through configuring automated workflows for seamless infrastructure management.

### Prerequisites
Before you begin, ensure you have the following prerequisites in place:
1. GitHub Secrets:
    - sudo_pass: Password for sudo access on both nodes.
    - DB_PASS: Password for the database.
    - SERVER_NAME and SERVER_ALIAS: Server name and alias for WordPress setup.

2. Environment Variables (not secrets):
    - None required specifically for Nginx setup.
    - DB_NAME and DB_USER: Database name and user for WordPress setup.

3. GitHub Self-Hosted Runner:
    - To run these workflows, you need to have a GitHub self-hosted runner configured on both node1 and node2. This ensures that the workflows are executed on your specified servers. Follow the GitHub documentation to set up a self-hosted runner.

#

### Step-by-Step Guide to Trigger GitHub Actions Workflows

#### Step 1: Create Your Repository
1. Create a New Repository:
* Go to GitHub and create a new repository, or navigate to an existing one where you want to set up the workflows.

#### Step 2: Set Up GitHub Secrets
1. Navigate to Settings:
* Go to your repository on GitHub.
* Click on `Settings` at the top of the repository page.

2. Add Secrets:
* In the left sidebar, click on `Secrets and variables` and then `Actions`.
* Click on `New repository secret`.
* Add the following secrets:
  - `sudo_pass`: Password for sudo access on both nodes.
  - `DB_PASS`: Password for the database.
  - `SERVER_NAME`: Server name for WordPress setup.
  - `SERVER_ALIAS`: Server alias for WordPress setup.

#### Step 3: Set Up Environment Variables
1. Navigate to Settings:
* Go to your repository on GitHub.
* Click on Settings at the top of the repository page.

2. Add Variables:
* In the left sidebar, click on `Secrets and variables` and then `Actions`.
* Click on Variables and then `New repository variable`.
* Add the following variables:
  - `DB_NAME`: Database name for WordPress setup.
  - `DB_USER`: Database user for WordPress setup.

#### Step 4: Set Up GitHub Self-Hosted Runner
1. Navigate to Settings:
* Go to your repository on GitHub.
* Click on Settings at the top of the repository page.

2. Add a Runner:
* In the left sidebar, click on Actions and then Runners.
* Click on New self-hosted runner and follow the instructions to set up the runner on both node1 and node2.

#### Step 5: Create GitHub Actions Workflows
1. Create Workflow Files:
* In your repository, create a new directory called .github if it doesn’t exist.
* Inside the .github directory, create another directory called workflows.

2. Add Workflow Files:
* Create the following workflow files inside the .github/workflows directory:
  - install-nginx.yml
  - install-lamp.yml
  - install-wordpress.yml
  - uninstall-nginx.yml
  - uninstall-lamp.yml

#### Step 6: Push Workflow Files to GitHub
1. Push Changes:
* After creating the workflow files, push them to your repository’s main branch.
* Use the following commands in your terminal or command prompt:

```
git add .github/workflows/install-nginx.yml
git add .github/workflows/install-lamp.yml
git add .github/workflows/install-wordpress.yml
git commit -m "Add GitHub Actions workflows for Nginx, LAMP, and WordPress setup"
git push origin main
```
#### Step 7: Trigger the Workflows
1. Trigger the Installation Workflows:
* The `install-nginx.yml` workflow will trigger automatically when changes are pushed to the main branch.
* The `install-lamp.yml` and `install-wordpress.yml` workflows will trigger sequentially based on the completion of the previous workflows.

2. Trigger the Uninstallation Workflows:
* The `uninstall-nginx.yml` workflow will also trigger on a push to the main branch.
* The `uninstall-lamp.yml` workflow will trigger after the `uninstall-nginx.yml` workflow completes successfully.
#

### Part 1: Setting Up Nginx on Node1
In this section, we will automate the installation of Nginx on node1 using GitHub Actions.

* GitHub Actions Workflow: `install-nginx.yml`
```
name: Setup Nginx

on:
  push:
    branches:
      - main

jobs:
  setup-nginx:
    runs-on: [self-hosted, devops-dev]

    steps:
    - name: Checkout code
      uses: actions/checkout@v2

    - name: Set up Nginx
      env:
        SUDO_PASSWORD: ${{ secrets.sudo_pass }}
      run: |
        chmod +x ./scripts/install_nginx.sh
        echo "${SUDO_PASSWORD}" | sudo -S ./scripts/install_nginx.sh
```

### Explanation:

* This workflow triggers a push to the main branch.
* It checks out the repository and executes the install_nginx.sh script with sudo access provided via secrets.

#### Code Explanation:
* Name: Defines the name of the GitHub Actions workflow, which is "Setup Nginx".
* Trigger: This workflow triggers a push to the main branch.
* Jobs: Contains a single job setup-nginx that runs on self-hosted runners tagged as devops-dev.
* Steps:
  - Checkout code: Uses the actions/checkout@v2 action to fetch the repository's code into the runner.
  - Set up Nginx:
    - Defines SUDO_PASSWORD as an environment variable using ${{ secrets.sudo_pass }}.
    - Makes the install_nginx.sh script executable (chmod +x).
    - Executes install_nginx.sh with sudo access ( echo "${SUDO_PASSWORD}" | sudo -S ./scripts/install_nginx.sh ).
   
### Part 2: Setting Up LAMP Stack and WordPress on Node2
Now, we will automate the setup of LAMP Stack and WordPress on node2 after the successful installation of Nginx on node1.

* GitHub Actions Workflow: `install-lamp.yml`
```
name: Setup LAMP Stack on node2

on:
  workflow_run:
    workflows: ["Setup Nginx on node1"]
    types:
      - completed

jobs:
  setup-lamp:
    runs-on: [self-hosted, devops]

    steps:
    - name: Checkout code
      uses: actions/checkout@v2

    - name: Run LAMP setup script
      env:
        SUDO_PASSWORD: ${{ secrets.sudo_pass }}
      run: |
        chmod +x ./scripts/install_lamp.sh
        echo "${SUDO_PASSWORD}" | sudo -S ./scripts/install_lamp.sh
```

### Explanation:

* This workflow triggers when the "Setup Nginx on node1" workflow completes successfully.
* It checks out the repository and executes the install_lamp.sh script with sudo access provided via secrets.

#### Code Explanation:

* Name: Defines the name of the GitHub Actions workflow, which is "Setup LAMP Stack on node2".
* Trigger: This workflow triggers when the "Setup Nginx" workflow completes successfully.
* Jobs: Contains a single job setup-lamp that runs on self-hosted runners tagged as devops.
* Steps:
  - Checkout code: Checks out the repository code using actions/checkout@v2.
  - Run LAMP setup script:
    - Defines SUDO_PASSWORD as an environment variable using ${{ secrets.sudo_pass }}.
    - Makes the install_lamp.sh script executable (chmod +x).
    - Executes install_lamp.sh with sudo access ( echo "${SUDO_PASSWORD}" | sudo -S ./scripts/install_lamp.sh ).

* GitHub Actions Workflow: `install-wordpress.yml`
```
name: Setup WordPress on node2

on:
  workflow_run:
    workflows: ["Setup LAMP Stack on node2"]
    types:
      - completed

jobs:
  setup-wordpress:
    runs-on: [self-hosted, devops]

    steps:
    - name: Checkout code
      uses: actions/checkout@v2

    - name: Run WordPress setup script
      env:
        SUDO_PASSWORD: ${{ secrets.sudo_pass }}
        DB_NAME: ${{ secrets.DB_NAME }}
        DB_USER: ${{ secrets.DB_USER }}
        DB_PASS: ${{ secrets.DB_PASS }}
        SERVER_NAME: ${{ secrets.SERVER_NAME }}
        SERVER_ALIAS: ${{ secrets.SERVER_ALIAS }}
      run: |
        chmod +x ./scripts/install_wordpress.sh
        echo "${SUDO_PASSWORD}" | sudo -S ./scripts/install_wordpress.sh $DB_NAME $DB_USER $DB_PASS $SERVER_NAME $SERVER_ALIAS
```

### Explanation:

* This workflow triggers when the "Setup LAMP Stack on node2" workflow completes successfully.
* It checks out the repository and executes the install_wordpress.sh script, passing necessary environment variables for database and server configuration.

#### Code Explanation:
* Name: Defines the name of the GitHub Actions workflow, which is "Setup WordPress on node2".
* Trigger: This workflow triggers when the "Setup LAMP Stack on node2" workflow completes successfully.
* Jobs: Contains a single job setup-wordpress that runs on self-hosted runners tagged as devops.
* Steps:
  - Checkout code: Checks out the repository code using actions/checkout@v2.
  - Run WordPress setup script:
    - Defines SUDO_PASSWORD as an environment variable using ${{ secrets.sudo_pass }}.
    - Defines additional environment variables (DB_NAME, DB_USER, DB_PASS, SERVER_NAME, SERVER_ALIAS) from GitHub secrets.
    - Makes the install_wordpress.sh script executable (chmod +x).
    - Executes install_wordpress.sh, passing database and server configuration variables ( $DB_NAME $DB_USER $DB_PASS $SERVER_NAME $SERVER_ALIAS ) with sudo access ( echo "${SUDO_PASSWORD}" | sudo -S ./scripts/install_wordpress.sh $DB_NAME $DB_USER $DB_PASS $SERVER_NAME $SERVER_ALIAS ).

### Part 3: Remove Nginx on node1 and LAMP Stack and wordpress on node2.
Now, we will automate the setup of the uninstallation process to remove Nginx from node1 and uninstall the LAMP Stack and WordPress from node2. This automation streamlines the cleanup of web infrastructure, ensuring efficient and reliable management of server resources.

* GitHub Actions Workflow: `uninstall-nginx.yml`
```
name: Uninstall Nginx

on:
  push:
    branches:
      - main

jobs:
  uninstall-nginx:
    runs-on: [self-hosted, devops-dev]

    steps:
    - name: Checkout code
      uses: actions/checkout@v2

    - name: Uninstall Nginx
      env:
        SUDO_PASSWORD: ${{ secrets.sudo_pass }}
      run: |
        chmod +x ./scripts/uninstall_nginx.sh
        echo "${SUDO_PASSWORD}" | sudo -S ./scripts/uninstall_nginx.sh
```
### Explanation:
* This workflow automates the process of uninstalling Nginx from the specified server (devops-dev) when changes are pushed to the main branch.
* It ensures that the repository code is up-to-date and executes the uninstallation script securely with sudo privileges provided via GitHub Secrets.

#### Code Explanation:

* Name: Defines the name of the GitHub Actions workflow, which is "Uninstall Nginx".
* Trigger: This workflow also triggers on a push to the main branch.
* Jobs: Contains a single job uninstall-nginx that runs on self-hosted runners tagged as devops-dev.
* Steps:
  - Checkout code: Checks out the repository code using actions/checkout@v2.
  - Uninstall Nginx:
    - Defines SUDO_PASSWORD as an environment variable using ${{ secrets.sudo_pass }}.
    - Makes the uninstall_nginx.sh script executable (chmod +x).
    - Executes uninstall_nginx.sh with sudo access ( echo "${SUDO_PASSWORD}" | sudo -S ./scripts/uninstall_nginx.sh ).
   
* GitHub Actions Workflow: `uninstall-lamp.yml`
```
name: Uninstall LAMP Stack and WordPress on node2

on:
  workflow_run:
    workflows: ["Uninstall Nginx"]
    types:
      - completed

jobs:
  uninstall-lamp-wordpress:
    runs-on: [self-hosted, devops]

    steps:
    - name: Checkout code
      uses: actions/checkout@v2

    - name: Run LAMP and WordPress uninstall script
      env:
        SUDO_PASSWORD: ${{ secrets.sudo_pass }}
      run: |
        chmod +x ./scripts/uninstall_lamp.sh
        echo "${SUDO_PASSWORD}" | sudo -S ./scripts/uninstall_lamp.sh
```
### Explanation:
* This workflow automates the process of uninstalling the LAMP Stack and WordPress from node2 after the successful completion of uninstalling Nginx.
* It ensures that the repository code is up-to-date and executes the uninstallation script securely with sudo privileges provided via GitHub Secrets (secrets.sudo_pass).

#### Code Explanation:
* Name: Defines the name of the GitHub Actions workflow, which is "Uninstall LAMP Stack and WordPress on node2".
* Trigger: This workflow triggers when the "Uninstall Nginx" workflow completes successfully.
* Jobs: Contains a single job uninstall-lamp-wordpress that runs on self-hosted runners tagged as devops.
* Steps:
  - Checkout code: Uses the actions/checkout@v2 action to fetch the repository's code into the runner.
  - Run LAMP and WordPress uninstall script:
    - Defines SUDO_PASSWORD as an environment variable using ${{ secrets.sudo_pass }}.
    - Makes the uninstall_lamp.sh script executable (chmod +x).
    - Executes uninstall_lamp.sh with sudo access ( echo "${SUDO_PASSWORD}" | sudo -S ./scripts/uninstall_lamp.sh ).

## Conclusion

In this blog post, we explored how to automate the deployment of Nginx on node1 and subsequently set up LAMP Stack and WordPress on node2 using GitHub Actions workflows. This approach ensures a streamlined and efficient deployment process, leveraging automation for infrastructure management.

By following these steps, you can replicate and customize this setup for your own projects, enhancing reliability and reducing manual intervention in your deployment pipelines.

Additionally, we automated the uninstallation processes to remove Nginx from node1 and uninstall the LAMP Stack and WordPress from node2. These workflows ensure that server resources are efficiently managed and cleaned up when changes are made, maintaining the integrity and performance of your infrastructure.

Automating these processes not only simplifies deployment and maintenance but also strengthens your development workflow by ensuring consistent configurations and reducing the risk of human error.
