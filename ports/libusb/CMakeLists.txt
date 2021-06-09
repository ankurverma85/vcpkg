add_library(usb-1.0
    libusb/core.c 
    libusb/descriptor.c
    libusb/hotplug.c
    libusb/io.c
    libusb/sync.c
    libusb/strerror.c
    libusb/os/linux_usbfs.c
    libusb/os/events_posix.c
    libusb/os/threads_posix.c
)

target_include_directories(usb-1.0 PUBLIC libusb)
target_include_directories(usb-1.0 PUBLIC libusb/os)

if(LINUX)
    target_include_directories(usb-1.0 PUBLIC ${CMAKE_CURRENT_LIST_DIR})
    target_sources(usb-1.0 PRIVATE libusb/os/linux_udev.c)
    target_link_libraries(usb-1.0 PUBLIC udev)yy
endif()

if(ANDROID)
    target_include_directories(usb-1.0 PUBLIC android)
    target_sources(usb-1.0 PRIVATE libusb/os/linux_netlink.c)
endif()

install(TARGETS usb-1.0)
install(FILES libusb/libusb.h DESTINATION include/libusb-1.0)