#!/bin/bash
#Before running the scrpt,make sure that you have entered the database details properly
#---------------------DATABASE CONFIGURATION PART------------------------------------------
DBHOST=localhost
DBNAME=rupin_com_db
DBUSER=root
DBPASSWD=123
#------------------------------------------------------------------------------------------
title=$3
content=$4
`mysql -u $DBUSER -p$DBPASSWD -e "use $DBNAME" &> /dev/null `
if [ $? == 0 ]
then
DATE=`date +%Y-%m-%d\ %H:%M:%S`
#post_add_title_content=`mysql -h $DBHOST -u $DBUSER -p$DBPASSWD -D $DBNAME  -e  "insert into wp_posts  (post_date,post_date_gmt,post_title,post_content) values ('$DATE','$DATE','$3','$4');"`
post_list=`mysql -h $DBHOST -u $DBUSER -p$DBPASSWD -D $DBNAME  -e "select post_title,post_date from wp_posts"`
post_list_count=`mysql -h $DBHOST -u $DBUSER -p$DBPASSWD -D $DBNAME  -NB -e "select count(post_title) as POST_COUNT  from wp_posts"`
post_empty_delete=`mysql -h $DBHOST -u $DBUSER -p$DBPASSWD -D $DBNAME  -e "DELETE FROM wp_posts WHERE post_title = ''"`
set -- `getopt -o p,h -l post::,help,category::  -u -- "$@"`
query=`mysql -u root -p123 employees -Bs -e "select first_name from employees limit 10" 2> /dev/null`
arg4=`echo "$4" | tr '[a-z]' '[A-Z]'`
 Usage() {
  echo -e "\n\n"
  echo -e "\t\e[1;46mSimple Script To ADD Wordpress Details From Backend\e[0m"
  echo -e "\t\e[1;46mRecognized optional command line arguments\e[0m\n\n"
  echo -e "\t\e[1;45m$0 --help\e[0m"
  echo -e "\t\e[1;36moptions\e[0m"
  echo -e "\t\t\e[1;45m--post\e[0m"
  echo -e "\t\t\e[1;33m--post <add> "title" "content" \e[0m"
  echo -e "\t\t\e[1;33m--post <search "Keyword"\e[0m"
  echo -e "\t\t\e[1;33m--post list\e[0m"
  echo -e "\t\t\e[1;45m--category\e[0m"
  echo -e "\t\t\e[1;33m--category list\e[0m"
  echo -e "\t\t\e[1;33m--category add\e[0m"
  echo -e "\t\t\e[1;33m--category assign <post-id> <cat-id>\e[0m"
  echo  -e "\n"
  exit 1
}
while [ -n "$1" ]
do
case "$1" in
       --help) 
           Usage ;                 
           
            ;;
       --post)
              case "$3" in 
              search)
                     if [ -z "$4" ]
                      then
                      echo -e "\t\t--post search \"<keyword>\" "

                      exit 1
                      else
                       mysql -h $DBHOST -u $DBUSER -p$DBPASSWD -D $DBNAME  -e  "select post_title,post_content from wp_posts where post_title like '$4%' OR post_content like '$4%';"
                       exit 1
                       fi
                     ;;

              add)
                      if [ -z "$4" ] 
                      then                          
                      echo -e "\t\t--post add "\<\"title\"\>" "\<\"content\"\>" "
                      exit 1
                      else 
                        post_add_title_content=`mysql -h $DBHOST -u $DBUSER -p$DBPASSWD -D $DBNAME  -e  "insert into wp_posts  (post_date,post_date_gmt,post_title,post_content) values ('$DATE','$DATE','$title','$content');"`
                           $post_add_title_content
                           $post_empty_delete
                           if [ $? == 0 ]
                           then
                           {
                               echo -e "------------Successfully Added Post----------- \n" 
                               echo -e "Title   : $title\n"
                               echo -e "Content : $content\n"                           
                             exit
                           }
                           else
                           {
                             echo "can't added title"
                             exit 
                           }
                           fi
                       
                       fi
                      
                     ;;
                list)
                       echo -e "\t\tNumber of Posts:$post_list_count"
                       mysql -h $DBHOST -u $DBUSER -p$DBPASSWD -D $DBNAME  -e  "select ID,post_title as POST_LIST ,post_date from wp_posts"
                       exit
                     ;;
                 *)                     
                echo -e "\t\t--post <add> "title" "content" "
                echo -e "\t\t--post <search> "Keyword""
                echo -e "\t\t--post list"
               exit
                 ;;
               esac
                 ;; 
     --category)
           case "$3" in
              add)
                  if [ -z "$4" ]
                      then
                      echo -e "\t\t--category add  \<\"title\"\>" 
                      exit 1
                      else
                  arg1=$4
                  #cquery=`mysql -uroot -p123 -D rupin_com_db -NB -e  "SELECT   IF(COUNT(*) > 0, 'OK', 'Failed') as Status from wp_terms where name='$arg1';"`
                  mysql -h $DBHOST -u $DBUSER -p$DBPASSWD -D $DBNAME -e "insert into wp_terms (name) select * from (select '$4') as tmp where not exists (select name from wp_terms where name='$4');"
                  mysql -h $DBHOST -u $DBUSER -p$DBPASSWD -D $DBNAME -e "INSERT INTO wp_term_taxonomy (term_id,taxonomy) SELECT * FROM (SELECT (SELECT term_id from wp_terms where name='$4'),'category') AS TMP WHERE NOT EXISTS (SELECT term_id FROM wp_term_taxonomy where term_id=(SELECT term_id from wp_terms where name='$4'));"    
                  mysql -h $DBHOST -u $DBUSER -p$DBPASSWD -D $DBNAME -e "select term_id as Category_id ,name as Category_name from wp_terms where name='$4';"   
                  fi
                  exit
                  ;;
              list)
                   if [ -z "$4" ]
                      then
                  mysql -h $DBHOST -u $DBUSER -p$DBPASSWD -D $DBNAME -e "select term_id as Category_id ,name as Category_name from wp_terms;"
                      exit 1
                      else
                       echo "no arguments for listing"
                       echo -e "\t\t--category list"
                  exit
                   fi
                  ;;
              assign)
                if   [  -z "$4" ] && [ -z "$5" ]
                then
                   {
                      echo "please pass the argument"
                      echo -e "\t\t--category assign <post-id> <cat-id>"
                      exit
                    }
                else
                   {
                    if [ -z "$5" ]
                      then
                       {
                        echo "pass the argument for category_id"
                       echo -e "\t\t--category assign <post-id> <cat-id>"
                        exit 1
                        }
                        else
                        {
                        if [[ $4 =~ ^-?[0-9]+$ ]]  
                         then
                         { 
                          if [[ $5 =~ ^-?[0-9]+$ ]]                 
                          then
                          {
                          postmatch=`mysql -h $DBHOST -u $DBUSER -p$DBPASSWD -D $DBNAME -Bs -e "select count(ID) from wp_posts where ID=$4"`
                                    if [ $postmatch == 0 ] 
                                  then
                         {
                           echo "Not valid ID of any post! check using --post list"
                           echo -e "\t\t--category assign <post-id> <cat-id>"
                            exit
                        }
                       else
                       {
                       catmatch=`mysql -h $DBHOST -u $DBUSER -p$DBPASSWD -D $DBNAME -Bs -e "select count(term_id) from wp_terms where term_id=$5"`
                          if [ $catmatch == 0 ]
                           then
                          {
                            echo "Not valid ID of any category! check using --category list"
                            echo -e "\t\t--category assign <post-id> <cat-id>"
                            exit
                          }
                          else
                          {
                           mysql -h $DBHOST -u $DBUSER -p$DBPASSWD -D $DBNAME -Bs -e "insert into wp_term_relationships (object_id,term_taxonomy_id) values ($4,$5)"# &> /dev/null
                           if [ $? == 0 ]
                           then
                           {                              
                            
                           mysql -h $DBHOST -u $DBUSER -p$DBPASSWD -D $DBNAME -e "select object_id as Post_ID,term_taxonomy_id as Category_ID from wp_term_relationships where  object_id=$4 and term_taxonomy_id=$5"
                           mysql -h $DBHOST -u $DBUSER -p$DBPASSWD -D $DBNAME -e "update wp_term_taxonomy set count=count+1 where term_taxonomy_id=$5"
                           exit
                            }
                           else
                           {
                           mysql -h $DBHOST -u $DBUSER -p$DBPASSWD -D $DBNAME -e "select object_id as Post_ID,term_taxonomy_id as Category_ID from wp_term_relationships where  object_id=$4 and term_taxonomy_id=$5"      
                           exit       
                          }
 
                           fi   
                          }
                         fi
                       }
                    fi
                 }
                 else
                  {
                     echo "Category id Should be integer"
                     echo -e "\t\t--category assign <post-id> <cat-id>"
                     exit
                  }
                  fi
                  }
                 else
                   {
                       echo "post id should be integer"
                       echo -e "\t\t--category assign <post-id> <cat-id>"
                       exit
                   }
                  fi
                 }
                 fi
                 }
                fi
                  ;;
               *)
                 echo -e "\t\t--category list"
                 echo -e "\t\t--category add"
                 echo -e "\t\t--category assign <post-id> <cat-id>"
                 exit
                  ;;
              esac
                 ;;
     *) Usage ; exit ;;
        esac
done
else
echo -e "\e[1;31mPlease Configure the Database before you use the script\e[0m"
fi
