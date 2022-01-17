/*
 * Copyright 2012-2016 Canonical Ltd.
 *
 * This file is part of dialer-app.
 *
 * dialer-app is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * dialer-app is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.9
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3


Rectangle {
    id: root

    property bool enabled
    signal disable

    anchors.fill: parent
    color: "black"
    opacity: 0.0
    Behavior on opacity {
        UbuntuNumberAnimation {
            duration:  UbuntuAnimation.SlowDuration
        }
    }

    MessageDelegate {
        id: listItem

        property int xPos: 0

        animated: false
        onXPosChanged: listItem.updatePosition(xPos)

        anchors {
            top: parent.top
            topMargin: units.gu(14)
            left: parent.left
            right: parent.right
        }
        height: units.gu(10)

        color: Theme.palette.normal.background

        messageData: {
            "textMessage": i18n.tr("Welcome to your messaging app."),
            "timestamp": new Date(),
            "textMessageStatus": 1,
            "senderId": "self",
            "textReadTimestamp": new Date(),
            "textMessageAttachments": [],
            "newEvent": false,
            "accountId": "",
            "participants": ["111111111"],
            "accountLabel" : ""}

        incoming: true
        accountLabel: ""
        enabled: false


    }

    RowLayout {
        id: dragTitle

        anchors {
            left: parent.left
            right: parent.right
            top: listItem.bottom
            margins: units.gu(1)
            //topMargin: units.gu(3)
        }
        height: units.gu(3)
        spacing: units.gu(2)

        Image {
            visible: listItem.swipeState === "RightToLeft"
            source: Qt.resolvedUrl("./assets/swipe_arrow.svg")
            rotation: 180
            Layout.preferredWidth: sourceSize.width
            height: parent.height
            verticalAlignment: Image.AlignVCenter
            fillMode: Image.Pad
            sourceSize {
                width: units.gu(7)
                height: units.gu(2)
            }
        }

        Label {
            id: dragMessage

            Layout.fillWidth: true
            height: parent.height
            verticalAlignment: Image.AlignVCenter
            wrapMode: Text.Wrap
            fontSize: "large"
            color: "#ffffff"
        }

        Image {
            visible: listItem.swipeState === "LeftToRight"
            source: Qt.resolvedUrl("./assets/swipe_arrow.svg")
            Layout.preferredWidth: sourceSize.width
            height: parent.height
            verticalAlignment: Image.AlignVCenter
            fillMode: Image.Pad
            sourceSize {
                width: units.gu(7)
                height: units.gu(2)
            }
        }
    }

    Button {
        id: gotItButton
        objectName: "gotItButton"

        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
            bottomMargin: units.gu(9)
        }
        width: units.gu(17)
        strokeColor: theme.palette.normal.positive
        text: i18n.tr("Got it")
        enabled: !dismissAnimation.running
        onClicked: dismissAnimation.start()

        InverseMouseArea {
            anchors.fill: parent
            topmostItem: false
        }
    }

    SequentialAnimation {
        id: slideAnimation

        readonly property real leftToRightXpos: (-3 * (listItem.actionWidth + units.gu(2)))
        readonly property real rightToLeftXpos: listItem.leftActionWidth

        loops: Animation.Infinite
        running: root.enabled

        PauseAnimation {
            duration: UbuntuAnimation.SleepyDuration
        }

        PropertyAction {
            target: dragMessage
            property: "text"
            value: i18n.tr("Swipe to reveal actions")
        }

        PropertyAction {
            target: dragMessage
            property: "horizontalAlignment"
            value: Text.AlignLeft
        }

        ParallelAnimation {
            PropertyAnimation {
                target:  listItem
                property: "xPos"
                from: 0
                to: slideAnimation.leftToRightXpos
                duration: 2000
            }
            PropertyAnimation {
                target: dragTitle
                property: "opacity"
                from: 0
                to: 1
                duration: UbuntuAnimation.SleepyDuration
            }
        }

        PauseAnimation {
            duration: UbuntuAnimation.SleepyDuration
        }

        ParallelAnimation {
            PropertyAnimation {
                target: dragTitle
                property: "opacity"
                to: 0
                duration: UbuntuAnimation.SlowDuration
            }

            PropertyAnimation {
                target: listItem
                property: "xPos"
                from: slideAnimation.leftToRightXpos
                to: 0
                duration: UbuntuAnimation.SleepyDuration
            }
        }

        PropertyAction {
            target: dragMessage
            property: "text"
            value: i18n.tr("Swipe to delete")
        }

        PropertyAction {
            target: dragMessage
            property: "horizontalAlignment"
            value: Text.AlignRight
        }

        ParallelAnimation {
            PropertyAnimation {
                target: listItem
                property: "xPos"
                from: 0
                to: slideAnimation.rightToLeftXpos
                duration: UbuntuAnimation.SleepyDuration
            }
            PropertyAnimation {
                target: dragTitle
                property: "opacity"
                from: 0
                to: 1
                duration: UbuntuAnimation.SlowDuration
            }
        }

        PauseAnimation {
            duration: UbuntuAnimation.SleepyDuration
        }

        ParallelAnimation {
            PropertyAnimation {
                target: dragTitle
                property: "opacity"
                to: 0
                duration: UbuntuAnimation.SlowDuration
            }

            PropertyAnimation {
                target: listItem
                property: "xPos"
                from: slideAnimation.rightToLeftXpos
                to: 0
                duration: UbuntuAnimation.SleepyDuration
            }
        }

    }

    SequentialAnimation {
        id: dismissAnimation

        alwaysRunToEnd: true
        running: false

        UbuntuNumberAnimation {
            target: root
            property: "opacity"
            to: 0.0
            duration:  UbuntuAnimation.SlowDuration
        }
        ScriptAction {
            script: root.disable()
        }
    }

    Component.onCompleted: {
        opacity = 0.85
        pageHeader.visible = false
    }
}
