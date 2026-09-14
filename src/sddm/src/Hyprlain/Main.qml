// Qt6 port: SDDM 0.21+ ships only the Qt6 greeter on Fedora (and increasingly
// elsewhere), and Qt6 has no QtQuick.Controls 1 / Controls.Styles.
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic as Qqc
import QtQuick.Window
import QtMultimedia
import SddmComponents 2.0

Rectangle {
	color: "black"
	width: Window.width
	height: Window.height

	// Login feedback: besides the denied sound, clear the field, show a
	// message and refocus the password box, so a rejected password is obvious
	// even with the sound muted.
	Connections {
		target: sddm
		function onLoginSucceeded() {
			errorMsg.text = ""
		}
		function onLoginFailed() {
			denied.play()
			errorMsg.text = "Login failed — wrong password?"
			password.text = ""
			password.focus = true
		}
	}

	AnimatedImage {
		width: parent.width
		height: parent.height
		fillMode: Image.Tile
		source: "assets/bg_darker.gif"
	}

	AnimatedImage {
		width: parent.width
		height: parent.height
		fillMode: Image.Tile
		source: "assets/bg_dark_anim_0_08.gif"
	}

	ColumnLayout {
		width: parent.width
		height: parent.height
		AnimatedImage{
			Layout.alignment: Qt.AlignCenter
			Layout.topMargin: 2
			Layout.preferredWidth: 192
			Layout.preferredHeight: 192
			width: 192
			height: 192
			source: "assets/wiredLogInNew_512px_06.gif"
		}
		Qqc.Label {
			Layout.alignment: Qt.AlignCenter
			text: "U s e r  I D:"
			color: "#c1b492"
		}
		Qqc.TextField {
			id: username
			Layout.alignment: Qt.AlignCenter
			text: userModel.lastUser
			color: "#c1b492"
			background: Rectangle {
				color: "#000"
				implicitWidth: 200
				border.color: username.activeFocus ? "#f5b3c4" : "#d2738a"
				border.width: username.activeFocus ? 2 : 1
			}
			KeyNavigation.backtab: shutdownBtn; KeyNavigation.tab: password
			Keys.onPressed: (event) => {
				if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
					sddm.login(username.text, password.text, session.index)
					event.accepted = true
				}
			}
		}
		Qqc.Label {
			Layout.alignment: Qt.AlignCenter
			text: "P a s s w o r d:"
			color: "#c1b492"
		}
		Qqc.TextField {
			id: password
			echoMode: TextInput.Password
			Layout.alignment: Qt.AlignCenter
			color: "#c1b492"
			background: Rectangle {
				color: "#000"
				implicitWidth: 200
				border.color: password.activeFocus ? "#f5b3c4" : "#d2738a"
				border.width: password.activeFocus ? 2 : 1
			}
			KeyNavigation.backtab: username; KeyNavigation.tab: session
			Keys.onPressed: (event) => {
				if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
					sddm.login(username.text, password.text, session.index)
					event.accepted = true
				}
			}
		}
		// Caps Lock warning: the single most common cause of a "correct"
		// password being rejected, and invisible without this.
		Qqc.Label {
			Layout.alignment: Qt.AlignCenter
			text: "⚠ Caps Lock is ON"
			color: "#ff5c5c"
			visible: keyboard.capsLock
		}
		Rectangle {
			Layout.alignment: Qt.AlignCenter
			Layout.topMargin: 4
			Layout.bottomMargin: 6
			implicitWidth: 200
			implicitHeight: loginLabel.implicitHeight + 4
			color: "#d2738a"
			Qqc.Label {
				id: loginLabel
				anchors.centerIn: parent
				text: "L o g i n"
				color: "#c1b492"
			}
			MouseArea {
				anchors.fill: parent
				onClicked: sddm.login(username.text, password.text, session.index)
			}
		}
		// Failure message. Empty until sddm reports a failed login.
		Qqc.Label {
			id: errorMsg
			Layout.alignment: Qt.AlignCenter
			Layout.bottomMargin: 40
			text: ""
			color: "#ff5c5c"
		}
	}
	AnimatedImage {
		id: shutdownBtn
		height: 80
		width: 80
		y: 10
		x: Window.width - width - 10
		source: "assets/VisLain.gif"
		fillMode: Image.PreserveAspectFit
		MouseArea {
			anchors.fill: parent
			hoverEnabled: true
			onClicked: sddm.powerOff()
			onEntered: {
				var component = Qt.createComponent("ShutdownToolTip.qml");
				if (component.status == Component.Ready) {
					var tooltip = component.createObject(shutdownBtn);
					tooltip.x = -45
					tooltip.y = 60
				tooltip.destroy(500);
				}
			}
		}
	}
	AnimatedImage {
		id: rebootBtn
		anchors.right: shutdownBtn.left
		anchors.rightMargin: 5
		y: shutdownBtn.y + 10
		height: 70
		width: 60
		source: "assets/lain_myese.gif"
		fillMode: Image.PreserveAspectFit
		MouseArea {
			anchors.fill: parent
			hoverEnabled: true
			onClicked: sddm.reboot()
			onEntered: {
				var component = Qt.createComponent("RebootToolTip.qml");
				if (component.status == Component.Ready) {
					var tooltip = component.createObject(rebootBtn);
					tooltip.x = -45
					tooltip.y = 50
				tooltip.destroy(500);
				}
			}
		}
	}
	ComboBox {
		id: session
		height: 30
		width: 200
		x: 15
		y: 20
		model: sessionModel
		index: sessionModel.lastIndex
		color: "#000"
		borderColor: "#d2738a"
		focusColor: "#d2738a"
		hoverColor: "#d2738a"
		textColor: "#c1b492"
		arrowIcon: Qt.resolvedUrl("assets/angle-down.png")
		KeyNavigation.backtab: password; KeyNavigation.tab: rebootBtn;
	}
	// Current keyboard layout, so a wrong-layout password is easy to spot.
	Qqc.Label {
		anchors.left: parent.left
		anchors.leftMargin: 15
		y: 55
		text: {
			var l = keyboard.layouts
			if (!l || l.length === 0) return ""
			var cur = l[keyboard.currentLayout]
			return cur ? "layout: " + cur.shortName : ""
		}
		color: "#c1b492"
	}
	// Qt6 has no Audio element; SoundEffect plays the same wav assets.
	SoundEffect {
		id: bgMusic
		source: "assets/powerline.wav"
		loops: SoundEffect.Infinite
	}
	SoundEffect {
		id: welcome
		source: "assets/welcome.wav"
	}
	SoundEffect {
		id: denied
		source: "assets/denied.wav"
	}
	Component.onCompleted: {
		bgMusic.play()
		welcome.play()
		if (username.text == "") {
			username.focus = true
		} else {
			password.focus = true
		}
	}
}
