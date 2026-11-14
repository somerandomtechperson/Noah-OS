import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.welcome

Page {
    heading: i18nc("@info:window", "Discover NoahOS")
    description: i18nc("@info:usagetip", "A Linux desktop built around simplicity, customization, and control.")

    ColumnLayout {
        spacing: Kirigami.Units.largeSpacing

        Image {
            Layout.alignment: Qt.AlignHCenter
            source: "file:///usr/share/plasma/look-and-feel/com.noahos.desktop/contents/splash/images/noahos-logo.png"
            sourceSize.width: 144
            sourceSize.height: 144
            fillMode: Image.PreserveAspectFit
        }

        QQC2.Label {
            Layout.fillWidth: true
            text: i18n("Welcome to your NoahOS desktop. Explore the system, make it your own, and discover what it can do.")
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
        }

        QQC2.Button {
            Layout.fillWidth: true
            text: i18n("Visit the NoahOS website")
            icon.name: "internet-web-browser"
            onClicked: Qt.openUrlExternally("https://somerandomtechperson.github.io/Noah-OS/")
        }

        QQC2.Button {
            Layout.fillWidth: true
            text: i18n("Explore NoahOS on GitHub")
            icon.name: "github"
            onClicked: Qt.openUrlExternally("https://github.com/somerandomtechperson/Noah-OS")
        }
    }
}
