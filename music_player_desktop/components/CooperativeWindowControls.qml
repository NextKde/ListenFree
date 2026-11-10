import QtQuick

// One protocol object per native surface, shared by normal and player headers.
Item {
    id: root
    property Item controlGroup: null
    property Component platformComponent: Qt.createComponent("qrc:/listenfree/platform/NativeWindowControls.qml")
    property var platformSlot: null
    readonly property bool platformReady: platformSlot !== null
    readonly property bool compositorActive: platformReady && platformSlot.active
    readonly property var buttonLayout: {
        const revision = controlGroup ? controlGroup.layoutRevision : 0
        const result = []
        if (!controlGroup) return result
        for (const button of controlGroup.children) {
            if (button.action !== undefined && button.visible)
                result.push({action: button.action,
                    x: button.x + (button.width - 18) / 2,
                    y: button.y + (button.height - 18) / 2,
                    width: 18, height: 18})
        }
        return result
    }
    function connectPlatform() {
        if (platformSlot) { platformSlot.destroy(); platformSlot = null }
        if (platformComponent && platformComponent.status === Component.Ready)
            platformSlot = platformComponent.createObject(root, {
                target: Qt.binding(() => root.controlGroup),
                buttons: Qt.binding(() => root.buttonLayout),
                enabled: Qt.binding(() => root.controlGroup !== null)
            })
    }
    onPlatformComponentChanged: connectPlatform()
    Component.onCompleted: connectPlatform()
    Connections {
        target: root.platformComponent
        function onStatusChanged() { root.connectPlatform() }
    }
}
