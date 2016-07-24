from enum import Enum
from typing import Any, List

from v4l2 cimport (V4L2_CTRL_FLAG_DISABLED, V4L2_CTRL_FLAG_GRABBED,
                   V4L2_CTRL_FLAG_READ_ONLY, V4L2_CTRL_FLAG_UPDATE,
                   V4L2_CTRL_FLAG_INACTIVE, V4L2_CTRL_FLAG_WRITE_ONLY,
                   V4L2_CID_BRIGHTNESS, V4L2_CID_CONTRAST, V4L2_CID_SATURATION,
                   V4L2_CID_HUE, V4L2_CID_AUDIO_VOLUME, V4L2_CID_AUDIO_BALANCE,
                   V4L2_CID_AUDIO_BASS, V4L2_CID_AUDIO_TREBLE,
                   V4L2_CID_AUDIO_MUTE, V4L2_CID_AUDIO_LOUDNESS,
                   V4L2_CID_BLACK_LEVEL, V4L2_CID_AUTO_WHITE_BALANCE,
                   V4L2_CID_DO_WHITE_BALANCE, V4L2_CID_RED_BALANCE,
                   V4L2_CID_BLUE_BALANCE, V4L2_CID_GAMMA, V4L2_CID_WHITENESS,
                   V4L2_CID_EXPOSURE, V4L2_CID_AUTOGAIN, V4L2_CID_GAIN,
                   V4L2_CID_HFLIP, V4L2_CID_VFLIP,
                   V4L2_CID_POWER_LINE_FREQUENCY, V4L2_CID_HUE_AUTO,
                   V4L2_CID_WHITE_BALANCE_TEMPERATURE,
                   V4L2_CID_SHARPNESS, V4L2_CID_BACKLIGHT_COMPENSATION,
                   V4L2_CID_CHROMA_AGC, V4L2_CID_COLOR_KILLER, V4L2_CID_COLORFX)


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


class CameraControl:
    def __init__(self, id_: int, type_: int, name: str, default_value: Any,
                 minimum: int, maximum: int, step: int, menu: List[str],
                 flags: int):
        self.id = id_
        self.type = type_
        self.name = name
        self.default_value = default_value
        self.minimum = minimum
        self.maximum = maximum
        self.step = step
        self.menu = menu
        self._flags = flags

    @property
    def is_disabled(self) -> bool:
        """This control is permanently disabled and should be ignored
        by the application."""
        return self._flags & V4L2_CTRL_FLAG_DISABLED

    @property
    def is_grabbed(self) -> bool:
        """This control is temporarily unchangeable, for example because
        another application took over control of the respective resource."""
        return self._flags & V4L2_CTRL_FLAG_GRABBED

    @property
    def is_read_only(self) -> bool:
        """This control is permanently readable only."""
        return self._flags & V4L2_CTRL_FLAG_READ_ONLY

    @property
    def updates_others(self) -> bool:
        """A hint that changing this control may affect the value of other
        controls within the same control class."""
        return self._flags & V4L2_CTRL_FLAG_UPDATE

    @property
    def is_inactive(self) -> bool:
        """This control is not applicable to the current configuration and
        should be displayed accordingly in a user interface."""
        return self._flags & V4L2_CTRL_FLAG_INACTIVE

    @property
    def is_write_only(self) -> bool:
        """This control is permanently writable only. Any attempt to read the
         control will result in an EACCES error code error code."""
        return self._flags & V4L2_CTRL_FLAG_WRITE_ONLY
