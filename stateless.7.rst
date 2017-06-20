=========
stateless
=========

---------------------------------------------------------------------------
A guide to stateless configuration in Clear Linux OS for Intel Architecture
---------------------------------------------------------------------------

:Copyright: \(C) 2017 Intel Corporation, CC-BY-SA-3.0
:Manual section: 7


SYNOPSIS
========

``/etc/``

``/usr/share/defaults/``

``/usr/share/defaults/etc/``

``/var/``

``/var/cache/``

DESCRIPTION
===========

The Clear Linux OS for Intel Architecture has a unique way of
providing customization and configuration to system administrators and
users. This man page aims to provide both an explanation of what this
method is and how users of Clear Linux can use it and benefit from it.

The goal of "stateless" is to provide a system OS that functions
without user configuration. A system should not require editing of
configuration files by the end user before it is functional, nor should
it place lengthy and confusing configuration files automatically in
user-maintained file system areas (``/etc/``) by default. And
additionally, any configuration placed in user-maintained configuration
should be removable without breaking functionality.

This is achieved by several methods, each of which implements a part
of the stateless goal.


* Removal of configuration files

The first step taken to achieve stateless configuration is to embed
proper default configuration values in the software. Any missing
critical configuration value should have a built-in default value.

* Providing of default configuration files outside of ``/etc/``

Software is adjusted to use a distribution provided default
configuration file in ``/usr/share/defaults``. If no configuration
file exists in ``/etc/`` for the software, the software must use the
distribution default configuration file.

* Allowing the end user to provide configuration in ``/etc/``

If the user provides a properly formatted configuration file in
the ``/etc/`` filesystem area (or, wherever it is relevant for the
software), the software is instructed to use this configuration
file instead of any other.


Consequences for the system administrator (user)
------------------------------------------------

The user should create configuration files as needed and avoid
modifying distribution provided defaults. The filesystem folders and
all content under ``/etc/`` and ``/var/`` may be modified as needed, but
the content under ``/usr/``, ``/lib/``, ``/lib64/``, ``/bin/``, ``/sbin/`` should
never be modified, and will be overwritten by ``swupd``\(1) as needed.

Some default configuration structure and data is automatically created
under ``/etc/`` and ``/var/``. The user may remove these file system
structures entirely - a reboot of the OS should properly restore the
system to it's factory default. This may also provide the user with
a way to repair and a defective system configuration.

The user should, if user configuration of a service is needed,
attempt to place the configuration file in the ``/etc/`` structure as
the service requests. Often, template files for the configuration
format can be found under the ``/usr/share/defaults/`` file structure,
and these files can be copied to the ``/etc/`` file structure.

To modify system service configuration (``systemd``\(1) service units),
the user should not touch or modify unit files under the ``/usr/``
file structure directly, as changes in those files will be lost after
a system software update with ``swupd``\(1).

A list of package specific hints and best practices is listed below. In 
many cases, the man pages for the respective packages also provides 
detailed information as to how to configure the software. Please 
consult the relevant manual pages for the software to find information
on the specific syntax and options for each software.


systemd
-------

    ``systemd``\(1)

Unit files can be created under ``/etc/systemd/system`` as needed and 
function normally. To override unit file options, the simplest method 
is to have ``systemctl``\(1) copy it for you by invoking it as:

    ``systemctl edit --full foo.service``

This creates an exact copy of the default unit file and invokes the
editor for the user, allowing the user to override any part of the unit.

Unit files can be started as normal with ``systemctl start <unit>``.

To enable services to start at boot time, use ``systemctl enable <unit>``.


sshd
----

    ``sshd``\(8)
    ``sshd_config``\(5)

The SSH daemon has all of its configuration built in and no template
configuration file is present on the file system. The man page for
``sshd_config``\(5) explains the format, and it suffices to put only a
single option in the file

   ``/etc/ssh/sshd_config``

For example, to enable X11 forwarding through sshd all one has to do is
add one line containing ``X11Forwarding yes``. Other often used options
include ``PermitRootLogin yes`` to allow root ssh login access, and the
following 3 lines to disable password authentication entirely:

    ``ChallengeResponseAuthentication no``

    ``PasswordAuthentication no``

    ``UsePAM no``

To modify the listening port of sshd, one needs to determine whether
``sshd.socket`` or ``sshd.service`` is enabled first, since the methods
for changing the port number depend on whether ``sshd``\(8) is controlling
the port number, or whether ``systemd``\(1) is:

    ``systemctl is-enabled sshd.socket``

If enabled, the ``sshd.socket`` unit should be edited to modify the port:

    ``systemctl edit --full sshd.socket``

And, the user should modify the port number at ``ListenStream=`` to the
desired new port number.

If ``sshd.service`` is enabled, the user should create, and edit a new
``/etc/ssh/sshd_config`` file:

    ``mkdir -p /etc/ssh/``
    ``vi /etc/ssh/sshd_config``

And add a line in that file that reads:

    ``Port 10022``
    
to, for instance, change the port number sshd.service will listen on
to port 10022.

Root login over SSH is disabled by default and should remain disabled
for most systemd. However, in some cases this is acceptable and it can
be easily enabled by adding the following line to ``/etc/ssh/sshd_config``
that reads:

    ``PermitRootLogin yes``


nginx
-----

Nginx ships by default in a non-functional configuration. However,
an example configuration file is present that can be used to enable
a simple server. To use this template configuration, create:

    ``mkdir -p /etc/nginx/conf.d``

And then copy configuration templates over to this folder:

    ``cp /usr/share/nginx/conf/nginx.conf.example /etc/nginx/nginx.conf``
    ``cp /usr/share/nginx/conf/server.conf.example /etc/nginx/conf.d/server.conf``

Edit the file to assure options such as SSL and PHP are enabled in
the preferred method. In the default configuration, PHP is enabled
to run listening to ``/run/php-fpm.sock``. The template file has PHP
by default disabled, but the listed example lines can be uncommented
to make the nginx service process php documents.


php-fpm
-------

    ``php-fpm``\(8)

Php's default configuration file doesn't allow us to provide an 
alternative as it is programmed to only read the builtin file. If you 
wish to have php-fpm use a different configuration, you must pass it a 
startup option to tell it where it is. This can be done by ``systemctl 
edit --full php-fpm.service``. That command copies the default php-fpm 
service unit to ``/etc/systemd/system/`` and allows the user to override 
any option. It spawns an editor with the copy.

Then, the user should change the line:

    ``ExecStart=/usr/sbin/php-fpm --nodaemonize``

to:

    ``ExecStart=/usr/sbin/php-fpm --nodaemonize --fpm-config /etc/php-fpm.conf``

The template php-fpm.conf can be found at ``/usr/share/defaults/php/php-fpm.conf``.
One should copy this to a place in ``/etc/``:

    ``cp /usr/share/defaults/php/php-fpm.conf /etc/php-fpm.conf``

Then, the user should edit ``/etc/php-fpm.conf`` and assure that 
configuration options are all properly set as needed.

Care must be taken using the default ``pool`` configuration. If needed, 
the user should also create ``/etc/php-fpm.d/`` and include pool 
configuration files from either ``/usr/share/defaults/php/php-fpm.d/`` or 
copy them and modify them as needed as well, as well as adjust the 
``include`` configuration option in ``php-fpm.conf`` to point to a new 
location for pool configuration files.


SEE ALSO
========

* ``swupd``\(1)
* ``systemd``\(1)
* https://clearlinux.org/documentation/
* https://clearlinux.org/features/stateless
* https://github.com/clearlinux/swupd-client/
