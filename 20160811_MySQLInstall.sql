rpm -Uvh --nodeps mysql-commercial-client-5.7.11-1.1.el6.x86_64.rpm
rpm -Uvh --nodeps mysql-commercial-common-5.7.11-1.1.el6.x86_64.rpm
rpm -Uvh --nodeps mysql-commercial-devel-5.7.11-1.1.el6.x86_64.rpm
rpm -Uvh --nodeps mysql-commercial-embedded-5.7.11-1.1.el6.x86_64.rpm
rpm -Uvh --nodeps mysql-commercial-embedded-devel-5.7.11-1.1.el6.x86_64.rpm
rpm -Uvh --nodeps mysql-commercial-libs-5.7.11-1.1.el6.x86_64.rpm
rpm -Uvh --nodeps mysql-commercial-libs-compat-5.7.11-1.1.el6.x86_64.rpm
rpm -Uvh --nodeps mysql-commercial-server-5.7.11-1.1.el6.x86_64.rpm
rpm -Uvh --nodeps mysql-commercial-test-5.7.11-1.1.el6.x86_64.rpm

[root@cepot V101040-01]# service mysqld status
mysqld is stopped
[root@cepot V101040-01]# service mysqld start
Initializing MySQL database:                               [  OK  ]
Installing validate password plugin:                       [  OK  ]
Starting mysqld:                                           [  OK  ]
[root@cepot V101040-01]# service mysqld status
mysqld (pid  3962) is running...
[root@cepot V101040-01]# mysql --version
mysql  Ver 14.14 Distrib 5.7.11, for Linux (x86_64) using  EditLine wrapper
[root@cepot V101040-01]# grep 'temporary password' /var/log/mysqld.log
2016-08-11T06:20:12.130189Z 1 [Note] A temporary password is generated for root@localhost: :%2>y)J!0TZ!
[root@cepot V101040-01]#

[orekel@cepot ~]$ mysql_secure_installation

Securing the MySQL server deployment.

Enter password for user root:

The existing password for the user account root has expired. Please set a new password.

New password:

Re-enter new password:
 ... Failed! Error: Unknown error 1819

New password:

Re-enter new password:
 ... Failed! Error: Unknown error 1819

New password: orekel.789

Re-enter new password: orekel.789
The 'validate_password' plugin is installed on the server.
The subsequent steps will run with the existing configuration
of the plugin.
Using existing password for root.

Estimated strength of the password: 100
Change the password for root ? ((Press y|Y for Yes, any other key for No) : y

New password:

Re-enter new password:

Estimated strength of the password: 100
Do you wish to continue with the password provided?(Press y|Y for Yes, any other key for No) : y
By default, a MySQL installation has an anonymous user,
allowing anyone to log into MySQL without having to have
a user account created for them. This is intended only for
testing, and to make the installation go a bit smoother.
You should remove them before moving into a production
environment.

Remove anonymous users? (Press y|Y for Yes, any other key for No) : y
Success.


Normally, root should only be allowed to connect from
'localhost'. This ensures that someone cannot guess at
the root password from the network.

Disallow root login remotely? (Press y|Y for Yes, any other key for No) : y
Success.

By default, MySQL comes with a database named 'test' that
anyone can access. This is also intended only for testing,
and should be removed before moving into a production
environment.


Remove test database and access to it? (Press y|Y for Yes, any other key for No) : n

 ... skipping.
Reloading the privilege tables will ensure that all changes
made so far will take effect immediately.

Reload privilege tables now? (Press y|Y for Yes, any other key for No) : y
Success.

All done!
[orekel@cepot ~]$