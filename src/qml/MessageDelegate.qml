/*
 * Copyright 2012, 2013, 2014 Canonical Ltd.
 *
 * This file is part of messaging-app.
 *
 * messaging-app is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * messaging-app is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.2

Item {
    id: messageDelegate

    property bool incoming
    property string accountLabel
    property var attachments
    property string accountId
    property var threadId
    property var eventId
    property var type
    property string text
    property var messageStatus
    property var timestamp

    property var _lastItem: messageDelegate


    function deleteMessage()
    {
        //virtual implemented by each Message type
    }

    function resend()
    {
        //virtual implemented by each Message type
    }

    function clicked(mouse)
    {
        //virtual implemented by each Message type
    }
}
