import QtQuick
import QtTest
import "../../music_player_desktop/components"

TestCase {
    name: "SingleSurfaceControls"
    when: windowShown
    visible: true
    width: 400; height: 200
    Component { id: mock; Item {
        property Item target
        property var buttons: []
        property bool active: false
    } }
    Row {
        id: normal
        property int layoutRevision: 0
        onPositioningComplete: layoutRevision++
        spacing: 10
        Rectangle { property string action: "maximize"; width: 22; height: 32 }
        Rectangle { property string action: "minimize"; width: 22; height: 32 }
        Rectangle { property string action: "close"; width: 22; height: 32 }
    }
    Row {
        id: player
        property int layoutRevision: 0
        onPositioningComplete: layoutRevision++
        spacing: 12
        Rectangle { property string action: "maximize"; width: 22; height: 32 }
        Rectangle { property string action: "close"; width: 22; height: 32 }
    }
    CooperativeWindowControls { id: slot; controlGroup: normal; platformComponent: mock }
    function test_one_slot_tracks_headers() {
        tryVerify(() => slot.platformReady)
        const protocol = slot.platformSlot
        compare(protocol.target, normal)
        compare(protocol.buttons.length, 3)
        compare(protocol.buttons[0].x, 2)
        compare(protocol.buttons[1].x, 34)
        protocol.active = true
        compare(slot.compositorActive, true)
        slot.controlGroup = player
        compare(slot.platformSlot, protocol)
        compare(protocol.target, player)
        compare(protocol.buttons.length, 2)
        compare(protocol.buttons[1].action, "close")
        compare(protocol.buttons[1].x, 36)
        slot.controlGroup = null
        compare(protocol.enabled, false)
        compare(protocol.buttons.length, 0)
        slot.controlGroup = normal
        compare(protocol.enabled, true)
        slot.platformComponent = null
        compare(slot.compositorActive, false)
    }
}
