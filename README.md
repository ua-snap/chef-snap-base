# SNAP Base Cookbook

## Download ChefDK

If you don't already have ChefDK installed on your computer, go to: https://downloads.chef.io/tools/chefdk

Install ChefDK for your OS and you will receive tools such as Berkshelf and knife.

## Request access to Chef server

In your browser, go to https://chef.io.alaska.edu/ and sign in with your UA username and password.

At that point, you will be added to the Chef server's database and contact rltorgerson@alaska.edu to be added to the UAF SNAP Chef organization.

You will want to download your Starter Kit from the Chef server and from the downloaded directory, move the directory .chef into your $HOME directory.

## Updating the Cookbook version on the Chef server

In the file metadata.rb, update the version number.

Then run:

berks install
berks upload
