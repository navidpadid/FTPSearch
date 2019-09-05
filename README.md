


Welcome to FTPSearch!

designed for Linux by Navid Malek and Tina Salehi
navidmalekedu@gmail.com
navidmalek.blog.ir

More info is [here!](http://navidmalek.blog.ir/1397/11/09/FTPSearch-purely-written-in-BASH) 

**Tested OS: Linux - Ubuntu 16.04 and 18.04 with default BASH shell**

	
       Simple search engine with REGEX support
       purely written in BASH

       Well according to RFC959 FTP does not support search meaning you have to find your desired files all by yourself.  As a computer programmer this is awful for us, so we have decided
       to implement a simple bash script program that is simply FTP client with search!

       FTPSearch = FTP IN TERMINAL + SEARCH SUPPORT

       There are ways that you can go on to be able to search in FTP as a file, therefore you must first make a shadow of FTP in your linux native filesystem. I will use curlftpfs inorder
       to mount the FTP in my /mnt/FTPSearch .
	
       after first run the program will be added to the /usr/bin applications and shell will recognize it from anywhere.
       also the man page will be added too.
usage ( first time ):

	git clone https://github.com/navidpadid/FTPSearch.git
        chmod 755 ./FTPSearch.sh
        ./FTPSearch.sh
	
usage ( second and later time ):

	FTPSearch

man page:

	man FTPSearch
