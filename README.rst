************
pyv4l2
************
A simple, libv4l2-based frames capture library.
The `pyv4l2` module based PyV4L2Camera development,
I removed the v4lconvert_convert part of the code, the most original data to return the device.
PyV4L2Camera module in `https://gitlab.com/radish/PyV4L2Camera` ,Thank you `Dominik Pieczyński`.

============
Installation
============
+++++++
Libv4l2
+++++++
Libv4l2 is packaged by various distributions:

-----------------
Debian and Ubuntu
-----------------
.. code-block:: bash

    # apt-get install libv4l-dev

------
Fedora
------
.. code-block:: bash

    # dnf install libv4l-devel

----------
Arch Linux
----------
.. code-block:: bash

    # pacman -S v4l-utils

++++++
pyv4l2
++++++
To install pyv4l2:

.. code-block:: bash

    $ pip install pyv4l2

pyv4l2 is only compatible with Python 3.

=====
Usage
=====
.. code-block:: python

    from pyv4l2.camera import Camera

    camera = Camera('/dev/video0')
    frame = camera.get_frame()
