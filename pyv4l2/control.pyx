from v4l2 cimport *
from libc.errno cimport errno, EINVAL
from libc.string cimport memset
from posix.fcntl cimport O_RDWR

from .exceptions import CameraError


from enum import Enum

class ControlIDs(Enum):
    BRIGHTNESS = V4L2_CID_BRIGHTNESS
    CONTRAST = V4L2_CID_CONTRAST
    SATURATION = V4L2_CID_SATURATION
    HUE = V4L2_CID_HUE
    AUDIO_VOLUME = V4L2_CID_AUDIO_VOLUME
    AUDIO_BALANCE = V4L2_CID_AUDIO_BALANCE
    AUDIO_BASS = V4L2_CID_AUDIO_BASS
    AUDIO_TREBLE = V4L2_CID_AUDIO_TREBLE
    AUDIO_MUTE = V4L2_CID_AUDIO_MUTE
    AUDIO_LOUDNESS = V4L2_CID_AUDIO_LOUDNESS
    BLACK_LEVEL = V4L2_CID_BLACK_LEVEL
    AUTO_WHITE_BALANCE = V4L2_CID_AUTO_WHITE_BALANCE
    DO_WHITE_BALANCE = V4L2_CID_DO_WHITE_BALANCE
    RED_BALANCE = V4L2_CID_RED_BALANCE
    BLUE_BALANCE = V4L2_CID_BLUE_BALANCE
    GAMMA = V4L2_CID_GAMMA
    WHITENESS = V4L2_CID_WHITENESS
    EXPOSURE = V4L2_CID_EXPOSURE
    AUTOGAIN = V4L2_CID_AUTOGAIN
    GAIN = V4L2_CID_GAIN
    HFLIP = V4L2_CID_HFLIP
    VFLIP = V4L2_CID_VFLIP
    POWER_LINE_FREQUENCY = V4L2_CID_POWER_LINE_FREQUENCY
    HUE_AUTO = V4L2_CID_HUE_AUTO
    WHITE_BALANCE_TEMPERATURE = V4L2_CID_WHITE_BALANCE_TEMPERATURE
    SHARPNESS = V4L2_CID_SHARPNESS
    BACKLIGHT_COMPENSATION = V4L2_CID_BACKLIGHT_COMPENSATION
    CHROMA_AGC = V4L2_CID_CHROMA_AGC
    COLOR_KILLER = V4L2_CID_COLOR_KILLER
    COLORFX = V4L2_CID_COLORFX


cdef class Control:
    cdef int fd

    def __cinit__(self, device_path):
        device_path = device_path.encode()

        self.fd = v4l2_open(device_path, O_RDWR)
        if -1 == self.fd:
            raise CameraError('Error opening device {}'.format(device_path))

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
