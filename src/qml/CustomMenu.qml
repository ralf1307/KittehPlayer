import QtQuick 2.11
import QtQuick.Controls 2.4

Menu {
    width: 300
    background: Rectangle {
        implicitWidth: parent.width
        implicitHeight: 10
        color: appearance.mainBackground
    }
    delegate: CustomMenuItem {
    }
}
