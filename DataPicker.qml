import VPlayApps 1.0 as VP
import QtQuick 2.5
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0


Item {
    z: 100
    id: calendarView

    property bool dateVisible: false
    property string placeholderText: qStr("Date")
    property string currentDate: (new Date).toLocaleString(Qt.locale(), "dd-MM-yyyy")
    property int yearStart: (new Date).toLocaleString(Qt.locale(), "yyyy") - 100
    property int yearEnd: (new Date).toLocaleString(Qt.locale(), "yyyy")
    property date selectedDay: Date.fromLocaleString(Qt.locale(), currentDate, "dd-MM-yyyy")
    property string selectedItemColor: "orange"

    signal dateChanged(date dateValue)

    RowLayout {
        width: parent.width
        anchors.verticalCenter: parent.verticalCenter
        VP.AppTextField {
            id: dataTextCaption
            placeholderText: calendarView.placeholderText
            readOnly: true
        }
        VP.AppText {
            id: dataText
            text: currentDate
        }
        MouseArea {
            anchors.fill: parent
            onClicked: dateVisible = true
        }
    }

    Rectangle {
        id: mainrec
        visible: dateVisible
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: controlDay.width + controlMonth.width + controlYear.width
        height: controlDay.height + buttonOk.height + 20
        border.color: "gray"
        z: 100

        //property int yearStart: 2015
        //property int yearEnd: yearStart + 50

        property int dayWidth: screenWidth / 5
        property int monthWidth: screenWidth / 4
        property int yearWidth: screenWidth / 5
        property int heightTumbler:  screenHeight / 3

        function daysInMonth(month,year) {
            return new Date(year, month, 0).getDate();
        }

        function yearsModel() {
            var years = [];
            for (var i = 0; i < (yearEnd - yearStart); i++)
                years[i] = yearStart + i
            return years;
        }

        Component.onCompleted: {
            selectedDay = Date.fromLocaleString(Qt.locale(), currentDate, "dd-MM-yyyy")
            controlDay.model = mainrec.daysInMonth(selectedDay.getMonth(), selectedDay.getFullYear())
            controlMonth.currentIndex = selectedDay.getMonth()
            controlYear.currentIndex = yearsModel().indexOf(selectedDay.getFullYear())
            controlDay.currentIndex = selectedDay.getDate() - 1
        }
        Column {
            spacing: 20
            Row
            {
                Tumbler {
                    id: controlDay
                    model: 0
                    visibleItemCount: 5
                    width: mainrec.dayWidth
                    height: mainrec.heightTumbler
                    background: Item {
                        Rectangle {
                            opacity: controlDay.enabled ? 0.2 : 0.1
                            border.color: "#000000"
                            width: parent.width - 10
                            height: 1
                            anchors.top: parent.top
                        }

                        Rectangle {
                            opacity: controlDay.enabled ? 0.2 : 0.1
                            border.color: "#000000"
                            width: parent.width - 10
                            height: 1
                            anchors.bottom: parent.bottom
                        }
                    }

                    delegate: VP.AppText {
                        id: dayText
                        text: modelData + 1
                        font.pixelSize: sp(18)
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        color: (index == controlDay.currentIndex)? selectedItemColor: "black"
                        opacity: 1.0 - Math.abs(Tumbler.displacement) / (controlDay.visibleItemCount / 2)
                    }

                    Rectangle {
                        anchors.horizontalCenter: controlDay.horizontalCenter
                        y: controlDay.height * 0.4
                        width: mainrec.dayWidth - 10
                        height: 2
                        color: "#ff9500"
                    }

                    Rectangle {
                        anchors.horizontalCenter: controlDay.horizontalCenter
                        y: controlDay.height * 0.6
                        width: mainrec.dayWidth - 10
                        height: 2
                        color: "#ff9500"
                    }
                }
                Tumbler {
                    id: controlMonth

                    model: 12
                    visibleItemCount: 5
                    width: mainrec.monthWidth
                    height: mainrec.heightTumbler
                    background: Item {
                        Rectangle {
                            opacity: controlMonth.enabled ? 0.2 : 0.1
                            border.color: "#000000"
                            width: controlMonth.width - 10
                            height: 1
                            anchors.top: parent.top
                        }

                        Rectangle {
                            opacity: controlMonth.enabled ? 0.2 : 0.1
                            border.color: "#000000"
                            width: parent.width - 10
                            height: 1
                            anchors.bottom: parent.bottom
                        }
                    }

                    delegate: VP.AppText {
                        id: monthText
                        text: Qt.locale().monthName(index)
                        font.pixelSize: sp(18)
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        opacity: 1.0 - Math.abs(Tumbler.displacement) / (controlMonth.visibleItemCount / 2)
                        color: (index == controlMonth.currentIndex)? selectedItemColor: "black"
                        Component.onCompleted: {
                            //mainrec.monthWidth = (monthText.width > mainrec.monthWidth)?monthText.width: mainrec.monthWidth
                        }
                    }

                    Rectangle {
                        anchors.horizontalCenter: controlMonth.horizontalCenter
                        y: controlMonth.height * 0.4
                        width: mainrec.dayWidth - 10
                        height: 2
                        color: "#ff9500"
                    }

                    Rectangle {
                        anchors.horizontalCenter: controlMonth.horizontalCenter
                        y: controlMonth.height * 0.6
                        width: mainrec.dayWidth - 10
                        height: 2
                        color: "#ff9500"
                    }
                    onCurrentIndexChanged: {
                        controlDay.model = new Date(controlYear.currentItem.text, currentIndex + 1, 0).getDate()
                    }
                }
                Tumbler {
                    id: controlYear

                    model: mainrec.yearsModel()
                    visibleItemCount: 5
                    width: mainrec.yearWidth
                    height: mainrec.heightTumbler
                    background: Item {
                        Rectangle {
                            opacity: controlYear.enabled ? 0.2 : 0.1
                            border.color: "#000000"
                            width: parent.width - 10
                            height: 1
                            anchors.top: parent.top
                        }

                        Rectangle {
                            opacity: controlYear.enabled ? 0.2 : 0.1
                            border.color: "#000000"
                            width: parent.width - 10
                            height: 1
                            anchors.bottom: parent.bottom
                        }
                    }

                    delegate: VP.AppText {
                        id: yearText
                        text: modelData
                        font.pixelSize: sp(18)
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        opacity: 1.0 - Math.abs(Tumbler.displacement) / (controlYear.visibleItemCount / 2)
                        color: (index == controlYear.currentIndex)?selectedItemColor: "black"
                    }

                    Rectangle {
                        anchors.horizontalCenter: controlYear.horizontalCenter
                        y: controlYear.height * 0.4
                        width: mainrec.dayWidth - 10
                        height: 2
                        color: "#ff9500"
                    }

                    Rectangle {
                        anchors.horizontalCenter: controlYear.horizontalCenter
                        y: controlYear.height * 0.6
                        width: mainrec.dayWidth - 10
                        height: 2
                        color: "#ff9500"
                    }
                    onCurrentIndexChanged: {
                        controlDay.model = new Date(currentItem.text, controlMonth.currentIndex + 1, 0).getDate()
                    }
                }
            }
        }
        VP.AppButton {
            id: buttonCancel
            text: qsTr("Annulla")
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            onClicked: {
                dateVisible = false
            }
        }

        VP.AppButton {
            id: buttonOk
            text: qsTr("Conferma")
            Layout.alignment: Qt.AlignRight
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            onClicked: {
                var date = new Date();
                date.setFullYear(controlYear.currentItem.text);
                date.setDate(controlDay.currentIndex + 1);
                date.setMonth(controlMonth.currentIndex)
                dateChanged(date)
                dateVisible = false

                currentDate = date.toLocaleString(Qt.locale(), "dd-MM-yyyy")
            }
        }
    }
}
