import os
import sys

from PyQt5.QtCore import QUrl
from PyQt5.QtGui import QIcon
from PyQt5.QtWidgets import QApplication
from PyQt5.QtQml import QQmlApplicationEngine
from PyQt5.QtMultimedia import QMultimedia

CURRENT_DIR = os.path.dirname(os.path.realpath(__file__))

if __name__ == "__main__":
    app = QApplication(sys.argv)
    app.setWindowIcon(QIcon(os.path.join(CURRENT_DIR, "movie-app-icon-12.jpg")))
    app.setApplicationName("BlueBoxx")
    app.setApplicationDisplayName("BlueBoxx")
    app.setDesktopFileName("BlueBoxx")
    engine = QQmlApplicationEngine()
    engine.load(QUrl.fromLocalFile(os.path.join(CURRENT_DIR, "main.qml")))

    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec_())
