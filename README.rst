************
PyV4L2Camera
************
A simple, libv4l2-based frames capture library.

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
PyV4L2
++++++
To install PyV4L2Camera make sure you have Cython installed and type:

.. code-block:: bash

    $ pip install PyV4L2Camera

PyV4L2Camera is only compatible with Python 3.

=====
Usage
=====
.. code-block:: python

    from PyV4L2Camera.camera import Camera

    camera = Camera('/dev/video0')
    frame = camera.get_frame()

The returned frame is of bytes type and contains pixels packed using RGB24
format. To learn more see `V4L2_PIX_FMT_RGB24 description
<https://linuxtv.org/downloads/v4l-dvb-apis/packed-rgb.html>`_.

Example of frames to numpy arrays conversion can be found in the examples
directory.

=============
Contributions
=============
Contributions are always welcome!

=======
Authors
=======
`Dominik Pieczyński <https://gitlab.com/u/rivi>`_ and `contributors
<https://gitlab.com/radish/PyV4L2Camera/graphs/master/contributors>`_.
