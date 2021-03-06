=========
OS Format
=========

--------------------------------------
A summary of OS formats in Clear Linux
--------------------------------------

:Copyright: \(C) 2018 Intel Corporation, CC-BY-SA-3.0
:Manual section: 7


SYNOPSIS
========

``/usr/share/defaults/swupd/format``

DESCRIPTION
===========

A format defines a range of OS versions that have compatible update metadata and
content. An update client can update a system from the oldest version in the
format to the latest version in the format without worrying about compatibility
issues in the update content for the version it is updating to.

A format bump occurs when the update metadata or content is changed in such a
way that will cause client updates to break. In this case the format number must
be incremented so clients will not attempt to update to the new versions in the
new format without crossing the format boundary. Update clients update only to
the latest build in their format. Once that update is complete the update client
may then update forward again because the last version in the current format has
identical content to the first version in the new format, including the new
update client needed to understand the new format.

Because the update system in Clear Linux (``swupd``) has auto-update turned on
by default most users will never be aware of their system changing to a new
format. Those users who have disabled auto-update may occasionally see ``swupd``
perform two updates in a row when they only invoked ``swupd update`` once. This
is because ``swupd`` detects when it crossed a format boundary and immediately
re-executes an update to carry it to the latest version in the new format. This
re-execution will actually invoke the new version of ``swupd`` that was
delivered in the first update.

Format bumps are simply a way for Clear Linux to introduce breaking changes to
the OS without breaking user's update stream or workflow.


SEE ALSO
========

* ``mixer``\(1)
* ``swupd``\(1)
* https://clearlinux.org/documentation/
* https://github.com/clearlinux/swupd-client/
* https://github.com/clearlinux/mixer-tools/
