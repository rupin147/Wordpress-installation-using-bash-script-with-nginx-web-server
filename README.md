
---------------------------------------------------------------------------------------------------------------------------
SCRIPT1:-Wordpress-installation-using-bash-script-with-nginx-web-server.bash
This script will help you out in installing and configuring the wordpress on any debian OS with nginx web server.

Assumption before Running the sript:-
  
  - Instance has internet connection.
  - It doesn't fails to update the source List
  - User should run the script using super user(root).
  - make sure that there is no problem with downloading the wordpress file.
  - There are user input popup wile running the script.
  - Default password of database for new user other then root user is test123.
  - Error logs and setup logs are generated in /tmp.

After successfully execution of script,you can also access using  http://<internal ip address>/wp-admin/install.php 
if access from remote host.

check out for the screenshot - wiki
link - https://github.com/rupin147/Wordpress-installation-using-bash-script-with-nginx-web-server/wiki
--------------------------------------------------------------------------------------------------------------------------
SCRIPT2:- Commandline.bash
Simple Script To ADD Wordpress Details From Backend 

      	options
		--post
		--post <add> title content 
		--post <search> Keyword
		--post list
		
		--category
		--category list
		--category add
		--category assign <post-id> <cat-id>

---------------------------------------------------------------------------------------------------------------------------
