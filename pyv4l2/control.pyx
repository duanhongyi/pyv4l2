from v4l2 cimport *
from libc.errno cimport errno, EINVAL
from libc.string cimport memset
from typing import Any, List
from posix.fcntl cimport O_RDWR

from .exceptions import CameraError


cdef class Control:

    cdef int fd

    def __cinit__(self, device_path):
        device_path = device_path.encode()

        self.fd = v4l2_open(device_path, O_RDWR)
        if -1 == self.fd:
            raise CameraError('Error opening device {}'.format(device_path))

    cdef enumerate_menu(self, v4l2_queryctrl queryctrl):
        cdef v4l2_querymenu querymenu
        querymenu.id = queryctrl.id
        querymenu.index = queryctrl.minimum
        menu = {}
        while querymenu.index <= queryctrl.maximum:
            if 0 == xioctl(self.fd, VIDIOC_QUERYMENU, & querymenu):
                menu[querymenu.name] = querymenu.index
            querymenu.index += 1
        return menu

    def get_controls(self):
        cdef v4l2_queryctrl queryctrl
        queryctrl.id = V4L2_CTRL_CLASS_USER | V4L2_CTRL_FLAG_NEXT_CTRL
        controls = []
        control_type = {
            V4L2_CTRL_TYPE_INTEGER: 'int',
            V4L2_CTRL_TYPE_BOOLEAN: 'bool',
            V4L2_CTRL_TYPE_MENU: 'menu'
        }
 
        while (0 == xioctl(self.fd, VIDIOC_QUERYCTRL, & queryctrl)):
            control = {}  
            control['name'] = queryctrl.name
            control['type'] = control_type[queryctrl.type]
            control['id'] = queryctrl.id
            control['min'] = queryctrl.minimum
            control['max'] = queryctrl.maximum
            control['step'] = queryctrl.step
            control['default'] = queryctrl.default_value
            control['value'] = self.get_control_value(queryctrl.id)
            if queryctrl.flags & V4L2_CTRL_FLAG_DISABLED:
                control['disabled'] = True
            else:
                control['disabled'] = False
 
                if queryctrl.type == V4L2_CTRL_TYPE_MENU:
                    control['menu'] = self.enumerate_menu(queryctrl)
 
            controls.append(control)
 
            queryctrl.id |= V4L2_CTRL_FLAG_NEXT_CTRL
 
        if errno != EINVAL:
            raise CameraError('Querying controls failed')
        return controls

    cpdef void set_control_value(self, control_id, value):
        cdef v4l2_queryctrl queryctrl
        cdef v4l2_control control

        memset(&queryctrl, 0, sizeof(queryctrl))
        queryctrl.id = control_id

        if -1 == xioctl(self.fd, VIDIOC_QUERYCTRL, &queryctrl):
            if errno != EINVAL:
                raise CameraError('Querying control')
            else:
                raise AttributeError('Control is not supported')
        elif queryctrl.flags & V4L2_CTRL_FLAG_DISABLED:
            raise AttributeError('Control is not supported')
        else:
            memset(&control, 0, sizeof(control))
            control.id = control_id
            control.value = value

            if -1 == xioctl(self.fd, VIDIOC_S_CTRL, &control):
                raise CameraError('Setting control')

    cpdef int get_control_value(self, control_id):
        cdef v4l2_queryctrl queryctrl
        cdef v4l2_control control

        memset(&queryctrl, 0, sizeof(queryctrl))
        queryctrl.id = control_id

        if -1 == xioctl(self.fd, VIDIOC_QUERYCTRL, &queryctrl):
            if errno != EINVAL:
                raise CameraError('Querying control')
            else:
                raise AttributeError('Control is not supported')
        elif queryctrl.flags & V4L2_CTRL_FLAG_DISABLED:
            raise AttributeError('Control is not supported')
        else:
            memset(&control, 0, sizeof(control))
            control.id = control_id

            if 0 == xioctl(self.fd, VIDIOC_G_CTRL, &control):
                return control.value
            else:
                raise CameraError('Getting control')

    def close(self):
        v4l2_close(self.fd)
