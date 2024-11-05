#include "MicroBit.h"

MicroBit uBit;

// Do something on button A being pressed.
void onButtonA(MicroBitEvent) {
    //
    int heading = uBit.compass.heading();
    if (heading == DEVICE_CALIBRATION_IN_PROGRESS)
        return;

    uBit.display.scroll(heading);
}

int main() {
    uBit.init();
    uBit.messageBus.listen(
        MICROBIT_ID_BUTTON_A, MICROBIT_BUTTON_EVT_CLICK, onButtonA
    );

    release_fiber();
}
