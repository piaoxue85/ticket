import QtQuick 2.1
import "../Common" as Common
import "../Widgets" as Widgets

Column {
    id: root
    spacing: 12
    signal grabClicked
    signal queryClicked
    
    Row {
        spacing: 20
        Column {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 5
            Widgets.NativeText {
                /* anchors.horizontalCenter: parent.horizontalCenter */
                text: "出发站"
                color: "#333333"
                font.pixelSize: 14
            }
            Widgets.CompleteInput {
                id: fromStation
                anchors.horizontalCenter: parent.horizontalCenter            
                width: 80
                model: Poster.newStationModel()
            }
        }        
            
        Common.ImageButton {
            anchors.verticalCenter: parent.verticalCenter
            normalImage: "qrc:/images/common/exchange_normal.png"
            hoverImage: "qrc:/images/common/exchange_press.png"
            pressImage: "qrc:/images/common/exchange_press.png"
            onClicked: {
                var fromText = fromStation.text
                var toText = toStation.text
                var fromTelecode = fromStation.telecode
                var toTelecode = toStation.telecode
                fromStation.setName(toText)
                toStation.setName(fromText)
                fromStation.telecode = toTelecode
                toStation.telecode = fromTelecode
            }
        }
            
        Column {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 5
            Widgets.NativeText {
                /* anchors.horizontalCenter: parent.horizontalCenter             */
                text: "目的站"
                font.pixelSize: 14
                color: "#333333"
            }
            Widgets.CompleteInput {
                id: toStation
                anchors.horizontalCenter: parent.horizontalCenter            
                width: 80
                model: Poster.newStationModel()
            }
        }        
        z: 1000
    }
    
    Row {
        spacing: 10
        Widgets.NativeText { text: "乘车日期"; color: "#333333"; anchors.verticalCenter: parent.verticalCenter; font.pixelSize: 14 }
        Widgets.Calendar { id: calendar; anchors.verticalCenter: parent.verticalCenter; width: 182}
    }
    
    
    
    Row {
        Widgets.NativeText { text: "选择乘客"; color: "#333333"; anchors.verticalCenter: parent.verticalCenter; font.pixelSize: 14 }
        PassengerView {
            width: 250
        }
        spacing: 10
        z: 800
    }
        
    Row {
        Widgets.NativeText { text: "期望车次"; color: "#333333"; anchors.verticalCenter: parent.verticalCenter; font.pixelSize: 14 }
        TrainView {
            width: 250
            enabled: fromStation.telecode && toStation.telecode && calendar.text
            onClicked: {
                model.queryTrains(fromStation.telecode, toStation.telecode, calendar.text)
            }
        }
        spacing: 10
        z: 700        
    }
    

    Row {
        Widgets.NativeText { text: "期望席别"; color: "#333333"; anchors.verticalCenter: parent.verticalCenter; font.pixelSize: 14 }
        SeatView {
            width: 250
        }
        spacing: 10
        z: 600        
    }

    Row {
        spacing: 50
        
        Widgets.Button {
            text: "查询票数"
            width: 100; height: 36
            normalColor: "#fc9416"
            pressColor: "#e88002"
            onClicked: {
                queryClicked()                
                Poster.queryTrainModel().queryTrains(fromStation.telecode, toStation.telecode, calendar.text)
            }
        }
        
        Widgets.Button {
            text: "开始抢票"
            width:100 ; height: 36
            onClicked: {
                if (fromStation.telecode != "" && toStation.telecode != "" && calendar.text) {
                    grabClicked()        
                    Poster.grabQueryTickets(fromStation.telecode, toStation.telecode, calendar.text)
                }
            }
        }
    }
}
