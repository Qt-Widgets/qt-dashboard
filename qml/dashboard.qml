/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.5
import QtQuick.Window 2.1
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4

Window {
    id: root
    visible: true
    width: 1024
    height: 600

    color: "#161616"
    title: "Qt Quick Extras Demo"

    ValueSource {
        id: valueSource
    }
    StackView {
        id: stack
        anchors.fill : parent
        initialItem: page1
        delegate: StackViewDelegate {
              function transitionFinished(properties)
              {
                  properties.exitItem.opacity = 1
              }

              pushTransition: StackViewTransition {
                  PropertyAnimation {
                      target: page1.container
                      property: "x"
                      from: root.width
                      to: 0
                  }
//                  PropertyAnimation {
//                      target: container2
//                      property: "opacity"
//                      from: 1
//                      to: 0
//                  }
              }
          }

        Component {
               id: page1
               //property alias x:container.x
    // Dashboards are typically in a landscape orientation, so we need to ensure
    // our height is never greater than our width.
                Item {
        id: container
        width: root.width
        height: Math.min(root.width, root.height)
        anchors.centerIn: parent

        Row {
            id: gaugeRow
            spacing: container.width * 0.02
            anchors.centerIn: parent

            TurnIndicator {
                id: leftIndicator
                anchors.verticalCenter: parent.verticalCenter
                width: height

                height: container.height * 0.1 - gaugeRow.spacing

                direction: Qt.LeftArrow
               // on: valueSource.turnSignal == Qt.LeftArrow
            }

            Item {
                id: twoGauge
                width: height
                height: container.height * 0.25 - gaugeRow.spacing
                anchors.verticalCenter: parent.verticalCenter

                CircularGauge {
                    id: fuelGauge
                    value: valueSource.fuel
                    maximumValue: 1
                    y: parent.height / 2 - height / 2 - container.height * 0.01
                    width: parent.width
                    height: parent.height * 0.7

                    style: IconGaugeStyle {
                        id: fuelGaugeStyle

                        icon: "qrc:/images/fuel-icon.png"
                        minWarningColor: Qt.rgba(0.5, 0, 0, 1)

                        tickmarkLabel: Text {
                            color: "white"
                            visible: styleData.value === 0 || styleData.value === 1
                            font.pixelSize: fuelGaugeStyle.toPixels(0.225)
                            text: styleData.value === 0 ? "E" : (styleData.value === 1 ? "F" : "")
                        }
                    }
                }

                CircularGauge {
                    value: valueSource.temperature
                    maximumValue: 1
                    width: parent.width
                    height: parent.height * 0.7
                    y: parent.height / 2 + container.height * 0.01

                    style: IconGaugeStyle {
                        id: tempGaugeStyle

                        icon: "qrc:/images/temperature-icon.png"
                        maxWarningColor: Qt.rgba(0.5, 0, 0, 1)

                        tickmarkLabel: Text {
                            color: "white"
                            visible: styleData.value === 0 || styleData.value === 1
                            font.pixelSize: tempGaugeStyle.toPixels(0.225)
                            text: styleData.value === 0 ? "C" : (styleData.value === 1 ? "H" : "")
                        }
                    }
                }
            }


            CircularGauge {
                id: speedometer
                value: valueSource.kph

                //anchors.fill: parent
               // anchors.verticalCenter: flick.verticalCenter



                maximumValue: 280
                // We set the width to the height, because the height will always be
                // the more limited factor. Also, all circular controls letterbox
                // their contents to ensure that they remain circular. However, we
                // don't want to extra space on the left and right of our gauges,
                // because they're laid out horizontally, and that would create
                // large horizontal gaps between gauges on wide screens.
                width: height
                height: container.height * 0.5
                //height: height
                style: DashboardGaugeStyle {}
                Flickable {
                       id: flick

                       //height: container.height * 0.5
                       anchors.fill: parent
                       contentWidth: parent.width
                       contentHeight: parent.height

                       PinchArea {
                           width: Math.max(flick.contentWidth, flick.width)
                             height: Math.max(flick.contentHeight, flick.height)

                             property real initialWidth
                             property real initialHeight
                             onPinchStarted: {
                                 initialWidth = flick.contentWidth
                                 initialHeight = flick.contentHeight
                             }

                             onPinchUpdated: {
                                 // adjust content pos due to drag
                                 flick.contentX += pinch.previousCenter.x - pinch.center.x
                                 flick.contentY += pinch.previousCenter.y - pinch.center.y

                                 // resize content
                                 flick.resizeContent(initialWidth * pinch.scale, initialHeight * pinch.scale, pinch.center)
                             }

                             onPinchFinished: {
                                 // Move its content within bounds.
                                 flick.returnToBounds()
                             }

                              anchors.fill: parent
                              pinch.target: speedometer
                              pinch.minimumRotation: -360
                              pinch.maximumRotation: 360
                              pinch.minimumScale: 0.1
                              pinch.maximumScale: 10
                              pinch.dragAxis: Pinch.XAndYAxis
                              //onPinchStarted: setFrameColor()

                              property real zRestore: 0
                              onSmartZoom: {
                                  if (pinch.scale > 0) {
                                      speedometer.rotation = 0;
                                      speedometer.scale = 1.0
                                      speedometer.x = flick.contentX + (flick.width - speedometer.width) / 2
                                      speedometer.y = flick.contentY + (flick.height - speedometer.height) / 2

                                  } else {
                                      speedometer.rotation = pinch.previousAngle
                                      speedometer.scale = pinch.previousScale
                                      speedometer.x = pinch.previousCenter.x - speedometer.width / 2
                                      speedometer.y = pinch.previousCenter.y - speedometer.height / 2

                                  }
                              }

                       }

                       Rectangle {
                           width: flick.contentWidth
                           height: flick.contentHeight
                           x:flick.x
                           y:flick.y
                           color:"#00000000"


                       MouseArea {
                                              id: dragArea
                                              hoverEnabled: true
                                              anchors.fill: parent
                                              drag.target: speedometer
                                              drag.axis : Drag.XAndYAxis
                                              scrollGestureEnabled: false  // 2-finger-flick gesture should pass through to the Flickable
                                              onPressed: {
                                                  //root.z = ++root.highestZ;
                                                  //setFrameColor();
                                              }
                                              onDoubleClicked: {
                                                     if(speedometer.scale > 1){
                                                        speedometer.scale = 1;
                                                        speedometer.rotation = 0;

// console.log("speed x  gaugeRow.x ", speedometer.x, leftIndicator.width , twoGauge.width , 2* gaugeRow.spacing)
                                                        speedometer.x = gaugeRow.x +leftIndicator.width + gaugeRow.spacing
                                                        //console.log("speed y  gaugeRow.y ", speedometer.y, gaugeRow.y)
                                                         speedometer.y = 0


                                                        }
                                                     else{
                                                         //speedometer.anchors.verticalCenter =  gaugeRow.verticalCenter
                                                         speedometer.scale = Math.min(root.width / speedometer.width, root.height/speedometer.height)
                                                         speedometer.rotation = 0;
//                                                         speedometer.width = root.width;
//                                                        speedometer.height = root.width;
//                                                         speedometer.x = root.x;
//                                                         speedometer.y = root.y;
                                                     }



                                                 //flick.contentWidth = 400
                                                  //flick.contentHeight = 400
                                               //speedometer.width = speedometer.defaultWidth
                                               //speedometer.height = speedometer.defaultHeight
                                              }
                                              //onEntered: setFrameColor();
                                              onWheel: {
                                                  if (wheel.modifiers & Qt.ControlModifier) {
                                                      speedometer.rotation += wheel.angleDelta.y / 120 * 5;
                                                      if (Math.abs(speedometer.rotation) < 4)
                                                          speedometer.rotation = 0;
                                                  } else {
                                                      speedometer.rotation += wheel.angleDelta.x / 120;
                                                      if (Math.abs(speedometer.rotation) < 0.6)
                                                          speedometer.rotation = 0;
                                                      var scaleBefore = speedometer.scale;
                                                      speedometer.scale += speedometer.scale * wheel.angleDelta.y / 120 / 10;
                                                  }
                                              }


                                             onPressAndHold:{
                                                //console.log("pressandhold")

                                                 popMenu.popup()

                                              }
                                          }
                       }
                       }
            }
            CircularGauge {
                id: tachometer
                width: height
                height: container.height * 0.25 - gaugeRow.spacing
                value: valueSource.rpm
                maximumValue: 8
                anchors.verticalCenter: parent.verticalCenter

                style: TachometerStyle {}
            }

            TurnIndicator {
                id: rightIndicator
                anchors.verticalCenter: parent.verticalCenter
                width: height
                height: container.height * 0.1 - gaugeRow.spacing

                direction: Qt.RightArrow
               // on: valueSource.turnSignal == Qt.RightArrow
            }

        }

        TurnIndicator {
            id: turnIndicator1
            x: 0
            y: 275
            width: 75
            height: 50
            flashing: true
            direction: 4
            on: true
            Flickable {
                anchors.fill: parent
                flickableDirection:  Flickable.HorizontalFlick
                onFlickEnded:stack.depth == 1? stack.push(page2):stack.pop(page2)
            }

        }
        }
        }
        Component {
            id:page2

            Item {
                id: container2
                width: root.width
                height: Math.min(root.width, root.height)
                anchors.centerIn: parent
                Rectangle {
                    width: parent.width - turnIndicator2.width
                    height: parent.height
                    color:"#00000000"
                    Flickable {
                          width: parent.width
                          height: parent.height

                          //opacity: 0
                          contentWidth: image.width; contentHeight: image.height

                          Image { id: image; source: "qrc:/images/bigmap.jpg";}
                      }
                }



                TurnIndicator {
                    id: turnIndicator2
                    x: root.width - width
                    y: 275
                    width: 75
                    height: 50
                    flashing: true
                    direction: 3
                    on: true
                    Flickable {
                        anchors.fill: parent

                        flickableDirection:  Flickable.HorizontalFlick
                        onFlickEnded: stack.pop(page1)//console.log("origin" , originX, originY, atXBeginning)
                    }


                  }

             }
         }
    }
    PopMenu {
        id: popMenu
     }


}
